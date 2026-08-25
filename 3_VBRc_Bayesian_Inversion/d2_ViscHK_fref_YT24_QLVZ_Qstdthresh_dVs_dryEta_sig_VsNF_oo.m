% Test simple Markov chain Monte Carlo Bayesian inversion for 3-layer
% velocity model. The method mostly follows Shen et al. (2013) GJI doi:10.1093/gji/ggs050
% This version uses smooth splines rather than layers.
%
% jbrussell 9/7/2022
%
clear

path_to_top_level_vbr='../VBRc/vbr_YT24/';
addpath(path_to_top_level_vbr)
% addpath([path_to_top_level_vbr,'/JBR_thesis/']);
vbr_init

% Add perplex paths
addpath('../Perple_X/Simple_X/functions/');
path2perlextab_vs = '../Perple_X/Simple_X/RESULTS/Hacker08_noky_400km_stx21/stx21_vs.tabs';
path2perlextab_vp = '../Perple_X/Simple_X/RESULTS/Hacker08_noky_400km_stx21/stx21_vp.tabs';
path2perlextab_rho = '../Perple_X/Simple_X/RESULTS/Hacker08_noky_400km_stx21/stx21_rho.tabs';

path2bayesian_out = './bayesian_mcmc_vbr_YT24/';
is_save = 1;
is_resume_progress = 0; % Resume from "_PROGRESS" file?
addpath('./functions/')
addpath('../functions/')

%% VBR parameters

% vbr_method = 'eburgers_psp';
param.vbr_method = 'xfit_premelt';
% vbr_method = 'xfit_mxw';

param.modeltype = 'plate'; % 'plate' || 'HSC'

param.CO2_ppm = 100; % assumed CO2 concentration

param.Vs_min = 4; % (km/s) minimum allowed velocity
param.Qinv_max = 0.1; % maximum allowed attenuation

%%
% path2bootstrap_Vs = './lsqr_kernel_Vs_vpvsPerplex_Qcorr_bootstrap/';
path2bootstrap_Vs = './lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap_smLVZdQdz/';
type = 'disc'; %'disc'; % 'smooth' or 'disc'
% path2bootstrap_Q = './bayesian_mcmc_Qspline_zknot/';
path2bootstrap_Q = './bayesian_mcmc_Qspline_zknot_112s/';

%% JdF
% param.bootstraps_Vs = 'JdF_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
% param.bootstraps_Q = 'JdF_uniform_Qmu_bayesian_Nspline12.mat';
% param.is_err2sigma = 1; % are errors in data file 2-sigma?
% param.age_Myr = 3; % seafloor age
% PROJ = 'JdF';
% prior_type = 'uniform';
% par.zmax = 250; % [km] Maximum depth of model to consider
% par.zmin = 40; %par.zmoho;

%% Young ORCA
% param.bootstraps_Vs = 'YoungORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
% param.bootstraps_Q = 'YoungORCA_uniform_Qmu_bayesian_Nspline12.mat';
% param.is_err2sigma = 1; % are errors in data file 2-sigma?
% param.age_Myr = 43; % seafloor age
% param.PROJ = 'Young ORCA';
% param.prior_type = 'uniform';
% par.zmax = 250; %225; %300; % [km] Maximum depth of model to consider
% par.zmin = 40; %par.zmoho;
% param.fac_Vs = 1e-3 * 10; % factor to multiply misfit to get in reasonable range
% param.fac_Qinv = 1e-4 * 10 * 10; % factor to multiply misfit to get in reasonable range
% param.fac_stdQinv_LVZ = 0.1; % factor to multiply Q std in LVZ
% param.fref_Qcorr = 1/65; % [Hz] reference frequency
% param.min_Qinv_std = 0.001; % uncertainty threshold to avoid very small values
% param.thresh_dVs_reduc_perc = -0.05; %-0.5; % Vs reduction below which to consider misfit within layer 1 ( dVs = (Vs ./ Vsu - 1)*100 )
% param.sig_MPa = 0.4; % [MPa] differential stress

%% NoMelt
% param.bootstraps_Vs = 'NoMelt_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
% param.bootstraps_Q = 'NoMelt_uniform_Qmu_bayesian_Nspline12.mat';
% param.is_err2sigma = 1; % are errors in data file 2-sigma?
% param.age_Myr = 70; % seafloor age
% param.PROJ = 'NoMelt';
% param.prior_type = 'uniform';
% par.zmax = 250; %300; % [km] Maximum depth of model to consider
% par.zmin = 40; %par.zmoho;
% param.fac_Vs = 1e-3 * 10; %1e-3; % factor to multiply misfit to get in reasonable range
% param.fac_Qinv = 1e-2 * 5 * 10; %1e-4; % factor to multiply misfit to get in reasonable range
% param.fac_stdQinv_LVZ = 1; % factor to multiply Q std in LVZ
% param.fref_Qcorr = 1/65; % [Hz] reference frequency
% param.min_Qinv_std = 0.001; % uncertainty threshold to avoid very small values
% param.thresh_dVs_reduc_perc = -0.05; %-0.5; % Vs reduction below which to consider misfit within layer 1 ( dVs = (Vs ./ Vsu - 1)*100 )
% param.sig_MPa = 0.4; % [MPa] differential stress

%% Old ORCA
param.bootstraps_Vs = 'OldORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
param.bootstraps_Q = 'OldORCA_uniform_Qmu_bayesian_Nspline12.mat';
param.is_err2sigma = 1; % are errors in data file 2-sigma?
param.age_Myr = 89; % seafloor age
param.PROJ = 'Old ORCA';
param.prior_type = 'uniform';
par.zmax = 250; % [km] Maximum depth of model to consider
par.zmin = 40; %par.zmoho;
param.fac_Vs = 1e-3 * 10; % factor to multiply misfit to get in reasonable range
param.fac_Qinv = 1e-4 * 10 * 10; % factor to multiply misfit to get in reasonable range
param.fac_stdQinv_LVZ = 0.1; % factor to multiply Q std in LVZ
param.fref_Qcorr = 1/65; % [Hz] reference frequency
param.min_Qinv_std = 0.001; % uncertainty threshold to avoid very small values
param.thresh_dVs_reduc_perc = -0.05; %-0.5; % Vs reduction below which to consider misfit within layer 1 ( dVs = (Vs ./ Vsu - 1)*100 )
param.sig_MPa = 0.4; % [MPa] differential stress


%% MCMC parameters
% Other inversion parameters
param.nit_mcmc = 1e4; %1e4; %10000; % total number of iterations
param.nit_restart = 1000; %1000; %250; %1e10; % number of iterations after which to restart with new random model (if never want to restart, set to giant number)
param.N_cooldown = 100; %50; % number of iterations over which temperature parameter (tau) decays
param.m_perturb_method = 'single'; %'all'; % 'single' (perturb one model parameter at a time) | 'all' (perturb all at once)
param.nit_plot = 1e9; %1e4; %1e9; %250; %250; % number of iterations after which to plot
param.nit_prior = param.nit_mcmc; %1e4; % number of iterations for calculating effective priors
param.nit_save = 1; %20; % Number of iterations after which to store model output
param.nit_saveprogress = 1000; % Number of iterations after which to save progress to mat file

% % Other inversion parameters
% param.nit_mcmc = 1e6; %250e3; %1e4; %1e4; %10000; % total number of iterations
% param.nit_restart = 1e4; %1000; %1000; %250; %1e10; % number of iterations after which to restart with new random model (if never want to restart, set to giant number)
% param.N_cooldown = 100; %50; % number of iterations over which temperature parameter (tau) decays
% param.m_perturb_method = 'single'; %'all'; % 'single' (perturb one model parameter at a time) | 'all' (perturb all at once)
% param.nit_plot = 1e9; %1e4; %1e9; %250; %250; % number of iterations after which to plot
% param.nit_prior = param.nit_mcmc; %1e4; %1e4; % number of iterations for calculating effective priors
% param.nit_save = 20; %1; %20; % Number of iterations after which to store model output
% param.nit_saveprogress = 1000; % Number of iterations after which to save progress to mat file

% Define number of parameters
modn.Ch2o_bulk_ppm.Npar = 3;
modn.logdg_mm.Npar = 3;
modn.Tp_C.Npar = 1;
modn.z_plate_km.Npar = 1;

% Define bounds of allowed model space M relative to ref. model.
% Models occuring outside this space will not be allowed.
% (these values also act as the min and max of the uniform prior)
modn.Ch2o_bulk_ppm.M = [0 500]; % [ppm] bulk water concentration bounds
modn.logdg_mm.M = log10([0.1 100]); % [mm] grain size bounds
modn.Tp_C.M = [1260 1460]; % [C] mantle potential temperature bounds
modn.z_plate_km.M = [50 200]; % [km] z_plate term bounds

% Define widths of gaussian perturbations made at each iteration
modn.Ch2o_bulk_ppm.std = 25; % [ppm]
modn.logdg_mm.std = 0.2; % [mm]
modn.Tp_C.std = 25; % [C]
modn.z_plate_km.std = 15; % [km]

% Gather vectors
flds = fields(modn);
for ifld = 1:length(flds)
    fld = flds{ifld};
    modn.(fld).M = repmat(modn.(fld).M,modn.(fld).Npar,1);
    modn.(fld).std = repmat(modn.(fld).std,modn.(fld).Npar,1);
end

%% Load parameters
vbr_method = param.vbr_method;
modeltype = param.modeltype;
CO2_ppm = param.CO2_ppm;
Vs_min = param.Vs_min;
Qinv_max = param.Qinv_max;
%
PROJ = param.PROJ;
prior_type = param.prior_type;
%
nit_mcmc = param.nit_mcmc;
nit_restart = param.nit_restart;
N_cooldown = param.N_cooldown;
m_perturb_method = param.m_perturb_method;
nit_plot = param.nit_plot;
nit_prior = param.nit_prior;
nit_save = param.nit_save;
nit_saveprogress = param.nit_saveprogress;

%% Load Vs and Q profiles

path2Vs = [path2bootstrap_Vs,'/',param.bootstraps_Vs];
path2Q = [path2bootstrap_Q,'/',param.bootstraps_Q];

[bootstrap_Vs,bootstrap_Q,par.discs] = load_VsQ_models(PROJ,path2Vs,path2Q,type,99);

obs.Vs = bootstrap_Vs.bayesian.post.vsvoigt_NF89_med;
obs.Vs_std = 0.5*abs(bootstrap_Vs.bayesian.post.vsvoigt_NF89_u68-bootstrap_Vs.bayesian.post.vsvoigt_NF89_l68);
obs.z_Vs = bootstrap_Vs.bayesian.z_int;
obs.Qinv = bootstrap_Q.bayesian.post.qmu_inv_med;
obs.Qinv_std = 0.5*abs(bootstrap_Q.bayesian.post.qmu_inv_u68-bootstrap_Q.bayesian.post.qmu_inv_l68);
obs.z_Qinv = bootstrap_Q.bayesian.z_int;

% Set threshold
obs.Qinv_std(obs.Qinv_std<param.min_Qinv_std) = param.min_Qinv_std;
% Plot Q^-1
ax3 = subplot(1,2,2); box on; hold on;
plot(obs.Qinv,bootstrap_Q.bayesian.z_int,'-','color','k','linewidth',2);
plot(obs.Qinv+obs.Qinv_std,bootstrap_Q.bayesian.z_int,'--','color','k','linewidth',2);
plot(obs.Qinv-obs.Qinv_std,bootstrap_Q.bayesian.z_int,'--','color','k','linewidth',2);
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
ylabel('Depth (km)');
xlabel('Q_{\mu}');

% Get layer discontinuities
if strcmpi(type,'disc')
    par.discs = bootstrap_Vs.bayesian.z_int(find(diff(bootstrap_Vs.bayesian.z_int)==0));
    
    % Get discs from Q
    temp = load(path2Q);
    bayesianQ = temp.bayesian; clear temp;
    qmu_inv = bayesianQ.post.qmu_inv_med;
    z_q = bayesianQ.z_int;
    dqmu_inv_dr = smooth(gradient(qmu_inv,z_q),15);
    [pks, locs] = findpeaks(abs(dqmu_inv_dr),'MinPeakWidth',20,'NPeaks',2);
    zdisc_Q = z_q(locs(:))';
    par.discs = [par.discs(1:2); zdisc_Q(:); par.discs(end)];
end
par.zh2o = par.discs(1);
par.zmoho = par.discs(2);
par.zlab = par.discs(3);
par.zlvzbot = par.discs(4);

display(par.zh2o); display(par.zmoho); display(par.zlab); display(par.zlvzbot);

% Define layer boundaries
modn.Ch2o_bulk_ppm.zlay = [par.zmoho, par.zlab, par.zlvzbot];
modn.logdg_mm.zlay = [par.zmoho, par.zlab, par.zlvzbot];
modn.Tp_C.zlay = [];
modn.z_plate_km.zlay = [];

%% Define stacked model
model_bounds = [
              modn.Ch2o_bulk_ppm.M;
              modn.logdg_mm.M;
              modn.Tp_C.M;
              modn.z_plate_km.M;
              ];

model_std = [
              modn.Ch2o_bulk_ppm.std;
              modn.logdg_mm.std;
              modn.Tp_C.std;
              modn.z_plate_km.std;
              ];

Nparams = length(model_std);

%% Define depth grid for VBR estimates
dz = 5;
zvec = [par.zmin:dz:par.zmax];

% Interpolate observations to common depth grid
obs_int.Vs = interp1(obs.z_Vs+(0:length(obs.z_Vs)-1)'*1e-13,obs.Vs,zvec);
obs_int.Vs_std = interp1(obs.z_Vs+(0:length(obs.z_Vs)-1)'*1e-13,obs.Vs_std,zvec);
obs_int.Qinv = interp1(obs.z_Qinv+(0:length(obs.z_Qinv)-1)'*1e-13,obs.Qinv,zvec);
obs_int.Qinv_std = interp1(obs.z_Qinv+(0:length(obs.z_Qinv)-1)'*1e-13,obs.Qinv_std,zvec);
obs_int.z = zvec;

% Ensure std is never zero
obs_int.Vs_std(obs_int.Vs_std==0) = min(obs_int.Vs_std(obs_int.Vs_std~=0));
obs_int.Qinv_std(obs_int.Qinv_std==0) = min(obs_int.Qinv_std(obs_int.Qinv_std~=0));
          
%% Define priors for each layer
clear priors

 % Uniform priors spanning M
priors.sample = @(model_bounds,N,ic) unifrnd(model_bounds(ic,1), model_bounds(ic,2) ,N,1);
% model(ic,1) = priors.sample(model_bounds,1,ic);

% Initialize model
model = zeros(Nparams,1);
for ic = 1:Nparams
    model(ic,1) = priors.sample(model_bounds,1,ic);
end

% Function to perturb model
perturb_model = @(model,model_std) normrnd(model,model_std);
% model_pert = perturb_model(model,model_std);
% for ii = 1:1000
%     test(:,ii) = perturb_model(model,model_std);
% end

file_priors = [path2bayesian_out,'/PRIORS_',strrep(PROJ,' ',''),'_',vbr_method,'_',modeltype,'_',prior_type,'_',type,'_zmax',num2str(par.zmax),'_nitprior',num2str(nit_prior),'_fref',num2str(1/param.fref_Qcorr),'s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89.mat'];

if exist(file_priors)
    temp = load(file_priors);
    priors = temp.priors;
    clear temp
else

    fldname = {'Ch2o_bulk_ppm(1)'; 'Ch2o_bulk_ppm(2)'; 'Ch2o_bulk_ppm(3)';
               'logdg_mm(1)'; 'logdg_mm(2)'; 'logdg_mm(3)';
               'Tp_C';
               'z_plate_km'};

    % Get pdf from distributions
    figure(1000); clf;
    set(gcf,'color','w');
    sgtitle('Priors','fontsize',20,'fontweight','bold');
    for ic = 1:Nparams
        subplot(3,3,ic);
        edges_vec = linspace(model_bounds(ic,1),model_bounds(ic,2),25);
        h = histogram(priors.sample(model_bounds,1000000,ic),edges_vec,'Normalization','probability');
        priors.pdf{ic} = h.Values;
        priors.pdf_mat(ic,:) = priors.pdf{ic};
        priors.edges_vec{ic} = edges_vec;
        priors.vec{ic} = 0.5*(edges_vec(1:end-1)+edges_vec(2:end));

        set(gca,'fontsize',14,'linewidth',1.5);
        xlabel([fldname{ic},': ic=',num2str(ic)],'Interpreter','none');
    end

    figure(999); clf;
    for ic = 1:Nparams
        plot(priors.vec{ic},priors.pdf{ic}); hold on;
        lgd{ic} = ['ic=',num2str(ic)];
    end
    title('Priors on Parameters');
    ylim([0 max(priors.pdf{ic})*1.1]);
    legend(lgd,'location','eastoutside'); 


    % Convert Ch2o and logdg priors to depth grid

    % Do Ch2o first
    priors.Ch2o_bulk_ppm.edges_vec = priors.edges_vec{1};
    priors.Ch2o_bulk_ppm.vec = priors.vec{1};
    priors.Ch2o_bulk_ppm.vals = zeros(length(zvec),length(priors.Ch2o_bulk_ppm.vec));
    [priors.Ch2o_bulk_ppm.xmat,priors.Ch2o_bulk_ppm.zmat] = meshgrid(priors.Ch2o_bulk_ppm.vec,zvec);
    kk=0;
    for ic = [1:3] % Ch2o in 3 layers
        kk = kk + 1;
        ind = find(zvec >= modn.Ch2o_bulk_ppm.zlay(kk));
        for ii = 1:length(ind)
            priors.Ch2o_bulk_ppm.vals(ii,:) = priors.pdf{ic};
        end
    end
    % Now do grain size
    priors.logdg_mm.edges_vec = priors.edges_vec{4};
    priors.logdg_mm.vec = priors.vec{4};
    priors.logdg_mm.vals = zeros(length(zvec),length(priors.logdg_mm.vec));
    [priors.logdg_mm.xmat,priors.logdg_mm.zmat] = meshgrid(priors.logdg_mm.vec,zvec);
    kk=0;
    for ic = [4:6] % dg in 3 layers
        kk = kk + 1;
        ind = find(zvec >= modn.logdg_mm.zlay(kk));
        for ii = 1:length(ind)
            priors.logdg_mm.vals(ii,:) = priors.pdf{ic};
        end
    end

    % % Calculate effective prior for T(z) resulting from combined effects of Tp and z_plate priors
    % TpC_test = priors.sample(model_bounds,1e4,7);
    % z_plate_km_test = priors.sample(model_bounds,1e4,8);
    % T_C_test = nan(length(zvec),length(TpC_test));
    % % Loop through and calculate cooling profiles
    % for ii = 1:length(TpC_test)
    %     HF.modeltype = modeltype;
    %     HF.t_Myr = param.age_Myr+1e-12;
    %     HF.Tp_C = TpC_test(ii);
    %     HF.z_plate_km = z_plate_km_test(ii);
    %     if strcmpi(HF.modeltype,'hsc')
    %         [ HF.z_m,HF.T_K,HF.P_GPa,HF.rho_kgm3 ] = calc_HSC( HF.Tp_C+273,HF.t_Myr, zvec*1000 );
    %     elseif strcmpi(HF.modeltype,'plate')
    %         [ HF.z_m,HF.T_K,HF.P_GPa,HF.rho_kgm3 ] = calc_platecooling( HF.Tp_C+273,HF.t_Myr,HF.z_plate_km, zvec*1000 );
    %     end
    %     HF.T_C = HF.T_K - 273;
    %     T_C_test(:,ii) = HF.T_C;
    % end

    % Calculate effective priors for T(z), phi(z), Ch2o_solid(z), Vs(z),
    % Qinv(z) resulting from combined effects of prescribed uniform priors on
    % Tp, z_plate, grain size, Ch2o
    T_C_test = nan(length(zvec),nit_prior);
    logphi_perc_test = nan(length(zvec),nit_prior);
    Ch2o_sol_ppm_test = nan(length(zvec),nit_prior); % Ch2o left over in solid phase after melting
    Vs_test = nan(length(zvec),nit_prior);
    Qinv_test = nan(length(zvec),nit_prior);
    dVs_test = nan(length(zvec),nit_prior);
    dVs_obs_test = nan(length(zvec),nit_prior);
    logeta_diff_test = nan(length(zvec),nit_prior);
    logeta_disl_test = nan(length(zvec),nit_prior);
    logeta_tot_test = nan(length(zvec),nit_prior);
    sr_disl_frac_test = nan(length(zvec),nit_prior);
    T_homol_test = nan(length(zvec),nit_prior);
    ii=0;
    while ii <= nit_prior
        m_test(:) = sample_model(priors,model_bounds,Nparams);
        try
            [VBR_test] = VBR_calculate_mcmc_freq_HKvisc_dryVisc_sigma_YT24(m_test,zvec,modn,param.age_Myr,CO2_ppm,vbr_method,modeltype,path2perlextab_rho, path2perlextab_vs, path2perlextab_vp, param.fref_Qcorr, param.sig_MPa);
        catch
            disp('Something went wrong in VBR calculation... skipping and trying again');
            continue
        end
        Vs = mean(VBR_test.out.anelastic.(vbr_method).V,2) / 1000;
        Qinv = mean(VBR_test.out.anelastic.(vbr_method).Qinv,2);
        if any(Vs<Vs_min) || any(Qinv>Qinv_max)
            disp('Vs and/or Qinv outside allowed range... skipping');
            continue
        end

        ii = ii + 1;

        if mod(ii,100) == 0
            display([num2str(ii),'/',num2str(nit_prior)]);
        end

        T_C_test(:,ii) = VBR_test.in.SV.T_K - 273;
        logphi_perc_test(:,ii) = log10(100*VBR_test.in.SV.phi);
        Ch2o_sol_ppm_test(:,ii) = VBR_test.in.SV.Ch2o;
        Vs_test(:,ii) = mean(VBR_test.out.anelastic.(vbr_method).V,2) / 1000;
        Qinv_test(:,ii) = mean(VBR_test.out.anelastic.(vbr_method).Qinv,2);
        dVs_test(:,ii) = mean(VBR_test.out.anelastic.(vbr_method).V,2) ./ VBR_test.out.elastic.anh_poro.Vsu;
        dVs_obs_test(:,ii) = obs_int.Vs(:)*1000 ./ VBR_test.out.elastic.anh_poro.Vsu;
        if isfield(VBR_test.out.viscous,'xfit_premelt')
            logeta_diff_test(:,ii) = log10(VBR_test.out.viscous.xfit_premelt.diff.eta);
        else
            logeta_diff_test(:,ii) = log10(VBR_test.out.viscous.HK2003.diff.eta);
        end
        logeta_gbs_test = log10(VBR_test.out.viscous.HK2003.gbs.eta);
        logeta_disl_test(:,ii) = log10(VBR_test.out.viscous.HK2003.disl.eta);
        eta_total_inv = 1./10.^logeta_diff_test(:,ii) + 1./10.^logeta_gbs_test + 1./10.^logeta_disl_test(:,ii);
        logeta_tot_test(:,ii) = log10(1./eta_total_inv);
        sr_tot = VBR_test.in.SV.sig_MPa*1e6 .* (eta_total_inv);
%         sr_disl_frac_test(:,ii) = VBR_test.out.viscous.HK2003.disl.sr ./ VBR_test.out.viscous.HK2003.sr_tot;
        sr_disl_frac_test(:,ii) = VBR_test.out.viscous.HK2003.disl.sr ./ sr_tot;
        T_homol_test(:,ii) = VBR_test.in.SV.T_K ./ VBR_test.in.SV.Tsolidus_K;
    end
    logphi_perc_test(logphi_perc_test<-4) = -4;

    % Now get histograms of cooling profiles at each depth
    Nvals = 30;
    priors.T_C = intialize_depth_prior(T_C_test,zvec,Nvals);
    priors.logphi_perc = intialize_depth_prior(logphi_perc_test,zvec,Nvals);
    priors.Ch2o_sol_ppm = intialize_depth_prior(Ch2o_sol_ppm_test,zvec,Nvals);
    priors.Vs = intialize_depth_prior(Vs_test,zvec,Nvals);
    priors.Qinv = intialize_depth_prior(Qinv_test,zvec,Nvals);
    priors.dVs = intialize_depth_prior(dVs_test,zvec,Nvals);
    priors.dVs_obs = intialize_depth_prior(dVs_obs_test,zvec,Nvals);
    priors.logeta_diff = intialize_depth_prior(logeta_diff_test,zvec,Nvals);
    priors.logeta_disl = intialize_depth_prior(logeta_disl_test,zvec,Nvals);
    priors.logeta_tot = intialize_depth_prior(logeta_tot_test,zvec,Nvals);
    priors.sr_disl_frac = intialize_depth_prior(sr_disl_frac_test,zvec,Nvals);
    priors.T_homol = intialize_depth_prior(T_homol_test,zvec,Nvals);
    figure(998); clf;
    for iz = 1:length(zvec)
        subplot(4,4,1); box on; hold on;
        h = histogram(T_C_test(iz,:),priors.T_C.edges_vec,'Normalization','probability');
        priors.T_C.vals(iz,:) = h.Values;

        subplot(4,4,2); box on; hold on;
        h = histogram(logphi_perc_test(iz,:),priors.logphi_perc.edges_vec,'Normalization','probability');
        priors.logphi_perc.vals(iz,:) = h.Values;

        subplot(4,4,3); box on; hold on;
        h = histogram(Ch2o_sol_ppm_test(iz,:),priors.Ch2o_sol_ppm.edges_vec,'Normalization','probability');
        priors.Ch2o_sol_ppm.vals(iz,:) = h.Values;

        subplot(4,4,4); box on; hold on;
        h = histogram(Vs_test(iz,:),priors.Vs.edges_vec,'Normalization','probability');
        priors.Vs.vals(iz,:) = h.Values;

        subplot(4,4,5); box on; hold on;
        h = histogram(Qinv_test(iz,:),priors.Qinv.edges_vec,'Normalization','probability');
        priors.Qinv.vals(iz,:) = h.Values;
        
        subplot(4,4,6); box on; hold on;
        h = histogram(dVs_test(iz,:),priors.dVs.edges_vec,'Normalization','probability');
        priors.dVs.vals(iz,:) = h.Values;
        
        subplot(4,4,7); box on; hold on;
        h = histogram(dVs_obs_test(iz,:),priors.dVs_obs.edges_vec,'Normalization','probability');
        priors.dVs_obs.vals(iz,:) = h.Values;
        
        subplot(4,4,8); box on; hold on;
        h = histogram(logeta_diff_test(iz,:),priors.logeta_diff.edges_vec,'Normalization','probability');
        priors.logeta_diff.vals(iz,:) = h.Values;
        
        h = histogram(logeta_disl_test(iz,:),priors.logeta_disl.edges_vec,'Normalization','probability');
        priors.logeta_disl.vals(iz,:) = h.Values;
        
        h = histogram(logeta_tot_test(iz,:),priors.logeta_tot.edges_vec,'Normalization','probability');
        priors.logeta_tot.vals(iz,:) = h.Values;
        
        h = histogram(sr_disl_frac_test(iz,:),priors.sr_disl_frac.edges_vec,'Normalization','probability');
        priors.sr_disl_frac.vals(iz,:) = h.Values;

        h = histogram(T_homol_test(iz,:),priors.T_homol.edges_vec,'Normalization','probability');
        priors.T_homol.vals(iz,:) = h.Values;
       
    end
    
    clear T_C_test logphi_perc_test Ch2o_sol_ppm_test Vs_test Qinv_test
    clear logeta_diff_test logeta_disl_test logeta_tot_test sr_disl_frac_test 
    clear dVs_test dVs_obs_test T_homol_test

    if ~exist(path2bayesian_out)
        mkdir(path2bayesian_out)
    end
    if is_save
        save(file_priors,'priors','-v7.3')
    end
end

%% Plot effective priors
figure(997);clf;
set(gcf,'position',[1          26        1746         922],'color','w');
clrbase = (viridis);
cmap = [ flipud([linspace(clrbase(1,1),1,10)',linspace(clrbase(1,2),1,10)',linspace(clrbase(1,3),1,10)']);
        clrbase];
colormap(cmap);

subplot(2,4,1); box on; hold on;
surface(priors.Ch2o_bulk_ppm.xmat,priors.Ch2o_bulk_ppm.zmat,zeros(size(priors.Ch2o_bulk_ppm.zmat)),priors.Ch2o_bulk_ppm.vals,'LineStyle','none'); 
for ii = 1:length(modn.Ch2o_bulk_ppm.zlay)
    plot([min(priors.Ch2o_bulk_ppm.xmat(:)) max(priors.Ch2o_bulk_ppm.xmat(:))],modn.Ch2o_bulk_ppm.zlay(ii)*[1 1],'--r','linewidth',2);
end
xlabel('C_{H_2O} (ppm)');
ylabel('Depth (km)');
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
title('Prior');
colorbar;
caxis([0 max(priors.Ch2o_bulk_ppm.vals(:))]);
xlim([min(priors.Ch2o_bulk_ppm.xmat(:)) max(priors.Ch2o_bulk_ppm.xmat(:))])

subplot(2,4,2); box on; hold on;
surface(priors.logdg_mm.xmat,priors.logdg_mm.zmat,zeros(size(priors.logdg_mm.zmat)),priors.logdg_mm.vals,'LineStyle','none');
for ii = 1:length(modn.logdg_mm.zlay)
    plot([min(priors.logdg_mm.xmat(:)) max(priors.logdg_mm.xmat(:))],modn.logdg_mm.zlay(ii)*[1 1],'--r','linewidth',2);
end
xlabel('log_{10}(Grain Size; mm)');
ylabel('Depth (km)');
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
title('Prior');
colorbar;
caxis([0 max(priors.logdg_mm.vals(:))]);
xlim([min(priors.logdg_mm.xmat(:)) max(priors.logdg_mm.xmat(:))])

subplot(2,4,3); box on; hold on;
surface(priors.Ch2o_sol_ppm.xmat,priors.Ch2o_sol_ppm.zmat,zeros(size(priors.Ch2o_sol_ppm.zmat)),priors.Ch2o_sol_ppm.vals,'LineStyle','none');
for ii = 1:length(modn.Ch2o_bulk_ppm.zlay)
    plot([min(priors.Ch2o_bulk_ppm.xmat(:)) max(priors.Ch2o_bulk_ppm.xmat(:))],modn.Ch2o_bulk_ppm.zlay(ii)*[1 1],'--r','linewidth',2);
end
xlabel('C_{H_2O,sol} (ppm)');
ylabel('Depth (km)');
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
title('Effective Prior');
colorbar;
caxis([0 max(priors.Ch2o_sol_ppm.vals(:))]);
xlim([min(priors.Ch2o_sol_ppm.xmat(:)) max(priors.Ch2o_sol_ppm.xmat(:))])

subplot(2,4,4); box on; hold on;
surface(priors.logphi_perc.xmat,priors.logphi_perc.zmat,zeros(size(priors.logphi_perc.zmat)),priors.logphi_perc.vals,'LineStyle','none');
for ii = 1:length(modn.logdg_mm.zlay)
    plot([min(priors.logphi_perc.xmat(:)) max(priors.logphi_perc.xmat(:))],modn.logdg_mm.zlay(ii)*[1 1],'--r','linewidth',2);
end
xlabel('log_{10}(phi; %)');
ylabel('Depth (km)');
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
title('Effective prior');
colorbar;
xlim([min(priors.logphi_perc.xmat(:)) max(priors.logphi_perc.xmat(:))])

subplot(2,4,5); box on; hold on;
surface(priors.T_C.xmat,priors.T_C.zmat,zeros(size(priors.T_C.zmat)),priors.T_C.vals,'LineStyle','none');
for ii = 1:length(modn.logdg_mm.zlay)
    plot([min(priors.T_C.xmat(:)) max(priors.T_C.xmat(:))],modn.logdg_mm.zlay(ii)*[1 1],'--r','linewidth',2);
end
xlabel('Temperature (C)');
ylabel('Depth (km)');
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
title('Effective prior');
colorbar;
xlim([min(priors.T_C.xmat(:)) max(priors.T_C.xmat(:))])

subplot(2,4,6); box on; hold on;
surface(priors.Vs.xmat,priors.Vs.zmat,zeros(size(priors.Vs.zmat)),priors.Vs.vals,'LineStyle','none');
for ii = 1:length(modn.logdg_mm.zlay)
    plot([min(priors.Vs.xmat(:)) max(priors.Vs.xmat(:))],modn.logdg_mm.zlay(ii)*[1 1],'--r','linewidth',2);
end
xlabel('V_{S} (km/s)');
ylabel('Depth (km)');
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
title('Effective prior');
colorbar;
xlim([min(priors.Vs.xmat(:)) max(priors.Vs.xmat(:))])

subplot(2,4,7); box on; hold on;
surface(priors.Qinv.xmat,priors.Qinv.zmat,zeros(size(priors.Qinv.zmat)),priors.Qinv.vals,'LineStyle','none');
for ii = 1:length(modn.logdg_mm.zlay)
    plot([min(priors.Qinv.xmat(:)) max(priors.Qinv.xmat(:))],modn.logdg_mm.zlay(ii)*[1 1],'--r','linewidth',2);
end
xlabel('Q^{-1}');
ylabel('Depth (km)');
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
title('Effective prior');
colorbar;
xlim([min(priors.Qinv.xmat(:)) max(priors.Qinv.xmat(:))])

% subplot(2,4,8); box on; hold on;
% surface(priors.dVs.xmat,priors.dVs.zmat,zeros(size(priors.dVs.zmat)),priors.dVs.vals,'LineStyle','none');
% for ii = 1:length(modn.logdg_mm.zlay)
%     plot([min(priors.dVs.xmat(:)) max(priors.dVs.xmat(:))],modn.logdg_mm.zlay(ii)*[1 1],'--r','linewidth',2);
% end
% xlabel('V_S/V_{S,anh}');
% ylabel('Depth (km)');
% set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
% title('Effective prior');
% colorbar;
% xlim([min(priors.dVs.xmat(:)) max(priors.dVs.xmat(:))])

subplot(2,4,8); box on; hold on;
surface(priors.logeta_diff.xmat,priors.logeta_diff.zmat,zeros(size(priors.Qinv.zmat)),priors.logeta_diff.vals,'LineStyle','none');
for ii = 1:length(modn.logdg_mm.zlay)
    plot([min(priors.logeta_diff.xmat(:)) max(priors.logeta_diff.xmat(:))],modn.logdg_mm.zlay(ii)*[1 1],'--r','linewidth',2);
end
xlabel('log_{10}(\eta_{diff})');
ylabel('Depth (km)');
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
title('Effective prior');
colorbar;
xlim([min(priors.logeta_diff.xmat(:)) max(priors.logeta_diff.xmat(:))])
drawnow

%% Do MCMC
Nmodels = ceil(nit_mcmc / nit_save);
posterior.params = nan(Nparams,Nmodels);
posterior.Vs = nan(length(zvec),Nmodels);
posterior.Qinv = nan(length(zvec),Nmodels);
posterior.T_C = nan(length(zvec),Nmodels);
posterior.logdg_mm = nan(length(zvec),Nmodels);
posterior.phi = nan(length(zvec),Nmodels);
posterior.logphi_perc = nan(length(zvec),Nmodels);
posterior.Ch2o_bulk_ppm = nan(length(zvec),Nmodels);
posterior.Ch2o_sol_ppm = nan(length(zvec),Nmodels);
posterior.dVs = nan(length(zvec),Nmodels);
posterior.dVs_obs = nan(length(zvec),Nmodels);
posterior.logeta_diff = nan(length(zvec),Nmodels);
posterior.logeta_disl = nan(length(zvec),Nmodels);
posterior.logeta_tot = nan(length(zvec),Nmodels);
posterior.sr_disl_frac = nan(length(zvec),Nmodels);
posterior.T_homol = nan(length(zvec),Nmodels);
vbr_mods.params = nan(Nparams,Nmodels);
vbr_mods.Vs = nan(length(zvec),Nmodels);
vbr_mods.Qinv = nan(length(zvec),Nmodels);
vbr_mods.T_C = nan(length(zvec),Nmodels);
vbr_mods.logdg_mm = nan(length(zvec),Nmodels);
vbr_mods.Ch2o_bulk_ppm = nan(length(zvec),Nmodels);
vbr_mods.Ch2o_sol_ppm = nan(length(zvec),Nmodels);
vbr_mods.phi = nan(length(zvec),Nmodels);
vbr_mods.logphi_perc = nan(length(zvec),Nmodels);
vbr_mods.dVs = nan(length(zvec),Nmodels);
vbr_mods.dVs_obs = nan(length(zvec),Nmodels);
vbr_mods.logeta_diff = nan(length(zvec),Nmodels);
vbr_mods.logeta_disl = nan(length(zvec),Nmodels);
vbr_mods.logeta_tot = nan(length(zvec),Nmodels);
vbr_mods.sr_disl_frac = nan(length(zvec),Nmodels);
vbr_mods.T_homol = nan(length(zvec),Nmodels);
misfit.Vs_Qinv = nan(1,Nmodels);
misfit.Vs = nan(1,Nmodels);
misfit.Qinv = nan(1,Nmodels);
Likelihood.L_Vs_Qinv = nan(1,Nmodels);
Likelihood.L_Vs = nan(1,Nmodels);
Likelihood.L_Qinv = nan(1,Nmodels);
Likelihood.Vs = nan(length(zvec),Nmodels);
Likelihood.Qinv = nan(length(zvec),Nmodels);
Likelihood.T_C = nan(length(zvec),Nmodels);
Likelihood.logdg_mm = nan(length(zvec),Nmodels);
Likelihood.Ch2o_bulk_ppm = nan(length(zvec),Nmodels);
Likelihood.Ch2o_sol_ppm = nan(length(zvec),Nmodels);
Likelihood.phi = nan(length(zvec),Nmodels);
Likelihood.logphi_perc = nan(length(zvec),Nmodels);
Likelihood.dVs = nan(length(zvec),Nmodels);
Likelihood.dVs_obs = nan(length(zvec),Nmodels);
Likelihood.logeta_diff = nan(length(zvec),Nmodels);
Likelihood.logeta_disl = nan(length(zvec),Nmodels);
Likelihood.logeta_tot = nan(length(zvec),Nmodels);
Likelihood.sr_disl_frac = nan(length(zvec),Nmodels);
Likelihood.T_homol = nan(length(zvec),Nmodels);
% models = nan([size(refmod_sp),Nmodels]);

% Initiate
m_j(:) = sample_model(priors,model_bounds,Nparams);
ii = 0;
icooldown = 0;
ibad = 0;
ifail = 0;
ii_save = 0;
tic

outtemp = [path2bayesian_out,'/',strrep(PROJ,' ',''),'_',vbr_method,'_',modeltype,'_',prior_type,'_',type,'_zmax',num2str(par.zmax),'_nit',num2str(nit_mcmc),'_fref',num2str(1/param.fref_Qcorr),'s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89_PROGRESS.mat'];
if exist(outtemp) && is_resume_progress==1
    load(outtemp);
end
while ii < nit_mcmc
    
    if ii>0 && mod(ii,nit_restart) == 0 % reinitialize mcmc, start over
        m_j(:) = sample_model(priors,model_bounds,Nparams);
        icooldown = 0;
%         ibad = 0;
    end
    
    % Previous model
% %     Inoh2o = find(mod_ref.vs~=0);
% %     Ih2o = find(mod_ref.vs==0);
%     Inoh2o = find(mod_ref.z>=zmin & mod_ref.z<=zmax); Inoh2o = Inoh2o(2:end);
%     Ih2o = find(mod_ref.z<=zmin); Ih2o = Ih2o(1:end-1);
%     Ifixed = find(mod_ref.z > zmax);
%     vs_spline = spbasis * m_j(:,3);
%     vs_spline = [mod_ref.vs(Ih2o); vs_spline; mod_ref.vs(Ifixed)];
%     [splinemod_j] = spline2mod(mod_ref,vs_spline,par.vp_vs,par.rho_vs,zmin);
%     c_j = dispR_surf96(periods,splinemod_j); % predicted phase velocity
    
    try
        [VBR] = VBR_calculate_mcmc_freq_HKvisc_dryVisc_sigma_YT24(m_j,zvec,modn,param.age_Myr,CO2_ppm,vbr_method,modeltype,path2perlextab_rho, path2perlextab_vs, path2perlextab_vp, param.fref_Qcorr, param.sig_MPa);
    catch
        ifail = ifail + 1;
        disp('Something went wrong in VBR calculation... perturbing model and trying again');
        m_j(:) = perturb_model(m_j(:),model_std);
        if ifail > 1e2
            m_j(:) = sample_model(priors,model_bounds,Nparams);
        end
        continue
    end
    ifail = 0;
    pre.Vs_j = mean(VBR.out.anelastic.(vbr_method).V,2) / 1000;
    pre.Qinv_j = mean(VBR.out.anelastic.(vbr_method).Qinv,2);
    pre.T_C_j = VBR.in.SV.T_K-273;
    pre.logdg_mm_j = log10(VBR.in.SV.dg_um/1000);
    pre.Ch2o_bulk_ppm_j = VBR.solution.Cs_H2O_0*1e4; % H2O in bulk solid matrix (prior to melting)
    pre.Ch2o_sol_ppm_j = VBR.in.SV.Ch2o; % H2O left over in solid after melting
    pre.phi_j = VBR.in.SV.phi;
    pre.logphi_perc_j = log10(100*VBR.in.SV.phi);
    pre.logphi_perc_j(pre.logphi_perc_j<-4) = -4;
    pre.dVs_j = mean(VBR.out.anelastic.(vbr_method).V,2) ./ VBR.out.elastic.anh_poro.Vsu;
    pre.dVs_obs_j = obs_int.Vs(:)*1000 ./ VBR.out.elastic.anh_poro.Vsu;
    if isfield(VBR.out.viscous,'xfit_premelt')
        pre.logeta_diff_j = log10(VBR.out.viscous.xfit_premelt.diff.eta);
    else
        pre.logeta_diff_j = log10(VBR.out.viscous.HK2003.diff.eta);
    end
    logeta_gbs_j = log10(VBR.out.viscous.HK2003.gbs.eta);
    pre.logeta_disl_j = log10(VBR.out.viscous.HK2003.disl.eta);
    eta_total_inv = 1./10.^pre.logeta_diff_j + 1./10.^logeta_gbs_j + 1./10.^pre.logeta_disl_j;
    pre.logeta_tot_j = log10(1./eta_total_inv);
    sr_tot = VBR.in.SV.sig_MPa*1e6 .* (eta_total_inv);
%         sr_disl_frac_test(:,ii) = VBR_test.out.viscous.HK2003.disl.sr ./ VBR_test.out.viscous.HK2003.sr_tot;
    pre.sr_disl_frac_j = VBR.out.viscous.HK2003.disl.sr ./ sr_tot;
    pre.T_homol_j = VBR.in.SV.T_K ./ VBR.in.SV.Tsolidus_K;
    pre.z = zvec;
    
    if any(pre.Vs_j<Vs_min) || any(pre.Qinv_j>Qinv_max)
        disp('Vs and/or Qinv outside allowed range... perturb model and try again');
        m_j(:) = perturb_model(m_j(:),model_std);
        continue
    end
    
    % Calculate Vs reduction due to anelastic effects and index depths for misfit function
    dvs_reduction_perc = (pre.dVs_j-1)*100; % Vs reduction
    ind_misfit = find(dvs_reduction_perc(:) <= param.thresh_dVs_reduc_perc  |  zvec(:) > par.zlab);
    
    S_j_Vs = sum((obs_int.Vs(ind_misfit)'-pre.Vs_j(ind_misfit)).^2./obs_int.Vs_std(ind_misfit)'.^2) / length(ind_misfit); % misfit
%     L_j_Vs = ((2 * pi)^(length(obs_int.Vs)) * prod(obs_int.Vs_std(:).^2)).^(-0.5) .* exp(-0.5 * S_j_Vs); % likelihood
%     L_j_Vs = exp(-0.5 * S_j_Vs); % likelihood
    L_j_Vs = exp(-0.5 * S_j_Vs * param.fac_Vs); % likelihood
%     L_j_Vs = exp(-0.5 * log(S_j_Vs)); % likelihood
        fac_Qinv_std = ones(size(obs_int.Qinv_std));
        Ilvz = obs_int.z>=par.zlab & obs_int.z<=par.zlvzbot;
        fac_Qinv_std(Ilvz) = param.fac_stdQinv_LVZ;
        S_j_Qinv = sum((obs_int.Qinv(ind_misfit)'-pre.Qinv_j(ind_misfit)).^2./(obs_int.Qinv_std(ind_misfit)'.*fac_Qinv_std(ind_misfit)').^2) / length(ind_misfit); % misfit
    % S_j_Qinv = sum((obs_int.Qinv(:)-pre.Qinv_j(:)).^2./obs_int.Qinv_std(:).^2); % misfit
%     L_j_Qinv = ((2 * pi)^(length(obs_int.Qinv)) * prod(obs_int.Qinv_std(:).^2)).^(-0.5) .* exp(-0.5 * S_j_Qinv); % likelihood
%     L_j_Qinv = exp(-0.5 * S_j_Qinv); % likelihood
    L_j_Qinv = exp(-0.5 * S_j_Qinv * param.fac_Qinv); % likelihood
%     L_j_Qinv = exp(-0.5 * log(S_j_Qinv)); % likelihood
    
    L_j = L_j_Vs .* L_j_Qinv;
    
    % Ensure that model is within model space M
    is_in_bounds = is_model_in_bounds(m_j,model_bounds);

    % If model is really bad, try a new one
    % if L_j < eps || isnan(L_j) || ~is_in_bounds
    if isinf(1./L_j) || isnan(L_j) || ~is_in_bounds
        ibad = ibad+1;
        m_j(:) = sample_model(priors,model_bounds,Nparams);
        display(['Searching for stable starting model: ',num2str(ibad)]);
        continue
    end
    ii = ii + 1;
    icooldown = icooldown + 1;
    
    if mod(ii,100) == 0
        display([num2str(ii),'/',num2str(nit_mcmc)]);
    end
    
    % Store output
    if ii>0 && mod(ii,nit_save) == 0
        ii_save = ii_save + 1;
    
        % Calculate posterior probability of model j (parameters)
        for ic = 1:Nparams
            [~,I] = min(abs(m_j(ic)-priors.vec{ic}));
            posterior.params(ic,ii_save) = L_j .* priors.pdf{ic}(I);
        end
        % Calculate posterior for layered structure
        for ilay = 1:length(zvec)
            [~,I] = min(abs(pre.Vs_j(ilay)-priors.Vs.vec));
            posterior.Vs(ilay,ii_save) = L_j .* priors.Vs.vals(ilay,I);
            Likelihood.Vs(ilay,ii_save) = L_j;

            [~,I] = min(abs(pre.Qinv_j(ilay)-priors.Qinv.vec));
            posterior.Qinv(ilay,ii_save) = L_j .* priors.Qinv.vals(ilay,I);
            Likelihood.Qinv(ilay,ii_save) = L_j;

            [~,I] = min(abs(pre.logdg_mm_j(ilay)-priors.logdg_mm.vec));
            posterior.logdg_mm(ilay,ii_save) = L_j .* priors.logdg_mm.vals(ilay,I);
            Likelihood.logdg_mm(ilay,ii_save) = L_j;

            [~,I] = min(abs(pre.logphi_perc_j(ilay)-priors.logphi_perc.vec));
            posterior.logphi_perc(ilay,ii_save) = L_j .* priors.logphi_perc.vals(ilay,I);
            Likelihood.logphi_perc(ilay,ii_save) = L_j;

            [~,I] = min(abs(pre.T_C_j(ilay)-priors.T_C.vec));
            posterior.T_C(ilay,ii_save) = L_j .* priors.T_C.vals(ilay,I);
            Likelihood.T_C(ilay,ii_save) = L_j;

            [~,I] = min(abs(pre.Ch2o_bulk_ppm_j(ilay)-priors.Ch2o_bulk_ppm.vec));
            posterior.Ch2o_bulk_ppm(ilay,ii_save) = L_j .* priors.Ch2o_bulk_ppm.vals(ilay,I);
            Likelihood.Ch2o_bulk_ppm(ilay,ii_save) = L_j;

            [~,I] = min(abs(pre.Ch2o_sol_ppm_j(ilay)-priors.Ch2o_sol_ppm.vec));
            posterior.Ch2o_sol_ppm(ilay,ii_save) = L_j .* priors.Ch2o_sol_ppm.vals(ilay,I);
            Likelihood.Ch2o_sol_ppm(ilay,ii_save) = L_j;
            
            [~,I] = min(abs(pre.dVs_j(ilay)-priors.dVs.vec));
            posterior.dVs(ilay,ii_save) = L_j .* priors.dVs.vals(ilay,I);
            Likelihood.dVs(ilay,ii_save) = L_j;
            
            [~,I] = min(abs(pre.dVs_obs_j(ilay)-priors.dVs_obs.vec));
            posterior.dVs_obs(ilay,ii_save) = L_j .* priors.dVs_obs.vals(ilay,I);
            Likelihood.dVs_obs(ilay,ii_save) = L_j;
            
            [~,I] = min(abs(pre.logeta_diff_j(ilay)-priors.logeta_diff.vec));
            posterior.logeta_diff(ilay,ii_save) = L_j .* priors.logeta_diff.vals(ilay,I);
            Likelihood.logeta_diff(ilay,ii_save) = L_j;
            
            [~,I] = min(abs(pre.logeta_disl_j(ilay)-priors.logeta_disl.vec));
            posterior.logeta_disl(ilay,ii_save) = L_j .* priors.logeta_disl.vals(ilay,I);
            Likelihood.logeta_disl(ilay,ii_save) = L_j;
            
            [~,I] = min(abs(pre.logeta_tot_j(ilay)-priors.logeta_tot.vec));
            posterior.logeta_tot(ilay,ii_save) = L_j .* priors.logeta_tot.vals(ilay,I);
            Likelihood.logeta_tot(ilay,ii_save) = L_j;
            
            [~,I] = min(abs(pre.sr_disl_frac_j(ilay)-priors.sr_disl_frac.vec));
            posterior.sr_disl_frac(ilay,ii_save) = L_j .* priors.sr_disl_frac.vals(ilay,I);
            Likelihood.sr_disl_frac(ilay,ii_save) = L_j;

            [~,I] = min(abs(pre.T_homol_j(ilay)-priors.T_homol.vec));
            posterior.T_homol(ilay,ii_save) = L_j .* priors.T_homol.vals(ilay,I);
            Likelihood.T_homol(ilay,ii_save) = L_j;
        end
    %     posterior(:,ii_save) = L_j;

        % Save outputs
        misfit.Vs(ii_save) = S_j_Vs;
        misfit.Qinv(ii_save) = S_j_Qinv;
        misfit.Vs_Qinv(ii_save) = S_j_Vs + S_j_Qinv;
        Likelihood.L_Vs(ii_save) = L_j_Vs;
        Likelihood.L_Qinv(ii_save) = L_j_Qinv;
        Likelihood.L_Vs_Qinv(ii_save) = L_j;
        vbr_mods.params(:,ii_save) = m_j;
        vbr_mods.Vs(:,ii_save) = pre.Vs_j;
        vbr_mods.Qinv(:,ii_save) = pre.Qinv_j;
        vbr_mods.T_C(:,ii_save) = pre.T_C_j;
        vbr_mods.logdg_mm(:,ii_save) = pre.logdg_mm_j;
        vbr_mods.Ch2o_bulk_ppm(:,ii_save) = pre.Ch2o_bulk_ppm_j;
        vbr_mods.Ch2o_sol_ppm(:,ii_save) = pre.Ch2o_sol_ppm_j;
        vbr_mods.phi(:,ii_save) = pre.phi_j;
        vbr_mods.logphi_perc(:,ii_save) = pre.logphi_perc_j;
        vbr_mods.dVs(:,ii_save) = pre.dVs_j;
        vbr_mods.dVs_obs(:,ii_save) = pre.dVs_obs_j;
        vbr_mods.logeta_diff(:,ii_save) = pre.logeta_diff_j;
        vbr_mods.logeta_disl(:,ii_save) = pre.logeta_disl_j;
        vbr_mods.logeta_tot(:,ii_save) = pre.logeta_tot_j;
        vbr_mods.sr_disl_frac(:,ii_save) = pre.sr_disl_frac_j;
        vbr_mods.T_homol(:,ii_save) = pre.T_homol_j;
        vbr_mods.z = zvec;
    end
    
    % Decaying thermal parameter (cool down parameter) from simulated 
    % annealing (Kirkpatrick et al. 1983). This allows larger changes 
    % between sequential models at early iterations. This premultiplies the
    % Gaussian distributions from which random model parameters are drawn
    % and also the likelihood of the trial model, so misfit increases are
    % more likely accepted early in the MCMC.
%     tau = 1 + 3 * erfc(ii/500); % denom = 500 means decays over ~1500 iterations (Eilon et al. 2018)
    tau = 1 + 3 * erfc(icooldown/(N_cooldown/3)); % denom = 500 means decays over ~1500 iterations
    
    % Trial model
    is_in_bounds = 0;
    while is_in_bounds == 0
        m_i = m_j;
        dm(:) = perturb_model(m_i(:),tau*model_std); % model perturbation
    %     dvs = sample_model(priors.sample,1,Nparams);; % random Vs
        switch m_perturb_method
            case 'single'
                I_pert = ceil(rand(1)*Nparams); % randomly pick model parameter to perturb
                m_i(I_pert) = dm(I_pert);
            case 'all'
                m_i = dm; % perturb all model parameters at once
            otherwise
                error('m_perturb_method not a valid choice. must be ''single'' or ''all'' ');
        end
        is_in_bounds = is_model_in_bounds(m_i,model_bounds);
    end
    
    try
        [VBR] = VBR_calculate_mcmc_freq_HKvisc_dryVisc_sigma_YT24(m_i,zvec,modn,param.age_Myr,CO2_ppm,vbr_method,modeltype,path2perlextab_rho, path2perlextab_vs, path2perlextab_vp, param.fref_Qcorr, param.sig_MPa);
    catch
        disp('Something went wrong in VBR calculation... perturbing model and trying again');
        m_i(:) = perturb_model(m_i(:),tau*model_std);
        continue
    end
    
    pre.Vs_i = mean(VBR.out.anelastic.(vbr_method).V,2) / 1000;
    pre.Qinv_i = mean(VBR.out.anelastic.(vbr_method).Qinv,2);
    pre.dVs_i = mean(VBR.out.anelastic.(vbr_method).V,2) ./ VBR.out.elastic.anh_poro.Vsu;


    % Calculate Vs reduction due to anelastic effects and index depths for misfit function
    dvs_reduction_perc = (pre.dVs_i-1)*100; % Vs reduction
    ind_misfit = find(dvs_reduction_perc(:) <= param.thresh_dVs_reduc_perc  |  zvec(:) > par.zlab);
    
    S_i_Vs = sum((obs_int.Vs(ind_misfit)'-pre.Vs_i(ind_misfit)).^2./obs_int.Vs_std(ind_misfit)'.^2) / length(ind_misfit); % misfit
%     L_i_Vs = ((2 * pi)^(length(obs_int.Vs)) * prod(obs_int.Vs_std(:).^2)).^(-0.5) .* exp(-0.5 * S_i_Vs); % likelihood
%     L_i_Vs = exp(-0.5 * S_i_Vs); % likelihood
    L_i_Vs = exp(-0.5 * S_i_Vs * param.fac_Vs); % likelihood
%     L_i_Vs = exp(-0.5 * log(S_i_Vs)); % likelihood
        fac_Qinv_std = ones(size(obs_int.Qinv_std));
        Ilvz = obs_int.z>=par.zlab & obs_int.z<=par.zlvzbot;
        fac_Qinv_std(Ilvz) = param.fac_stdQinv_LVZ;
        S_i_Qinv = sum((obs_int.Qinv(ind_misfit)'-pre.Qinv_i(ind_misfit)).^2./(obs_int.Qinv_std(ind_misfit)'.*fac_Qinv_std(ind_misfit)').^2) / length(ind_misfit); % misfit
    % S_i_Qinv = sum((obs_int.Qinv(:)-pre.Qinv_i(:)).^2./obs_int.Qinv_std(:).^2); % misfit
%     L_i_Qinv = ((2 * pi)^(length(obs_int.Qinv)) * prod(obs_int.Qinv_std(:).^2)).^(-0.5) .* exp(-0.5 * S_i_Qinv); % likelihood
%     L_i_Qinv = exp(-0.5 * S_i_Qinv); % likelihood
    L_i_Qinv = exp(-0.5 * S_i_Qinv * param.fac_Qinv); % likelihood
%     L_i_Qinv = exp(-0.5 * log(S_i_Qinv)); % likelihood
    
    L_i = L_i_Vs .* L_i_Qinv;
    L_i = L_i * tau;
    
    % Plot
    if mod(ii,nit_plot) == 0
        figure(2); clf;
        box on; hold on;
        yyaxis left
        plot(1:ii_save,misfit.Vs_Qinv(1:ii_save),'o'); hold on;
        ylabel('Misfit');        
        yyaxis right
        plot(1:ii_save,log10(Likelihood.L_Vs_Qinv(1:ii_save)),'o'); hold on;
        ylabel('log_{10}(Likelihood)');
        
        [~,ibest] = max(Likelihood.L_Vs_Qinv);
        
        figure(3); clf;
        subplot(1,6,1); box on; hold on;
        for kk = 1:ii_save
            plot(vbr_mods.T_C(:,kk),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
        end
        plot(vbr_mods.T_C(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
        xlabel('Temperature ({\circ}C)');
        ylabel('Depth (km)');
        set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
        
        subplot(1,6,2); box on; hold on;
        for kk = 1:ii_save
            plot(vbr_mods.Ch2o_bulk_ppm(:,kk),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
        end
        plot(vbr_mods.Ch2o_bulk_ppm(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
        xlabel('C_{H_2O} (ppm)');
        ylabel('Depth (km)');
        set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
        
        subplot(1,6,3); box on; hold on;
        for kk = 1:ii_save
            plot(vbr_mods.logdg_mm(:,kk),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
        end
        plot(vbr_mods.logdg_mm(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
        xlabel('log_{10}(Grain Size; mm)');
        ylabel('Depth (km)');
        set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
        
        subplot(1,6,4); box on; hold on;
        for kk = 1:ii_save
            plot(log10(100*vbr_mods.phi(:,kk)),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
        end
        plot(log10(100*vbr_mods.phi(:,ibest)),vbr_mods.z(:),'-r','linewidth',3);
        xlabel('log_{10}(\phi; %)');
        ylabel('Depth (km)');
        set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
        
        subplot(1,6,5); box on; hold on;
        for kk = 1:ii_save
            plot(vbr_mods.Vs(:,kk),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
        end
        plot(obs_int.Vs,obs_int.z,'-b','linewidth',4);
        plot(vbr_mods.Vs(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
        xlabel('Vs (km/s)');
        ylabel('Depth (km)');
        set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
        
        subplot(1,6,6); box on; hold on;
        for kk = 1:ii_save
            plot(vbr_mods.Qinv(:,kk),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
        end
        plot(obs_int.Qinv,obs_int.z,'-b','linewidth',4);
        plot(vbr_mods.Qinv(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
        xlabel('Q_{\mu}^{-1}');
        ylabel('Depth (km)');
        set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
        
        drawnow
        pause
    end
    
    % Metropolis-Hastings acceptance criterion
    p_accept = min(L_i/L_j, 1);
    if rand <= p_accept % (rand always between [0 1])
        % Accept new model i
        m_j = m_i;
    else
        % Reject new model i
%         continue
    end
    
    if mod(ii,nit_saveprogress) == 0
        save(outtemp,'posterior','vbr_mods','misfit','Likelihood','ii','ii_save','-v7.3');
    end
end
toc

%% Plot misfit/likelihood evolution
figure(888); clf;
subplot(2,1,1);
plot([1:Nmodels]*nit_save,log10(misfit.Vs_Qinv),'o'); hold on;
plot([1:Nmodels]*nit_save,log10(misfit.Vs),'x'); hold on;
plot([1:Nmodels]*nit_save,log10(misfit.Qinv),'+'); hold on;
xlabel('Model #');
ylabel('log_{10}(Misfit)');
legend({'Total','V_S','Q_{\mu}^{-1}'},'location','southwest');

subplot(2,1,2);
plot([1:Nmodels]*nit_save,log10(Likelihood.L_Vs_Qinv),'o'); hold on;
xlabel('Model #');
ylabel('log_{10}(Likelihood)');

%% Plot Depth Profiles
figure(100); clf; 
set(gcf,'position',[1         372        1754         580],'color','w');

irand = ceil(rand(1000,1)*Nmodels); % plot 1000 random models
[~,ibest] = max(Likelihood.L_Vs_Qinv);
[sorted, index] = sort(log10(Likelihood.L_Vs_Qinv),'descend');
ibest_50 = index(1:50);

alph = 0.3;

subplot(1,7,1); box on; hold on;
plot(vbr_mods.T_C(:,irand),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
plot(vbr_mods.T_C(:,ibest_50),vbr_mods.z(:),'-','color',equivalpha([1 0 0],alph),'linewidth',3);
plot(vbr_mods.T_C(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
xlabel('Temperature ({\circ}C)');
ylabel('Depth (km)');
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');

subplot(1,7,2); box on; hold on;
plot(vbr_mods.Ch2o_sol_ppm(:,irand),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
plot(vbr_mods.Ch2o_sol_ppm(:,ibest_50),vbr_mods.z(:),'-','color',equivalpha([1 0 0],alph),'linewidth',3);
plot(vbr_mods.Ch2o_sol_ppm(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
xlabel('C_{H_2O} (ppm)');
ylabel('Depth (km)');
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');

subplot(1,7,3); box on; hold on;
plot(vbr_mods.logdg_mm(:,irand),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
plot(vbr_mods.logdg_mm(:,ibest_50),vbr_mods.z(:),'-','color',equivalpha([1 0 0],alph),'linewidth',3);
plot(vbr_mods.logdg_mm(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
xlabel('log_{10}(Grain Size; mm)');
ylabel('Depth (km)');
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');

subplot(1,7,4); box on; hold on;
plot(log10(100*vbr_mods.phi(:,irand)),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
plot(log10(100*vbr_mods.phi(:,ibest_50)),vbr_mods.z(:),'-','color',equivalpha([1 0 0],alph),'linewidth',3);
plot(log10(100*vbr_mods.phi(:,ibest)),vbr_mods.z(:),'-r','linewidth',3);
xlabel('log_{10}(\phi; %)');
ylabel('Depth (km)');
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');

subplot(1,7,5); box on; hold on;
plot(vbr_mods.Vs(:,irand),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
plot(vbr_mods.Vs(:,ibest_50),vbr_mods.z(:),'-','color',equivalpha([1 0 0],alph),'linewidth',3);
plot(vbr_mods.Vs(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
plot(obs_int.Vs,obs_int.z,'-b','linewidth',4);
xlabel('Vs (km/s)');
ylabel('Depth (km)');
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
xlim([3.9 4.7]);

subplot(1,7,6); box on; hold on;
plot(vbr_mods.Qinv(:,irand),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
plot(vbr_mods.Qinv(:,ibest_50),vbr_mods.z(:),'-','color',equivalpha([1 0 0],alph),'linewidth',3);
plot(vbr_mods.Qinv(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
plot(obs_int.Qinv,obs_int.z,'-b','linewidth',4);
xlabel('Q_{\mu}^{-1}');
ylabel('Depth (km)');
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
xlim([0 1/25]);

% subplot(1,7,7); box on; hold on;
% plot(vbr_mods.dVs(:,irand),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
% plot(vbr_mods.dVs(:,ibest_50),vbr_mods.z(:),'-','color',equivalpha([1 0 0],alph),'linewidth',3);
% plot(vbr_mods.dVs(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
% % plot(obs_int.Vs,obs_int.z,'-b','linewidth',4);
% plot(vbr_mods.dVs_obs(:,ibest_50),vbr_mods.z(:),'-','color',equivalpha([0 0 1],alph),'linewidth',3);
% plot(vbr_mods.dVs_obs(:,ibest),vbr_mods.z(:),'-b','linewidth',3);
% xlabel('V_S/V_{S,anh}');
% ylabel('Depth (km)');
% set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
% % xlim([0 1/25]);

subplot(1,7,7); box on; hold on;
plot(vbr_mods.logeta_diff(:,irand),vbr_mods.z(:),'-','color',[0.7 0.7 0.7],'linewidth',1);
plot(vbr_mods.logeta_diff(:,ibest_50),vbr_mods.z(:),'-','color',equivalpha([1 0 0],alph),'linewidth',3);
plot(vbr_mods.logeta_diff(:,ibest),vbr_mods.z(:),'-r','linewidth',3);
xlabel('log_{10}(\eta_{diff})');
ylabel('Depth (km)');
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
% xlim([0 1/25]);

%% Calculate marginal pdfs for parameters
clear marginal

% Marginal for parameters
marginal.params_pdf={};
marginal.vec={};
for ic = 1:Nparams
    ind_bin = discretize(vbr_mods.params(ic,:),priors.edges_vec{ic});
    marginal_ic = zeros(size(priors.vec{ic}));
    for ii = 1:length(ind_bin)
        if isnan(ind_bin(ii))
            continue
        end
        ic_not = [1:Nparams]~=ic;
        marginal_ic(ind_bin(ii)) = marginal_ic(ind_bin(ii)) + sum(posterior.params(:,ii));
    end
    marginal.params_pdf{ic} = marginal_ic / sum(marginal_ic); % normalize so sums to 1
    marginal.vec{ic} = priors.vec{ic};
end

% Plot histograms
figure(1001); clf;
fldname = {'Ch2o_bulk_ppm(1)'; 'Ch2o_bulk_ppm(2)'; 'Ch2o_bulk_ppm(3)';
           'logdg_mm(1)'; 'logdg_mm(2)'; 'logdg_mm(3)';
           'Tp_C';
           'z_plate_km'};
for ic = 1:Nparams
    
    subplot(3,4,ic);
    plot(priors.vec{ic},priors.pdf{ic},'-k','linewidth',2); hold on;
    plot(marginal.vec{ic},marginal.params_pdf{ic},'-r','linewidth',1.5); hold on;
    ylims = get(gca,'YLim');
%     plot(spcoeffs_true(ic)*[1 1],ylim,'--g','linewidth',1.5);
    title([fldname{ic},': ic=',num2str(ic)],'Interpreter','none');
    xlim([min(marginal.vec{ic}) max(marginal.vec{ic})]);
    
end

%% Marginal PDFs for depth models

% Marginal for depth model
flds = fields(posterior);
for ifld = 1:length(flds)
    fld = flds{ifld};
    if strcmpi(fld,'params') || strcmpi(fld,'phi')
        continue
    end
    post = posterior.(fld);
    Lik = Likelihood.(fld);
    edges_vec = priors.(fld).edges_vec;
    vec = priors.(fld).vec;
    vals = vbr_mods.(fld);
    for iz = 1:size(post,1)
        ind_bin = discretize(vals(iz,:),edges_vec);
        marg = zeros(size(vec));
        L_marg = zeros(size(vec));
        for ii = 1:length(ind_bin)
            if isnan(ind_bin(ii))
                continue
            end
            marg(ind_bin(ii)) = marg(ind_bin(ii)) + sum(post(iz,ii));
            L_marg(ind_bin(ii)) = L_marg(ind_bin(ii)) + sum(Lik(iz,ii));
        end
        marginal.(fld).vals(iz,:) = marg / sum(marg); % normalize so sums to 1
        L_marginal.(fld).vals(iz,:) = L_marg / sum(L_marg); % normalize so sums to 1
    end
    marginal.(fld).xmat = priors.(fld).xmat;
    marginal.(fld).zmat = priors.(fld).zmat;
    L_marginal.(fld).xmat = priors.(fld).xmat;
    L_marginal.(fld).zmat = priors.(fld).zmat;
end

%% Get confidence intervals from posterior

flds = fields(marginal);
for ifld = 1:length(flds)
    fld = flds{ifld};
    if strcmpi(fld,'params_pdf') || strcmpi(fld,'vec')
        continue
    end
    marg = marginal.(fld).vals;
    marg(isnan(marg)) = 0;
    xvec = marginal.(fld).xmat(1,:);
    marginal.(fld).med = pdf_prctile(marg,xvec,50);
%     marginal.(fld).med(isnan(bayesian.post.vs_med)) = bayesian.post.vs_mean(isnan(bayesian.post.vs_med));
    marginal.(fld).l95 = pdf_prctile(marg,xvec,2.5);
%     marginal.(fld).l95(isnan(bayesian.post.vs_l95)) = bayesian.post.vs_mean(isnan(bayesian.post.vs_l95));
    marginal.(fld).u95 = pdf_prctile(marg,xvec,97.5);
%     marginal.(fld).u95(isnan(bayesian.post.vs_u95)) = bayesian.post.vs_mean(isnan(bayesian.post.vs_u95));
    marginal.(fld).l68 = pdf_prctile(marg,xvec,16);
%     marginal.(fld).l68(isnan(bayesian.post.vs_l68)) = bayesian.post.vs_mean(isnan(bayesian.post.vs_l68));
    marginal.(fld).u68 = pdf_prctile(marg,xvec,84);
%     marginal.(fld).u68(isnan(bayesian.post.vs_u68)) = bayesian.post.vs_mean(isnan(bayesian.post.vs_u68));

    L_marg = L_marginal.(fld).vals;
    L_marg(isnan(L_marg)) = 0;
    xvec = L_marginal.(fld).xmat(1,:);
    L_marginal.(fld).med = pdf_prctile(L_marg,xvec,50);
%     marginal.(fld).med(isnan(bayesian.post.vs_med)) = bayesian.post.vs_mean(isnan(bayesian.post.vs_med));
    L_marginal.(fld).l95 = pdf_prctile(L_marg,xvec,2.5);
%     marginal.(fld).l95(isnan(bayesian.post.vs_l95)) = bayesian.post.vs_mean(isnan(bayesian.post.vs_l95));
    L_marginal.(fld).u95 = pdf_prctile(L_marg,xvec,97.5);
%     marginal.(fld).u95(isnan(bayesian.post.vs_u95)) = bayesian.post.vs_mean(isnan(bayesian.post.vs_u95));
    L_marginal.(fld).l68 = pdf_prctile(L_marg,xvec,16);
%     marginal.(fld).l68(isnan(bayesian.post.vs_l68)) = bayesian.post.vs_mean(isnan(bayesian.post.vs_l68));
    L_marginal.(fld).u68 = pdf_prctile(L_marg,xvec,84);
%     marginal.(fld).u68(isnan(bayesian.post.vs_u68)) = bayesian.post.vs_mean(isnan(bayesian.post.vs_u68));
end
    
%% Plot 2-D marginal probabilities of posterior

figure(1002); clf;
set(gcf,'position',[1         372        1754         580],'color','w');
clrbase = (viridis);
cmap = [ flipud([linspace(clrbase(1,1),1,10)',linspace(clrbase(1,2),1,10)',linspace(clrbase(1,3),1,10)']);
        clrbase];
colormap(cmap);

clims = [log10(1e-4) log10(1)];

subplot(1,6,1); box on; hold on;
surface(marginal.T_C.xmat,marginal.T_C.zmat,zeros(size(marginal.T_C.zmat)),log10(marginal.T_C.vals),'LineStyle','none');
% w = sum(posterior.T_C,1);
% val = sum(w.*vbr_mods.T_C,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.T_C(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(marginal.T_C.med,obs_int.z,'-r','linewidth',4);
plot(marginal.T_C.l68,obs_int.z,'--r','linewidth',4);
plot(marginal.T_C.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)')
% set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.T_C.xmat(:)) max(priors.T_C.xmat(:))])
xlabel('Temperature ({\circ}C)');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,2); box on; hold on;
surface(marginal.Ch2o_sol_ppm.xmat,marginal.Ch2o_sol_ppm.zmat,zeros(size(marginal.Ch2o_sol_ppm.zmat)),log10(marginal.Ch2o_sol_ppm.vals),'LineStyle','none');
% w = sum(posterior.Ch2o_sol_ppm,1);
% val = sum(w.*vbr_mods.Ch2o_sol_ppm,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.Ch2o_sol_ppm(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(marginal.Ch2o_sol_ppm.med,obs_int.z,'-r','linewidth',4);
plot(marginal.Ch2o_sol_ppm.l68,obs_int.z,'--r','linewidth',4);
plot(marginal.Ch2o_sol_ppm.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)')
% set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.Ch2o_sol_ppm.xmat(:)) max(priors.Ch2o_sol_ppm.xmat(:))])
xlabel('C_{H_2O} (ppm)');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,3); box on; hold on;
surface(marginal.logdg_mm.xmat,marginal.logdg_mm.zmat,zeros(size(marginal.logdg_mm.zmat)),log10(marginal.logdg_mm.vals),'LineStyle','none');
% w = sum(posterior.logdg_mm,1);
% val = sum(w.*vbr_mods.logdg_mm,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.logdg_mm(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(marginal.logdg_mm.med,obs_int.z,'-r','linewidth',4);
plot(marginal.logdg_mm.l68,obs_int.z,'--r','linewidth',4);
plot(marginal.logdg_mm.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)')
% set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.logdg_mm.xmat(:)) max(priors.logdg_mm.xmat(:))])
xlabel('log_{10}(Grain Size; mm)');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,4); box on; hold on;
surface(marginal.logphi_perc.xmat,marginal.logphi_perc.zmat,zeros(size(marginal.logphi_perc.zmat)),log10(marginal.logphi_perc.vals),'LineStyle','none');
% w = sum(posterior.logphi_perc,1);
% val = sum(w.*vbr_mods.logphi_perc,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.logphi_perc(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(marginal.logphi_perc.med,obs_int.z,'-r','linewidth',4);
plot(marginal.logphi_perc.l68,obs_int.z,'--r','linewidth',4);
plot(marginal.logphi_perc.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)')
% set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.logphi_perc.xmat(:)) max(priors.logphi_perc.xmat(:))])
xlabel('log_{10}(\phi; %)');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,5); box on; hold on;
surface(marginal.Vs.xmat,marginal.Vs.zmat,zeros(size(marginal.Vs.zmat)),log10(marginal.Vs.vals),'LineStyle','none');
% w = sum(posterior.Vs,1);
% val = sum(w.*vbr_mods.Vs,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.Vs(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(marginal.Vs.med,obs_int.z,'-r','linewidth',4);
plot(marginal.Vs.l68,obs_int.z,'--r','linewidth',4);
plot(marginal.Vs.u68,obs_int.z,'--r','linewidth',4);
plot(obs_int.Vs,obs_int.z,'-b','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)')
% set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.Vs.xmat(:)) max(priors.Vs.xmat(:))])
xlabel('Vs (km/s)');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,6); box on; hold on;
surface(marginal.Qinv.xmat,marginal.Qinv.zmat,zeros(size(marginal.Qinv.zmat)),log10(marginal.Qinv.vals),'LineStyle','none');
% w = sum(posterior.Qinv,1);
% val = sum(w.*vbr_mods.Qinv,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.Qinv(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(marginal.Qinv.med,obs_int.z,'-r','linewidth',4);
plot(marginal.Qinv.l68,obs_int.z,'--r','linewidth',4);
plot(marginal.Qinv.u68,obs_int.z,'--r','linewidth',4);
plot(obs_int.Qinv,obs_int.z,'-b','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
pos = get(gca,'Position');
cb = colorbar;
set(gca,'position',pos);
ylabel(cb,'log_{10}(Probability)')
set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.Qinv.xmat(:)) max(priors.Qinv.xmat(:))])
xlabel('Q_{\mu}^{-1}');
ylabel('Depth (km)');
caxis(clims);


%% Plot 2-D marginal probabilities of Likelihood

figure(1003); clf;
set(gcf,'position',[1         372-100        1754         580],'color','w');
clrbase = (viridis);
cmap = [ flipud([linspace(clrbase(1,1),1,10)',linspace(clrbase(1,2),1,10)',linspace(clrbase(1,3),1,10)']);
        clrbase];
colormap(cmap);

clims = [log10(1e-4) log10(1)];

subplot(1,6,1); box on; hold on;
surface(L_marginal.T_C.xmat,L_marginal.T_C.zmat,zeros(size(L_marginal.T_C.zmat)),log10(L_marginal.T_C.vals),'LineStyle','none');
% w = sum(posterior.T_C,1);
% val = sum(w.*vbr_mods.T_C,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.T_C(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.T_C.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.T_C.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.T_C.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)')
% set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.T_C.xmat(:)) max(priors.T_C.xmat(:))])
xlabel('Temperature ({\circ}C)');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,2); box on; hold on;
surface(L_marginal.Ch2o_sol_ppm.xmat,L_marginal.Ch2o_sol_ppm.zmat,zeros(size(L_marginal.Ch2o_sol_ppm.zmat)),log10(L_marginal.Ch2o_sol_ppm.vals),'LineStyle','none');
% w = sum(posterior.Ch2o_sol_ppm,1);
% val = sum(w.*vbr_mods.Ch2o_sol_ppm,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.Ch2o_sol_ppm(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.Ch2o_sol_ppm.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.Ch2o_sol_ppm.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.Ch2o_sol_ppm.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)')
% set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.Ch2o_sol_ppm.xmat(:)) max(priors.Ch2o_sol_ppm.xmat(:))])
xlabel('C_{H_2O} (ppm)');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,3); box on; hold on;
surface(L_marginal.logdg_mm.xmat,L_marginal.logdg_mm.zmat,zeros(size(L_marginal.logdg_mm.zmat)),log10(L_marginal.logdg_mm.vals),'LineStyle','none');
% w = sum(posterior.logdg_mm,1);
% val = sum(w.*vbr_mods.logdg_mm,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.logdg_mm(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.logdg_mm.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.logdg_mm.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.logdg_mm.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)')
% set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.logdg_mm.xmat(:)) max(priors.logdg_mm.xmat(:))])
xlabel('log_{10}(Grain Size; mm)');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,4); box on; hold on;
surface(L_marginal.logphi_perc.xmat,L_marginal.logphi_perc.zmat,zeros(size(L_marginal.logphi_perc.zmat)),log10(L_marginal.logphi_perc.vals),'LineStyle','none');
% w = sum(posterior.logphi_perc,1);
% val = sum(w.*vbr_mods.logphi_perc,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.logphi_perc(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.logphi_perc.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.logphi_perc.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.logphi_perc.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)')
% set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.logphi_perc.xmat(:)) max(priors.logphi_perc.xmat(:))])
xlabel('log_{10}(\phi; %)');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,5); box on; hold on;
surface(L_marginal.Vs.xmat,L_marginal.Vs.zmat,zeros(size(L_marginal.Vs.zmat)),log10(L_marginal.Vs.vals),'LineStyle','none');
% w = sum(posterior.Vs,1);
% val = sum(w.*vbr_mods.Vs,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.Vs(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.Vs.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.Vs.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.Vs.u68,obs_int.z,'--r','linewidth',4);
plot(obs_int.Vs,obs_int.z,'-b','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)')
% set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.Vs.xmat(:)) max(priors.Vs.xmat(:))])
xlabel('Vs (km/s)');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,6); box on; hold on;
surface(L_marginal.Qinv.xmat,L_marginal.Qinv.zmat,zeros(size(L_marginal.Qinv.zmat)),log10(L_marginal.Qinv.vals),'LineStyle','none');
% w = sum(posterior.Qinv,1);
% val = sum(w.*vbr_mods.Qinv,2)./sum(w);
% plot(val,obs_int.z,'-r','linewidth',4);
plot(vbr_mods.Qinv(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.Qinv.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.Qinv.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.Qinv.u68,obs_int.z,'--r','linewidth',4);
plot(obs_int.Qinv,obs_int.z,'-b','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
pos = get(gca,'Position');
cb = colorbar;
set(gca,'position',pos);
ylabel(cb,'log_{10}(Likelihood)')
set(cb,'linewidth',1.5,'fontsize',16);
xlim([min(priors.Qinv.xmat(:)) max(priors.Qinv.xmat(:))])
xlabel('Q_{\mu}^{-1}');
ylabel('Depth (km)');
caxis(clims);

%% Plot Viscosity

figure(1004); clf;
set(gcf,'position',[1         372-200        1754         580],'color','w');
clrbase = (viridis);
cmap = [ flipud([linspace(clrbase(1,1),1,10)',linspace(clrbase(1,2),1,10)',linspace(clrbase(1,3),1,10)']);
        clrbase];
colormap(cmap);

clims = [log10(1e-4) log10(1)];

subplot(1,6,1); box on; hold on;
surface(L_marginal.logeta_diff.xmat,L_marginal.logeta_diff.zmat,zeros(size(L_marginal.logeta_diff.zmat)),log10(L_marginal.logeta_diff.vals),'LineStyle','none');
plot(vbr_mods.logeta_diff(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.logeta_diff.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.logeta_diff.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.logeta_diff.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
xlim([min(priors.logeta_diff.xmat(:)) max(priors.logeta_diff.xmat(:))])
xlabel('log_{10}(\eta_{diff})');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,2); box on; hold on;
surface(L_marginal.logeta_disl.xmat,L_marginal.logeta_disl.zmat,zeros(size(L_marginal.logeta_disl.zmat)),log10(L_marginal.logeta_disl.vals),'LineStyle','none');
plot(vbr_mods.logeta_disl(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.logeta_disl.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.logeta_disl.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.logeta_disl.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
xlim([min(priors.logeta_disl.xmat(:)) max(priors.logeta_disl.xmat(:))])
xlabel('log_{10}(\eta_{disl})');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,3); box on; hold on;
surface(L_marginal.logeta_tot.xmat,L_marginal.logeta_tot.zmat,zeros(size(L_marginal.logeta_tot.zmat)),log10(L_marginal.logeta_tot.vals),'LineStyle','none');
plot(vbr_mods.logeta_tot(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.logeta_tot.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.logeta_tot.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.logeta_tot.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
xlim([min(priors.logeta_tot.xmat(:)) max(priors.logeta_tot.xmat(:))])
xlabel('log_{10}(\eta_{tot})');
ylabel('Depth (km)');
caxis(clims);

subplot(1,6,4); box on; hold on;
surface(L_marginal.sr_disl_frac.xmat,L_marginal.sr_disl_frac.zmat,zeros(size(L_marginal.sr_disl_frac.zmat)),log10(L_marginal.sr_disl_frac.vals),'LineStyle','none');
plot(vbr_mods.sr_disl_frac(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.sr_disl_frac.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.sr_disl_frac.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.sr_disl_frac.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
xlim([min(priors.sr_disl_frac.xmat(:)) max(priors.sr_disl_frac.xmat(:))])
xlabel('$\dot{\varepsilon}_{disl} / \dot{\varepsilon}_{tot}$', 'Interpreter','latex');
ylabel('Depth (km)');
caxis(clims);
xlim([0 1]);

subplot(1,6,5); box on; hold on;
surface(L_marginal.T_homol.xmat,L_marginal.T_homol.zmat,zeros(size(L_marginal.T_homol.zmat)),log10(L_marginal.T_homol.vals),'LineStyle','none');
plot(vbr_mods.T_homol(:,ibest),vbr_mods.z(:),'-c','linewidth',3);
plot(L_marginal.T_homol.med,obs_int.z,'-r','linewidth',4);
plot(L_marginal.T_homol.l68,obs_int.z,'--r','linewidth',4);
plot(L_marginal.T_homol.u68,obs_int.z,'--r','linewidth',4);
set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse','Layer','top');
xlim([min(priors.T_homol.xmat(:)) max(priors.T_homol.xmat(:))])
xlabel('$T / T_{sol}$', 'Interpreter','latex');
ylabel('Depth (km)');
caxis(clims);
% xlim([0 1]);


%% Save bayesian structure

bayesian.priors = priors;
bayesian.misfit = misfit;
bayesian.Likelihood = Likelihood;
bayesian.posterior = posterior;
bayesian.vbr_mods = vbr_mods;
bayesian.marginal = marginal;
bayesian.L_marginal = L_marginal;
bayesian.obs = obs;
bayesian.obs_int = obs_int;
bayesian.par = par;
bayesian.param = param;
bayesian.modn = modn;
bayesian.Nmodels = Nmodels;
bayesian.nit_save = nit_save;

if ~exist(path2bayesian_out)
    mkdir(path2bayesian_out)
end
if is_save
    fileout = [path2bayesian_out,'/',strrep(PROJ,' ',''),'_',vbr_method,'_',modeltype,'_',prior_type,'_',type,'_zmax',num2str(par.zmax),'_nit',num2str(nit_mcmc),'_fref',num2str(1/param.fref_Qcorr),'s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89.mat'];
    save(fileout,'bayesian','-v7.3')
end

