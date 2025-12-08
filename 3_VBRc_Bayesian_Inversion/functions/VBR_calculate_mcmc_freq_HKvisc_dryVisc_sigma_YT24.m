function [VBR] = VBR_calculate_mcmc_freq_HKvisc_dryVisc_sigma_YT24(m,zvec,modn,t_Myr,CO2_ppm,vbr_method,modeltype,path2perlextab_rho, path2perlextab_vs, path2perlextab_vp, freq, sig_MPa)
% Run VBR + perplex for a single instance of MCMC chain

% Unpack parameters
Ch2o_bulk_ppm = m(1:3);
logdg_mm = m(4:6);
Tp_C = m(7);
if strcmpi(modeltype,'plate')
    z_plate_km = m(8);
end

zdiscs = modn.Ch2o_bulk_ppm.zlay;

%%

VBR.in.elastic.methods_list={'anharmonic','anh_poro'};
VBR.in.elastic.anharmonic=Params_Elastic('anharmonic'); % unrelaxed elasticity

VBR.in.anelastic.methods_list={vbr_method}; %{'andrade_psp';'xfit_mxw'};
VBR.in.anelastic.(vbr_method)=Params_Anelastic(vbr_method);

VBR.in.viscous.methods_list={'HK2003'};

% VBR.in.SV.f = 1./[5 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150]; %1./logspace(-2,4,100);
% VBR.in.SV.f = 1./round(logspace(log10(20),log10(150),15)); %logspace(-2.2,-1.3,10); % VBR sweep default
VBR.in.SV.f = freq;

% Operations specific to each method
if strcmp(vbr_method,'eburgers_psp')
    % VBR.in.anelastic.eburgers_psp.eBurgerFit='bg_only'; % 'bg_only' or 'bg_peak' or 's6585_bg_only'
    VBR.in.anelastic.eburgers_psp.eBurgerFit='bg_peak'; % 'bg_only' or 'bg_peak' or 's6585_bg_only'
    % Use HK2003 for viscous method
    VBR.in.anelastic.eburgers_psp.useJF10visc = 0;

elseif strcmp(vbr_method,'andrade_psp')
elseif strcmp(vbr_method,'xfit_mxw')
elseif strcmp(vbr_method,'xfit_premelt')
    VBR.in.viscous.xfit_premelt = Params_Viscous('xfit_premelt');
    % VBR.in.viscous.xfit_premelt.eta_dry_method = 'HK2003';
    VBR.in.viscous.xfit_premelt.eta_melt_free_method = 'HK2003';
    VBR.in.anelastic.xfit_premelt.include_direct_melt_effect = 1;
end

%% Do VBR Calculations
HF.modeltype = modeltype;
HF.t_Myr = t_Myr+1e-12;
HF.Tp_C = Tp_C;
if strcmpi(HF.modeltype,'hsc')
    [ HF.z_m,HF.T_K,HF.P_GPa,HF.rho_kgm3 ] = calc_HSC( HF.Tp_C+273,HF.t_Myr, zvec*1000 );
elseif strcmpi(HF.modeltype,'plate')
    HF.z_plate_km = z_plate_km;
    [ HF.z_m,HF.T_K,HF.P_GPa,HF.rho_kgm3 ] = calc_platecooling( HF.Tp_C+273,HF.t_Myr,HF.z_plate_km, zvec*1000 );
end
HF.T_C = HF.T_K - 273;
HF.z_km = HF.z_m/1000;

% copy cooling model into VBR state variables, adjust units as needed
VBR.in.SV.T_K = HF.T_K(:); % set HF temperature, convert to K
VBR.in.SV.P_GPa = HF.P_GPa(:); % pressure [GPa]

%% Extract Perple_X Density Profiles
% Load tab data
[x,y,z,~,~,~,~,~,~,~,~] = load_perple_x_tab(path2perlextab_rho);
T_perplex=x; P_perplex=y/10000; Z_perplex=z;
% Extract property along the defined T-P path
[ ~,~,Z,depth ] = extract_PTpath( VBR.in.SV.P_GPa,VBR.in.SV.T_K,HF.z_m,P_perplex,T_perplex,Z_perplex );
perplex.rho = Z;
perplex.rho = smooth(perplex.rho,10);
perplex.depth = depth;
VBR.in.SV.rho = perplex.rho(:); % density [kg m^-3]

% Extract Perple_X Vs Profiles

% Load tab data
[x,y,z,xname,yname,zname,nvar,mvar,nrow,dnames,titl] = load_perple_x_tab(path2perlextab_vs);
T_perplex=x; P_perplex=y/10000; Z_perplex=z;

% Extract property along the defined T-P path
[ P,T,Z,depth ] = extract_PTpath( VBR.in.SV.P_GPa,VBR.in.SV.T_K,HF.z_m,P_perplex,T_perplex,Z_perplex );
perplex.vs = Z*1000;
perplex.depth = depth;
perplex.vs = smooth(perplex.vs,10);

% Load Vp
[x,y,z,~,~,~,~,~,~,~,~] = load_perple_x_tab(path2perlextab_vp);
T_perplex=x; P_perplex=y/10000; Z_perplex=z;
% Extract property along the defined T-P path
[ ~,~,Z,depth ] = extract_PTpath( VBR.in.SV.P_GPa,VBR.in.SV.T_K,HF.z_m,P_perplex,T_perplex,Z_perplex );
perplex.vp = Z*1000;
perplex.vp = smooth(perplex.vp,10);

perplex.G = perplex.rho .* perplex.vs.^2;
perplex.K = perplex.rho .* (perplex.vp.^2 - 4/3.*perplex.vs.^2);

VBR.in.elastic.Gu_TP = perplex.G(:); % [Pa]
VBR.in.elastic.Ku_TP = perplex.K(:); % [Pa]

%%
% set the other state variables as matrices of same size
sz=size(HF.T_K(:));
VBR.in.SV.sig_MPa = sig_MPa * ones(sz); %1 * ones(sz); % differential stress [MPa]

VBR.in.SV.dg_um = 10.^(logdg_mm(end)) * ones(sz) * 1000; % grain size [um]
H2O_solid_ppm = Ch2o_bulk_ppm(end) * ones(sz);
CO2_solid_ppm = CO2_ppm * ones(sz);

for iz = 1:length(zdiscs)-1
    VBR.in.SV.dg_um(HF.z_km>=zdiscs(iz) & HF.z_km<zdiscs(iz+1)) = 10.^(logdg_mm(iz)) * 1000;
    H2O_solid_ppm(HF.z_km>=zdiscs(iz) & HF.z_km<zdiscs(iz+1)) = Ch2o_bulk_ppm(iz);
end

kd_H2O = 1e-2; % equillibrium partition coefficient for H2O
kd_CO2 = 0; %1e-4; % equillibrium partition coefficient for CO2

% Solve for thermodynamically stable melt fraction;
solution = solve_for_stable_melt_fraction(HF.T_K(:),HF.P_GPa(:),H2O_solid_ppm(:),kd_H2O,CO2_solid_ppm(:),kd_CO2,'katz');
VBR.in.SV.Tsolidus_K = solution.Tsolidus_K(:); % [K] 
VBR.in.SV.phi = solution.phi(:); % melt fraction
VBR.solution = solution;

% Deal with H2O effect on viscosity
if strcmp(vbr_method,'xfit_premelt')
    % For xfit_premelt, water effect on diffusion viscosity is already
    % accounted for by the solidus effect on premelting (Yabe & Hiraga, 2020).
    % Therefore, set Ch2o = 0
    VBR.in.SV.Ch2o = zeros(size(VBR.solution.Cs_H2O_ppm));
else
    % Add H2O effect on viscosity
    VBR.in.SV.Ch2o = VBR.solution.Cs_H2O_ppm;
end

[VBR] = VBR_spine(VBR) ;

if strcmp(vbr_method,'xfit_premelt')
    % Add H2O back to vector after running VBRc
    VBR.in.SV.Ch2o = VBR.solution.Cs_H2O_ppm;
end

end

