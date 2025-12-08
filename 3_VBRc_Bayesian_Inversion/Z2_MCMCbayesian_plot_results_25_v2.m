clear;
        

%%

% * Smooth Q-informed Vs, YT24, QLVZ adjustment, min Qinv_std, dVs thresh, dry HK Visc, sig_MPa (0.4 MPa), Xi NF89
mcmcfiles = {
            'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89.mat';
            'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89.mat';
            'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89.mat';
            };
mcmcfiles_phi = {
            'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89_phiInt.mat';
            'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89_phiInt.mat';
            'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89_phiInt.mat';
            };
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_VsvoigtNF89.mat';
%             };

% % Smooth Q-informed Vs, YT24, QLVZ adjustment, min Qinv_std, dVs thresh, HZK Visc, sig_MPa piezometer
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HZKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma_piez.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HZKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma_piez.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HZKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma_piez.mat';
%             };

% % Smooth Q-informed Vs, YT24, QLVZ adjustment, min Qinv_std, dVs thresh, dry HK Visc, sig_MPa piezometer
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_piez.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_piez.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma_piez.mat';
%             };

% % Smooth Q-informed Vs, YT24, QLVZ adjustment, min Qinv_std, dVs thresh, wet HZK Visc, sig_MPa (0.4 MPa)
% % mcmcfiles = {
% %             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HZKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
% %             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HZKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
% %             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HZKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
% %             };
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HZKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HZKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HZKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
%             };

% % Smooth Q-informed Vs, YT24, QLVZ adjustment, min Qinv_std, dVs thresh, wet Visc, sig_MPa (0.4 MPa)
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
%             };

% % * Smooth Q-informed Vs, YT24, QLVZ adjustment, min Qinv_std, dVs thresh, dry HK Visc, sig_MPa (0.4 MPa)
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit1000000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma.mat';
%             };
% % mcmcfiles = {
% %             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma.mat';
% %             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma.mat';
% %             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc_sigma.mat';
% %             };
        
% % Smooth Q-informed Vs, YT24, QLVZ adjustment, min Qinv_std, dVs thresh, dry Visc (1 MPa)
% % mcmcfiles = {
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_dryVisc.mat';
%             };


% % Smooth Q-informed Vs, YT24, QLVZ adjustment, min Qinv_std, dVs thresh, wet Visc, sig_MPa (0.4 MPa)
% % mcmcfiles = {
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh_sigma.mat';
%             };

%%

% % Smooth Q-informed Vs, YT24, QLVZ adjustment, min Qinv_std, dVs thresh (WRONG VISCOSITY + WET)
% % mcmcfiles = {
% %             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh.mat';
% %             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh.mat';
% %             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh.mat';
% %             };
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit250000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit250000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit250000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh.mat';
%             };
% 
% % % Smooth Q-informed Vs, eburgers_psp bgpeak, QLVZ adjustment, min Qinv_std, dVs thresh
% % mcmcfiles = {
% %             'YoungORCA_eburgers_psp_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh.mat';
% %             'NoMelt_eburgers_psp_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh.mat';
% %             'OldORCA_eburgers_psp_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_Qstdthresh_dVsthresh.mat';
% %             };

%%

% % Smooth Q-informed Vs, YT24, QLVZ adjustment
% % mcmcfiles = {
% %             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ.mat';
% %             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ.mat';
% %             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ.mat';
% %             };
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit250000_fref65s_HKvisc_YT24_QLVZ.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit250000_fref65s_HKvisc_YT24_QLVZ.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit250000_fref65s_HKvisc_YT24_QLVZ.mat';
%             };

% % Smooth Q-informed Vs, YT24, QLVZ adjustment, H2O + phi
% mcmcfiles = {
%             'YoungORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_meltH2O.mat';
%             'NoMelt_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_meltH2O.mat';
%             'OldORCA_xfit_premelt_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_meltH2O.mat';
%             };

% % Smooth Q-informed Vs, eburgers_psp bgpeak, QLVZ adjustment
% mcmcfiles = {
%             'YoungORCA_eburgers_psp_bgpeak_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_v3.mat';
%             'NoMelt_eburgers_psp_bgpeak_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_v3.mat';
%             'OldORCA_eburgers_psp_bgpeak_plate_uniform_disc_zmax250_nit10000_fref65s_HKvisc_YT24_QLVZ_v3.mat';
%             };

%%
        
lgd = {
       'Young ORCA';
       'NoMelt'
       'Old ORCA';
      };
  
ages = {
        43;
        70;
        89;
        };
    
% path2mcmc = './bayesian_mcmc_vbr/';
path2mcmc = './bayesian_mcmc_vbr_YT24/';

ylims = [40 250];

frac_best = 0.25; % Fraction of best fitting models to consider in parameter correlation calculations

fig_out = './figs/';

%%
set3 = brewermap(15,'set1');
clrs = [set3(1,:); set3(5,:); set3(3,:); set3(2,:)];
clrs(2,:) = [252, 157, 5]/255;
for ii = [1,3,4]
    clrs(ii,:) = equivalpha(clrs(ii,:),0.85);
end
clrs = clrs([1 2 4],:);

%% Load observations

param.bootstraps_Vs = {
                        'YoungORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
                        'NoMelt_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
                        'OldORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
                      };

param.bootstraps_Q = {
                        'YoungORCA_uniform_Qmu_bayesian_Nspline12.mat';
                        'NoMelt_uniform_Qmu_bayesian_Nspline12.mat';
                        'OldORCA_uniform_Qmu_bayesian_Nspline12.mat';
                     };

% path2bootstrap_Vs = './lsqr_kernel_Vs_vpvsPerplex_bootstrap/';
path2bootstrap_Vs = './lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap_smLVZdQdz/';
type = 'disc'; %'disc'; % 'smooth' or 'disc'
path2bootstrap_Q = './bayesian_mcmc_Qspline_zknot_112s/';
bootstrap_Vs={}; bootstrap_Q={}; discs_lvz={};
for iproj = 1:length(mcmcfiles)
    PROJ = lgd{iproj};
    path2Vs = [path2bootstrap_Vs,'/',param.bootstraps_Vs{iproj}];
    path2Q = [path2bootstrap_Q,'/',param.bootstraps_Q{iproj}];
    [bootstrap_Vs{iproj},bootstrap_Q{iproj},par.discs] = load_VsQ_models(PROJ,path2Vs,path2Q,type,99);
    discs_lvz{iproj} = par.discs(end-1:end);
end


%% Gather model 

marginal = {};
L_marginal = {};
obs = {};
priors = {};
vbr_mods = {};
Likelihood = {};
param = {};
marginal_phi = {};
L_marginal_phi = {};
priors_phi = {};
vbr_mods_phi = {};
Likelihood_phi = {};
param_phi = {};
for iproj = 1:length(mcmcfiles)
    temp = load([path2mcmc,'/',mcmcfiles{iproj}]);
    
    marginal{iproj} = temp.bayesian.marginal;
    L_marginal{iproj} = temp.bayesian.L_marginal;
    obs{iproj} = temp.bayesian.obs;
    priors{iproj} = temp.bayesian.priors;
    vbr_mods{iproj} = temp.bayesian.vbr_mods;
    Likelihood{iproj} = temp.bayesian.Likelihood;
    param{iproj} = temp.bayesian.param;
    
    temp = load([path2mcmc,'/',mcmcfiles_phi{iproj}]);
    marginal_phi{iproj} = temp.bayesian.marginal;
    L_marginal_phi{iproj} = temp.bayesian.L_marginal;
    priors_phi{iproj} = temp.bayesian.priors;
    vbr_mods_phi{iproj} = temp.bayesian.vbr_mods;
    Likelihood_phi{iproj} = temp.bayesian.Likelihood;
    param_phi{iproj} = temp.bayesian.param;
end    
clear temp

%% Plot depth profiles
figure(30); clf;
set(gcf,'position',[40         364        1589         492],'color','w');

LW = 3;
FS = 16;
alph = 0.25;

ax = [];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    
    ax(1) = subplot(1,6,1); box on; hold on;
    plot_shaded(T_C.l68,T_C.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    try
    ax(2) = subplot(1,6,2); box on; hold on;
    plot_shaded(Ch2o_bulk_ppm.l68,Ch2o_bulk_ppm.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
    
    ax(3) = subplot(1,6,3); box on; hold on;
    plot_shaded(10.^(logphi_perc.l68),10.^(logphi_perc.u68),z,'x',clrs(iproj,:), alph); hold on;
    
    ax(4) = subplot(1,6,4); box on; hold on;
    plot_shaded(logdg_mm.l68,logdg_mm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(5) = subplot(1,6,5); box on; hold on;
    plot_shaded(Vs.l68,Vs.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(6) = subplot(1,6,6); box on; hold on;
    plot_shaded(Qinv.l68,Qinv.u68,z,'x',clrs(iproj,:), alph); hold on;
end

h1=[]; h2=[];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    
    ax(1) = subplot(1,6,1); box on; hold on;
    h1(iproj) = plot(T_C.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Temperature ({\circ}C)');
    ylabel('Depth (km)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([800 1600]);
    legend(h1,lgd,'location','southwest');
    
    ax(2) = subplot(1,6,2); box on; hold on;
    try
    plot(Ch2o_bulk_ppm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    catch
    end
    plot(Ch2o_sol_ppm.med,z,':','color',clrs(iproj,:),'linewidth',LW);
    h2(1) = plot(0,0,'-k','linewidth',LW);
    h2(2) = plot(0,0,':k','linewidth',LW);
    xlabel('C_{H_2O} (ppm)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    legend(h2,{'Bulk';'Solid'},'location','southwest');
    
    ax(3) = subplot(1,6,3); box on; hold on;
    plot(10.^(logphi_perc.med),z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Melt Fraction (%)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    xlim([0 0.2]);
    ylim(ylims);
    
    ax(4) = subplot(1,6,4); box on; hold on;
    plot(logdg_mm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('log_{10}(Grain Size; mm)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([-0.5 2]);
    
    ax(5) = subplot(1,6,5); box on; hold on;
    plot(Vs.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    plot(obs{iproj}.Vs,obs{iproj}.z_Vs,'--','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('V_{S} (km/s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([4.1 4.7]);
    legend(h5,{'Predicted';'Observed'},'location','southwest');
    
    ax(6) = subplot(1,6,6); box on; hold on;
    plot(Qinv.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    plot(obs{iproj}.Qinv,obs{iproj}.z_Qinv,'--','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Q_{\mu}^{-1}');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    
end

% Adjust axes
for ii = 1:length(ax)
    pos = get(ax(ii),'Position');
    set(ax(ii),'Position',[pos(1)-0.08+(ii-1)*0.022 pos(2)+0.04 pos(3)*1.3 pos(4)]);
end
drawnow

save2pdf(['figs_paper','/Z2_plot_MCMCBayesianVBR_posterior_profiles.pdf'],30,500);

%% Plot depth profiles by project
figure(35); clf;
set(gcf,'position',[40           1        1589        1024],'color','w');

LW = 3;
FS = 16;
alph = 0.25;

ax=[];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    
    ax(1) = subplot(3,6,1+6*(iproj-1)); box on; hold on;
    plot_shaded2(T_C.l68,T_C.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    try
    ax(2) = subplot(3,6,2+6*(iproj-1)); box on; hold on;
    plot_shaded2(Ch2o_bulk_ppm.l68,Ch2o_bulk_ppm.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
    
    ax(3) = subplot(3,6,3+6*(iproj-1)); box on; hold on;
    plot_shaded2(10.^(logphi_perc.l68),10.^(logphi_perc.u68),z,'x',clrs(iproj,:), alph); hold on;
    
    ax(4) = subplot(3,6,4+6*(iproj-1)); box on; hold on;
    plot_shaded2(logdg_mm.l68,logdg_mm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(5) = subplot(3,6,5+6*(iproj-1)); box on; hold on;
%     plot(obs{iproj}.Vs,obs{iproj}.z_Vs,'-','color',equivalpha([0 0 0],alph),'linewidth',LW);
    plot_shaded2(obs{iproj}.Vs-obs{iproj}.Vs_std,obs{iproj}.Vs+obs{iproj}.Vs_std,obs{iproj}.z_Vs,'x',[0 0 0], alph); hold on;
%     plot_shaded(bootstrap_Vs{iproj}.bayesian.post.vs_l68,bootstrap_Vs{iproj}.bayesian.post.vs_u68,bootstrap_Vs{iproj}.bayesian.z_int,'x',[0 0 0], 1); hold on;
    plot_shaded2(Vs.l68,Vs.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(6) = subplot(3,6,6+6*(iproj-1)); box on; hold on;
%     plot_shaded(obs{iproj}.Qinv-obs{iproj}.Qinv_std,obs{iproj}.Qinv+obs{iproj}.Qinv_std,obs{iproj}.z_Qinv,'x',[0 0 0], 1); hold on;
    plot_shaded2(bootstrap_Q{iproj}.bayesian.post.qmu_inv_l68,bootstrap_Q{iproj}.bayesian.post.qmu_inv_u68,bootstrap_Q{iproj}.bayesian.z_int,'x',[0 0 0], alph); hold on;
    plot_shaded2(Qinv.l68,Qinv.u68,z,'x',clrs(iproj,:), alph); hold on;
end

h1=[]; h2=[];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    
    ax(1+6*(iproj-1)) = subplot(3,6,1+6*(iproj-1)); box on; hold on;
    h1 = plot(T_C.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Temperature ({\circ}C)');
    ylabel('Depth (km)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse');
    ylim(ylims);
    xlim([800 1600]);
    legend(h1,lgd{iproj},'location','southwest');
    
    ax(2+6*(iproj-1)) = subplot(3,6,2+6*(iproj-1)); box on; hold on;
    try
    plot(Ch2o_bulk_ppm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    catch
    end
    plot(Ch2o_sol_ppm.med,z,':','color',clrs(iproj,:),'linewidth',LW);
    h2(1) = plot(0,0,'-k','linewidth',LW);
    h2(2) = plot(0,0,':k','linewidth',LW);
    xlabel('C_{H_2O} (ppm)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse');
    ylim(ylims);
    xlim([0 500]);
    legend(h2,{'Bulk';'Solid'},'location','southwest');
    
    ax(3+6*(iproj-1)) = subplot(3,6,3+6*(iproj-1)); box on; hold on;
    plot(10.^(logphi_perc.med),z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Melt Fraction (%)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse');
%     xlim([0 0.5]);
    ylim(ylims);
    xlim([0 0.2]);
    
    ax(4+6*(iproj-1)) = subplot(3,6,4+6*(iproj-1)); box on; hold on;
    plot(logdg_mm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('log_{10}(Grain Size; mm)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse');
    ylim(ylims);
    xlim([-1 2]);
    
    ax(5+6*(iproj-1)) = subplot(3,6,5+6*(iproj-1)); box on; hold on;
    plot(Vs.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
%     plot(obs{iproj}.Vs,obs{iproj}.z_Vs,'--','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-','color',clrs(iproj,:),'linewidth',LW);
    h5(2) = plot(0,0,'-','color',equivalpha([0 0 0],alph),'linewidth',LW);
    xlabel('V_{S} (km/s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse');
    ylim(ylims);
    xlim([4 4.8]);
    legend(h5,{'Predicted';'Observed'},'location','southwest');
    
    ax(6+6*(iproj-1)) = subplot(3,6,6+6*(iproj-1)); box on; hold on;
    plot(Qinv.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
%     plot(obs{iproj}.Qinv,obs{iproj}.z_Qinv,'--','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Q_{\mu}^{-1}');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse');
    ylim(ylims);
    xlim([0 0.045]);
    
    drawnow;
    % Adjust axes
    for ii = 1:6
        pos = get(ax(ii+6*(iproj-1)),'Position');
        set(ax(ii+6*(iproj-1)),'Position',[pos(1)-0.08+(ii-1)*0.022 pos(2)+0.01-(iproj-1)*0.03 pos(3)*1.3 pos(4)*1.25]);
    end
    
end

save2pdf(['./figs_paper/','/Z2_plot_MCMCBayesianVBR_posterior_profiles_individual.pdf'],35,500);

%% Plot histograms

% Plot histograms
figure(31); clf;
set(gcf,'position',[65          54        1049         915],'color','w');
% fldname = {'Ch2o_bulk_ppm(1)'; 'Ch2o_bulk_ppm(2)'; 'Ch2o_bulk_ppm(3)';
%            'logdg_mm(1)'; 'logdg_mm(2)'; 'logdg_mm(3)';
%            'Tp_C';
%            'z_plate_km'};
fldname = {'Layer 1'; 'Layer 2'; 'Layer 3';
           'Layer 1'; 'Layer 2'; 'Layer 3';
           'Potential Temperature';
           'Plate Thickness'};
xlabels = {'C_{H_2O}^{bulk} (ppm)'; 'C_{H_2O}^{bulk} (ppm)'; 'C_{H_2O}^{bulk} (ppm)';
           'log_{10}(Grain Size, mm)'; 'log_{10}(Grain Size, mm)'; 'log_{10}(Grain Size, mm)';
           'T_P ({\circ}C)';
           'z_{plate} (km)'};
for iproj = 1:length(mcmcfiles)
    Nparams = length(priors{iproj}.vec);
    for ic = 1:Nparams
        subplot(3,3,ic); box on; hold on;
        if iproj == 1
            area(priors{iproj}.vec{ic},priors{iproj}.pdf{ic},'facecolor','k','facealpha',0.1); hold on;
        end
        area(marginal{iproj}.vec{ic},marginal{iproj}.params_pdf{ic},'facecolor',clrs(iproj,:),'facealpha',0.3); hold on;
    end
end
for iproj = 1:length(mcmcfiles)
    Nparams = length(priors{iproj}.vec);
    for ic = 1:Nparams

        subplot(3,3,ic); box on; hold on;
        if iproj == 1
            h31(1) = plot(priors{iproj}.vec{ic},priors{iproj}.pdf{ic},'k','linewidth',LW-1); hold on;
        end
        h31(iproj+1) = plot(marginal{iproj}.vec{ic},marginal{iproj}.params_pdf{ic},'-','color',clrs(iproj,:),'linewidth',LW); hold on;
%         ylims2 = get(gca,'YLim');
    %     plot(spcoeffs_true(ic)*[1 1],ylim,'--g','linewidth',1.5);
%         title([fldname{ic},': ic=',num2str(ic)],'Interpreter','none');
        title([fldname{ic}],'Interpreter','none');
        xlabel([xlabels{ic}]);
        try
            xlim([min(marginal{iproj}.vec{ic}) max(marginal{iproj}.vec{ic})]);
        catch
        end
        set(gca,'fontsize',FS,'linewidth',1.5,'layer','top');

    end
end
l31 = legend(h31,{'Prior',lgd{:}},'location','southeast');
l31.Position(1) = l31.Position(1)+0.14;
l31.Position(2) = l31.Position(2)+0.012;
drawnow;
save2pdf(['./figs_paper/','/Z2_plot_MCMCBayesianVBR_posterior_histograms.pdf'],31,500);

% Plot histograms
figure(32); clf;
set(gcf,'position',[65         215-100        1049         754],'color','w');
fldname = {'Ch2o_bulk_ppm(1)'; 'Ch2o_bulk_ppm(2)'; 'Ch2o_bulk_ppm(3)';
           'logdg_mm(1)'; 'logdg_mm(2)'; 'logdg_mm(3)';
           'Tp_C';
           'z_plate_km'};
       
xlabels = {'C_{H_2O}^{bulk} (ppm)'; 'C_{H_2O}^{bulk} (ppm)'; 'C_{H_2O}^{bulk} (ppm)';
           'log_{10}(Grain Size, mm)'; 'log_{10}(Grain Size, mm)'; 'log_{10}(Grain Size, mm)';
           'T_P ({\circ}C)';
           'z_{plate} (km)'};
for iproj = 1:length(mcmcfiles)
    Nparams = length(priors{iproj}.vec);
    for ic = 1:Nparams

        subplot(3,3,ic); box on; hold on;
        histogram('BinEdges',priors{iproj}.edges_vec{ic},'BinCounts',marginal{iproj}.params_pdf{ic},'FaceColor',clrs(iproj,:)); hold on;
        if iproj == length(mcmcfiles)
            histogram('BinEdges',priors{iproj}.edges_vec{ic},'BinCounts',priors{iproj}.pdf{ic},'FaceColor','none'); hold on;
        end
%         ylims2 = get(gca,'YLim');
    %     plot(spcoeffs_true(ic)*[1 1],ylim,'--g','linewidth',1.5);
        title([fldname{ic},': ic=',num2str(ic)],'Interpreter','none');
        try
            xlim([min(marginal{iproj}.vec{ic}) max(marginal{iproj}.vec{ic})]);
        catch
        end
        set(gca,'fontsize',FS,'linewidth',1.5);

    end
end


%% Plot Viscosity
figure(36); clf;
set(gcf,'position',[40         364        1589         492],'color','w');

LW = 3;
FS = 16;
alph = 0.25;

ax = [];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax(1) = subplot(1,6,1); box on; hold on;
    plot_shaded(T_C.l68,T_C.u68,z,'x',clrs(iproj,:), alph); hold on;
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot_shaded(Ch2o_bulk_ppm.l68,Ch2o_bulk_ppm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(3-1) = subplot(1,6,3-1); box on; hold on;
    plot_shaded(10.^(logphi_perc.l68),10.^(logphi_perc.u68),z,'x',clrs(iproj,:), alph); hold on;
    
    ax(4-1) = subplot(1,6,4-1); box on; hold on;
    plot_shaded(logdg_mm.l68,logdg_mm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(5-1) = subplot(1,6,5-1); box on; hold on;
    plot_shaded(logeta_diff.l68,logeta_diff.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    try
    ax(6-1) = subplot(1,6,6-1); box on; hold on;
    plot_shaded(logeta_disl.l68,logeta_disl.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
    
    try
    ax(7-1) = subplot(1,6,7-1); box on; hold on;
    plot_shaded(sr_disl_frac.l68,sr_disl_frac.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
   
end

h1=[]; h2=[];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax(1) = subplot(1,6,1); box on; hold on;
    h1(iproj) = plot(T_C.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Temperature ({\circ}C)');
    ylabel('Depth (km)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([800 1600]);
    legend(h1,lgd,'location','southwest');
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot(Ch2o_bulk_ppm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
%     plot(Ch2o_sol_ppm.med,z,':','color',clrs(iproj,:),'linewidth',LW);
%     h2(1) = plot(0,0,'-k','linewidth',LW);
%     h2(2) = plot(0,0,':k','linewidth',LW);
%     xlabel('C_{H_2O} (ppm)');
%     set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
%     ylim(ylims);
%     legend(h2,{'Bulk';'Solid'},'location','southwest');
    
    ax(3-1) = subplot(1,6,3-1); box on; hold on;
    plot(10.^(logphi_perc.med),z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Melt Fraction (%)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    xlim([0 0.3]);
    ylim(ylims);
    
    ax(4-1) = subplot(1,6,4-1); box on; hold on;
    plot(logdg_mm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('log_{10}(Grain Size; mm)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([-0.5 2]);
    
    ax(5-1) = subplot(1,6,5-1); box on; hold on;
    plot(logeta_diff.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('log_{10}(\eta_{diff}; Pa s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([15 25]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    
    try
    ax(6-1) = subplot(1,6,6-1); box on; hold on;
    plot(logeta_disl.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('log_{10}(\eta_{disl}; Pa s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([15 25]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    catch
    end
    
    try
    ax(7-1) = subplot(1,6,7-1); box on; hold on;
    plot(sr_disl_frac.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('X_{disl} frac.');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([0 1]);
%     xlim([4 4.8]);
%     xlim([15 25]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    catch
    end
    
end

% Adjust axes
for ii = 1:length(ax)
    pos = get(ax(ii),'Position');
    set(ax(ii),'Position',[pos(1)-0.08+(ii-1)*0.022 pos(2)+0.04 pos(3)*1.3 pos(4)]);
end
drawnow

save2pdf(['./figs_paper/','/Z2_plot_MCMCBayesianVBR_posterior_profiles_visc.pdf'],36,500);

%% Compare viscosities

figure(37); clf;
set(gcf,'position',[40         364        1589         492],'color','w');

LW = 3;
FS = 16;
alph = 0.25;

ax = [];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax(1) = subplot(1,6,1); box on; hold on;
    plot_shaded(T_C.l68,T_C.u68,z,'x',clrs(iproj,:), alph); hold on;
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot_shaded(Ch2o_bulk_ppm.l68,Ch2o_bulk_ppm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(3-1) = subplot(1,6,3-1); box on; hold on;
    plot_shaded(10.^(logphi_perc.l68),10.^(logphi_perc.u68),z,'x',clrs(iproj,:), alph); hold on;
    
    ax(4-1) = subplot(1,6,4-1); box on; hold on;
    plot_shaded(logdg_mm.l68,logdg_mm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(5-1) = subplot(1,6,5-1); box on; hold on;
    plot_shaded(logeta_diff.l68,logeta_diff.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    try
    ax(6-1) = subplot(1,6,6-1); box on; hold on;
    plot_shaded(logeta_disl.l68,logeta_disl.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
    
    try
    ax(7-1) = subplot(1,6,7-1); box on; hold on;
    plot_shaded(logeta_tot.l68,logeta_tot.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
   
end

h1=[]; h2=[];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax(1) = subplot(1,6,1); box on; hold on;
    h1(iproj) = plot(T_C.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Temperature ({\circ}C)');
    ylabel('Depth (km)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([800 1600]);
    legend(h1,lgd,'location','southwest');
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot(Ch2o_bulk_ppm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
%     plot(Ch2o_sol_ppm.med,z,':','color',clrs(iproj,:),'linewidth',LW);
%     h2(1) = plot(0,0,'-k','linewidth',LW);
%     h2(2) = plot(0,0,':k','linewidth',LW);
%     xlabel('C_{H_2O} (ppm)');
%     set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
%     ylim(ylims);
%     legend(h2,{'Bulk';'Solid'},'location','southwest');
    
    ax(3-1) = subplot(1,6,3-1); box on; hold on;
    plot(10.^(logphi_perc.med),z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Melt Fraction (%)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    xlim([0 0.3]);
    ylim(ylims);
    
    ax(4-1) = subplot(1,6,4-1); box on; hold on;
    plot(logdg_mm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('log_{10}(Grain Size; mm)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([-0.5 2]);
    
    ax(5-1) = subplot(1,6,5-1); box on; hold on;
    plot(logeta_diff.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('log_{10}(\eta_{diff}; Pa s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([17 25]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    
    try
    ax(6-1) = subplot(1,6,6-1); box on; hold on;
    plot(logeta_disl.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('log_{10}(\eta_{disl}; Pa s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([17 25]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    catch
    end
    
    try
    ax(7-1) = subplot(1,6,7-1); box on; hold on;
    plot(logeta_tot.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('log_{10}(\eta_{tot}; Pa s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([17 25]);
%     xlim([17 22]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    catch
    end
    
end

% Adjust axes
for ii = 1:length(ax)
    pos = get(ax(ii),'Position');
    set(ax(ii),'Position',[pos(1)-0.08+(ii-1)*0.022 pos(2)+0.04 pos(3)*1.3 pos(4)]);
end
drawnow

save2pdf(['figs_paper','/Z2_plot_MCMCBayesianVBR_posterior_profiles_visc_all.pdf'],37,500);


%% Compare Strain Rates

figure(38); clf;
set(gcf,'position',[40         364        1589         492],'color','w');

LW = 3;
FS = 16;
alph = 0.25;

ax = [];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    try
        sig_MPa = param{iproj}.sig_MPa;
    catch
    end
    try
        sig_MPa = marginal{iproj}.sig_MPa.med;
    catch
    end
    
    ax(1) = subplot(1,6,1); box on; hold on;
    plot_shaded(T_C.l68,T_C.u68,z,'x',clrs(iproj,:), alph); hold on;
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot_shaded(Ch2o_bulk_ppm.l68,Ch2o_bulk_ppm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(3-1) = subplot(1,6,3-1); box on; hold on;
    plot_shaded(10.^(logphi_perc.l68),10.^(logphi_perc.u68),z,'x',clrs(iproj,:), alph); hold on;
    
    ax(4-1) = subplot(1,6,4-1); box on; hold on;
    plot_shaded(logdg_mm.l68,logdg_mm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(5-1) = subplot(1,6,5-1); box on; hold on;
    plot_shaded(log10(sig_MPa*1e6)-logeta_diff.l68,log10(sig_MPa*1e6)-logeta_diff.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    try
    ax(6-1) = subplot(1,6,6-1); box on; hold on;
    plot_shaded(log10(sig_MPa*1e6)-logeta_disl.l68,log10(sig_MPa*1e6)-logeta_disl.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
    
    try
    ax(7-1) = subplot(1,6,7-1); box on; hold on;
    plot_shaded(log10(sig_MPa*1e6)-logeta_tot.l68,log10(sig_MPa*1e6)-logeta_tot.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
   
end

h1=[]; h2=[];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax(1) = subplot(1,6,1); box on; hold on;
    h1(iproj) = plot(T_C.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Temperature ({\circ}C)');
    ylabel('Depth (km)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([800 1600]);
    legend(h1,lgd,'location','southwest');
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot(Ch2o_bulk_ppm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
%     plot(Ch2o_sol_ppm.med,z,':','color',clrs(iproj,:),'linewidth',LW);
%     h2(1) = plot(0,0,'-k','linewidth',LW);
%     h2(2) = plot(0,0,':k','linewidth',LW);
%     xlabel('C_{H_2O} (ppm)');
%     set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
%     ylim(ylims);
%     legend(h2,{'Bulk';'Solid'},'location','southwest');
    
    ax(3-1) = subplot(1,6,3-1); box on; hold on;
    plot(10.^(logphi_perc.med),z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Melt Fraction (%)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    xlim([0 0.3]);
    ylim(ylims);
    
    ax(4-1) = subplot(1,6,4-1); box on; hold on;
    plot(logdg_mm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('log_{10}(Grain Size; mm)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([-0.5 2]);
    
    ax(5-1) = subplot(1,6,5-1); box on; hold on;
    plot(log10(sig_MPa*1e6)-logeta_diff.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('log_{10}(\epsilon_{diff}; s^{-1})');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([-17 -12]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    
    try
    ax(6-1) = subplot(1,6,6-1); box on; hold on;
    plot(log10(sig_MPa*1e6)-logeta_disl.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('log_{10}(\epsilon_{disl}; s^{-1})');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([-17 -12]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    catch
    end
    
    try
    ax(7-1) = subplot(1,6,7-1); box on; hold on;
    plot(log10(sig_MPa*1e6)-logeta_tot.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('log_{10}(\epsilon_{tot}; s^{-1})');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([-17 -12]);
%     xlim([17 22]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    catch
    end
    
end

% Adjust axes
for ii = 1:length(ax)
    pos = get(ax(ii),'Position');
    set(ax(ii),'Position',[pos(1)-0.08+(ii-1)*0.022 pos(2)+0.04 pos(3)*1.3 pos(4)]);
end
drawnow

save2pdf(['./figs_paper/','/Z2_plot_MCMCBayesianVBR_posterior_profiles_strainrate_all.pdf'],38,500);

%% Plot depth profiles (For PAPER)
figure(39); clf;
set(gcf,'position',[40         364        1589         492],'color','w');

LW = 3;
FS = 16;
alph = 0.25;

ax39 = [];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax39(1) = subplot(1,6,1); box on; hold on;
    plot_shaded(T_C.l68,T_C.u68,z,'x',clrs(iproj,:), alph); hold on;
    
%     try
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot_shaded(Ch2o_bulk_ppm.l68,Ch2o_bulk_ppm.u68,z,'x',clrs(iproj,:), alph); hold on;
%     catch
%     end
    
    ax39(2) = subplot(1,6,2); box on; hold on;
    plot_shaded(10.^(logphi_perc.l68),10.^(logphi_perc.u68),z,'x',clrs(iproj,:), alph); hold on;
    
    ax39(3) = subplot(1,6,3); box on; hold on;
    plot_shaded(logdg_mm.l68,logdg_mm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    try
    ax39(4) = subplot(1,6,4); box on; hold on;
    plot_shaded(logeta_tot.l68,logeta_tot.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
    
    ax39(5) = subplot(1,6,5); box on; hold on;
    plot_shaded(Vs.l68,Vs.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax39(6) = subplot(1,6,6); box on; hold on;
    plot_shaded(Qinv.l68,Qinv.u68,z,'x',clrs(iproj,:), alph); hold on;
end

h1=[]; h2=[];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax39(1) = subplot(1,6,1); box on; hold on;
    h1(iproj) = plot(T_C.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Temperature ({\circ}C)');
    ylabel('Depth (km)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([800 1600]);
    legend(h1,lgd,'location','southwest');
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     try
%     plot(Ch2o_bulk_ppm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
%     catch
%     end
%     plot(Ch2o_sol_ppm.med,z,':','color',clrs(iproj,:),'linewidth',LW);
%     h2(1) = plot(0,0,'-k','linewidth',LW);
%     h2(2) = plot(0,0,':k','linewidth',LW);
%     xlabel('C_{H_2O} (ppm)');
%     set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
%     ylim(ylims);
%     legend(h2,{'Bulk';'Solid'},'location','southwest');
    
    ax39(2) = subplot(1,6,2); box on; hold on;
    plot(10.^(logphi_perc.med),z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Melt Fraction (%)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    xlim([0 0.2]);
    ylim(ylims);
    
    ax39(3) = subplot(1,6,3); box on; hold on;
    plot(logdg_mm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('log_{10}(Grain Size; mm)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([-0.5 2]);
    
    try
    ax39(4) = subplot(1,6,4); box on; hold on;
    plot(logeta_tot.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('log_{10}(\eta_{tot}; Pa s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
%     xlim([15 25]);
    xlim([17 22]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    catch
    end
    
    ax39(5) = subplot(1,6,5); box on; hold on;
    plot(Vs.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    plot(obs{iproj}.Vs,obs{iproj}.z_Vs,'--','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('V_{S} (km/s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([4.1 4.7]);
    legend(h5,{'Predicted';'Observed'},'location','southwest');
    
    ax39(6) = subplot(1,6,6); box on; hold on;
    plot(Qinv.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    plot(obs{iproj}.Qinv,obs{iproj}.z_Qinv,'--','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Q_{\mu}^{-1}');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    
end

% Adjust axes
for ii = 1:length(ax39)
    pos = get(ax39(ii),'Position');
    set(ax39(ii),'Position',[pos(1)-0.08+(ii-1)*0.022 pos(2)+0.04 pos(3)*1.3 pos(4)]);
end
drawnow

save2pdf([fig_out,'/c2_plot_MCMCBayesianVBR_posterior_profiles_PAPER.pdf'],39,500);

%% Plot depth profiles (For PAPER) v1, simplify
figure(40); clf;
set(gcf,'position',[40         364        1589         492*1.5],'color','w');

LW = 3;
FS = 15;
alph = 0.25;

ax = [];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax(1) = subplot(1,4,1); box on; hold on;
    ax1 = gca;
    plot_shaded(T_C.l68,T_C.u68,z,'x',clrs(iproj,:), alph); hold on;
    
%     try
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot_shaded(Ch2o_bulk_ppm.l68,Ch2o_bulk_ppm.u68,z,'x',clrs(iproj,:), alph); hold on;
%     catch
%     end
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot_shaded(10.^(logphi_perc.l68),10.^(logphi_perc.u68),z,'x',clrs(iproj,:), alph); hold on;

    
%     ax(3) = subplot(1,4,3); box on; hold on;
%     ax3 = gca;
%     plot_shaded(logdg_mm.l68,logdg_mm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    try
    ax(2) = subplot(1,4,2); box on; hold on;
    ax3 = gca;
    plot_shaded(logeta_tot.l68,logeta_tot.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
    
    ax(3) = subplot(1,4,3); box on; hold on;
    ax4 = gca;
    plot_shaded(Vs.l68,Vs.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(4) = subplot(1,4,4); box on; hold on;
    ax5 = gca;
    plot_shaded(Qinv.l68,Qinv.u68,z,'x',clrs(iproj,:), alph); hold on;
end

h1=[]; h2=[];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax(1) = subplot(1,4,1); box on; hold on;
    h1(iproj) = plot(T_C.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Temperature ({\circ}C)');
    ylabel('Depth (km)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    set(gca,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([400 1600]);
    xticks([400 800 1200 1600])
    legend(h1,lgd,'location','southwest','box','off');
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     try
%     plot(Ch2o_bulk_ppm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
%     catch
%     end
%     plot(Ch2o_sol_ppm.med,z,':','color',clrs(iproj,:),'linewidth',LW);
%     h2(1) = plot(0,0,'-k','linewidth',LW);
%     h2(2) = plot(0,0,':k','linewidth',LW);
%     xlabel('C_{H_2O} (ppm)');
%     set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
%     ylim(ylims);
%     legend(h2,{'Bulk';'Solid'},'location','southwest');
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot(10.^(logphi_perc.med),z,'-','color',clrs(iproj,:),'linewidth',LW);
%     xlabel('Melt Fraction (%)');
%     set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
%     xlim([0 0.2]);
%     ylim(ylims);
    
%     ax(3) = subplot(1,6,3); box on; hold on;
%     plot(logdg_mm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
%     xlabel('log_{10}(Grain Size; mm)');
%     set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
%     ylim(ylims);
%     xlim([-0.5 2]);
    
    try
    ax(2) = subplot(1,4,2); box on; hold on;
    plot(logeta_tot.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('log_{10}(\eta_{tot}; Pa s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    set(gca,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
%     xlim([15 25]);
    xlim([17 23]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    catch
    end
    
    ax(3) = subplot(1,4,3); box on; hold on;
    plot(Vs.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    plot(obs{iproj}.Vs,obs{iproj}.z_Vs,'--','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('V_{S} (km/s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    set(gca,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([4.1 4.7]);
    legend(h5,{'Predicted';'Observed'},'location','southwest','box','off');
    
    ax(4) = subplot(1,4,4); box on; hold on;
    plot(Qinv.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    plot(obs{iproj}.Qinv,obs{iproj}.z_Qinv,'--','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Q_{\mu}^{-1}');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    set(gca,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    
end

drawnow

% ------------ PLOT MELT ------------ 
% Create a second axes object on top
ax2 = axes('Position', ax1.Position,...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none','box','on');
drawnow
hold on;
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    % plot
    plot_shaded(10.^(logphi_perc.l68),10.^(logphi_perc.u68),z,'x',clrs(iproj,:), alph); hold on;
end
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    %plot
    plot(10.^(logphi_perc.med),z,'-','color',clrs(iproj,:),'linewidth',LW);
end
xlabel('Melt Fraction (%)');
set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
% set(gca,'XMinorTick','on','YMinorTick','on');
xlim([0 0.3]);
ylim(ylims);
ax2.YAxis.Visible = 'on';   % hide duplicate y-axis
yticklabels([]);
drawnow

% Adjust axes
axs = [ax1 ax2 ax3 ax4 ax5];
for ii = 1:length(axs)
    pos = get(axs(ii),'Position');
%     set(axii,'Position',[pos(1)-0.08+(ii-1)*0.022 pos(2)+0.04 pos(3)*1.3 pos(4)]);
    set(axs(ii),'Position',[pos(1) pos(2) pos(3)*1.19 pos(4)*0.7]);
end
drawnow

% ------------ PLOT GRAIN SIZE HISTOGRAM ------------ 
Z_plot = 120; % depth to plot histogram;
ax6 = axes('Position', [ax3.Position(1) ax3.Position(2)+0.6 ax3.Position(3) ax3.Position(4)*0.3],...
           'Color','none','box','off','layer','top');
for iproj = 1:length(mcmcfiles)
    iZ = find(marginal{iproj}.logeta_tot.zmat(:,1)==Z_plot);
%     Nparams = length(priors{iproj}.vec);
    if iproj == 1
        area(priors{iproj}.vec{5},priors{iproj}.pdf{5},'facecolor','k','facealpha',0.1); hold on;
    end
    area(marginal{iproj}.vec{5},marginal{iproj}.params_pdf{5},'facecolor',clrs(iproj,:),'facealpha',0.3); hold on;
end
for iproj = 1:length(mcmcfiles)
    if iproj == 1
        plot(priors{iproj}.vec{5},priors{iproj}.pdf{5},'k','linewidth',LW-1); hold on;
    end
    h40(iproj) = plot(marginal{iproj}.vec{5},marginal{iproj}.params_pdf{5},'-','color',clrs(iproj,:),'linewidth',LW); hold on;
%         ylims2 = get(gca,'YLim');
%     plot(spcoeffs_true(ic)*[1 1],ylim,'--g','linewidth',1.5);
%         title([fldname{ic},': ic=',num2str(ic)],'Interpreter','none');
end       
% xlim(ax3.XLim);
xlim([min(marginal{iproj}.vec{5}) max(marginal{iproj}.vec{5})]);
set(gca,'fontsize',FS,'linewidth',1.5,'layer','top','XAxisLocation','top','YAxisLocation','left');
set(gca,'XMinorTick','on','YMinorTick','on');
% title(['Asthenosphere Grain Size'],'Interpreter','none');
xlabel({'Asthenosphere Grain Size';'log_{10}(d; mm)'});
text(1.55,0.023,'Prior','fontsize',13);

drawnow

% ------------ PLOT INTEGRATED MELT FRACTION ------------ 
Z_plot = 120; % depth to plot histogram;
ax7 = axes('Position', [ax1.Position(1) ax1.Position(2)+0.6 ax1.Position(3) ax1.Position(4)*0.3],...
           'Color','none','box','off','layer','top');
for iproj = 1:length(mcmcfiles_phi)
    iZ = find(marginal_phi{iproj}.logeta_tot.zmat(:,1)==Z_plot);
%     Nparams = length(priors{iproj}.vec);
    if iproj == 1
        area(priors_phi{iproj}.phi_int.vec,priors_phi{iproj}.phi_int.vals(iZ,:),'facecolor','k','facealpha',0.1); hold on;
    end
    area(marginal_phi{iproj}.phi_int.xmat(iZ,:),marginal_phi{iproj}.phi_int.vals(iZ,:),'facecolor',clrs(iproj,:),'facealpha',0.3); hold on;
end
for iproj = 1:length(mcmcfiles_phi)
    if iproj == 1
        plot(priors_phi{iproj}.phi_int.vec,priors_phi{iproj}.phi_int.vals(iZ,:),'k','linewidth',LW-1); hold on;
    end
    h40(iproj) = plot(marginal_phi{iproj}.phi_int.xmat(iZ,:),marginal_phi{iproj}.phi_int.vals(iZ,:),'-','color',clrs(iproj,:),'linewidth',LW); hold on;
%         ylims2 = get(gca,'YLim');
%     plot(spcoeffs_true(ic)*[1 1],ylim,'--g','linewidth',1.5);
%         title([fldname{ic},': ic=',num2str(ic)],'Interpreter','none');
end       
% xlim(ax3.XLim);
xlim([min(marginal_phi{iproj}.phi_int.xmat(iZ,:)) max(marginal_phi{iproj}.phi_int.xmat(iZ,:))]);
set(gca,'fontsize',FS,'linewidth',1.5,'layer','top','XAxisLocation','top','YAxisLocation','left');
set(gca,'XMinorTick','on','YMinorTick','on');
% title(['Asthenosphere Grain Size'],'Interpreter','none');
xlabel({'Integrated Melt Fraction (km)'});
% text(1.55,0.023,'Prior','fontsize',13);
xlim([0 0.2]);

drawnow

save2pdf(['./figs_paper/','/Z2_plot_MCMCBayesianVBR_posterior_profiles_PAPER_simplify_phiInt.pdf'],40,500);


%% Plot depth profiles (For PAPER) v2, simplify
figure(41); clf;
set(gcf,'position',[70         283        1203         738],'color','w');

LW = 3;
FS = 15;
alph = 0.25;

ax = [];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax(1) = subplot(1,4,1); box on; hold on;
    ax1 = gca;
    plot_shaded(T_C.l68,T_C.u68,z,'x',clrs(iproj,:), alph); hold on;
    
%     try
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot_shaded(Ch2o_bulk_ppm.l68,Ch2o_bulk_ppm.u68,z,'x',clrs(iproj,:), alph); hold on;
%     catch
%     end
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot_shaded(10.^(logphi_perc.l68),10.^(logphi_perc.u68),z,'x',clrs(iproj,:), alph); hold on;

    
%     ax(3) = subplot(1,4,3); box on; hold on;
%     ax3 = gca;
%     plot_shaded(logdg_mm.l68,logdg_mm.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    try
    ax(2) = subplot(1,4,2); box on; hold on;
    ax3 = gca;
    plot_shaded(logeta_tot.l68,logeta_tot.u68,z,'x',clrs(iproj,:), alph); hold on;
    catch
    end
    
    ax(3) = subplot(1,4,3); box on; hold on;
    ax4 = gca;
    plot_shaded(Vs.l68,Vs.u68,z,'x',clrs(iproj,:), alph); hold on;
    
    ax(4) = subplot(1,4,4); box on; hold on;
    ax5 = gca;
    plot_shaded(Qinv.l68,Qinv.u68,z,'x',clrs(iproj,:), alph); hold on;
end

h1=[]; h2=[];
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    ax(1) = subplot(1,4,1); box on; hold on;
    h1(iproj) = plot(T_C.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Temperature ({\circ}C)');
    ylabel('Depth (km)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    set(gca,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    xlim([400 1600]);
    xticks([400 800 1200 1600])
    legend(h1,lgd,'location','southwest','box','off');
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     try
%     plot(Ch2o_bulk_ppm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
%     catch
%     end
%     plot(Ch2o_sol_ppm.med,z,':','color',clrs(iproj,:),'linewidth',LW);
%     h2(1) = plot(0,0,'-k','linewidth',LW);
%     h2(2) = plot(0,0,':k','linewidth',LW);
%     xlabel('C_{H_2O} (ppm)');
%     set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
%     ylim(ylims);
%     legend(h2,{'Bulk';'Solid'},'location','southwest');
    
%     ax(2) = subplot(1,6,2); box on; hold on;
%     plot(10.^(logphi_perc.med),z,'-','color',clrs(iproj,:),'linewidth',LW);
%     xlabel('Melt Fraction (%)');
%     set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
%     xlim([0 0.2]);
%     ylim(ylims);
    
%     ax(3) = subplot(1,6,3); box on; hold on;
%     plot(logdg_mm.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
%     xlabel('log_{10}(Grain Size; mm)');
%     set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
%     ylim(ylims);
%     xlim([-0.5 2]);
    
    try
    ax(2) = subplot(1,4,2); box on; hold on;
    plot(logeta_tot.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    xlabel('log_{10}(\eta_{tot}; Pa s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    set(gca,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
%     xlim([15 25]);
    xlim([17 23]);
%     legend(h5,{'Predicted';'Observed'},'location','southwest');
    catch
    end
    
    ax(3) = subplot(1,4,3); box on; hold on;
    plot(Vs.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    plot(obs{iproj}.Vs,obs{iproj}.z_Vs,'--','color',clrs(iproj,:),'linewidth',LW);
    h5(1) = plot(0,0,'-k','linewidth',LW);
    h5(2) = plot(0,0,'--k','linewidth',LW);
    xlabel('V_{S} (km/s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    set(gca,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
%     xlim([4 4.8]);
    xlim([4.1 4.7]);
    legend(h5,{'Predicted';'Observed'},'location','southwest','box','off');
    
    ax(4) = subplot(1,4,4); box on; hold on;
    plot(Qinv.med,z,'-','color',clrs(iproj,:),'linewidth',LW);
    plot(obs{iproj}.Qinv,obs{iproj}.z_Qinv,'--','color',clrs(iproj,:),'linewidth',LW);
    xlabel('Q_{\mu}^{-1}');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
    set(gca,'XMinorTick','on','YMinorTick','on');
    ylim(ylims);
    
end

drawnow

% Adjust axes
axs = [ax1 ax3 ax4 ax5];
for ii = 1:length(axs)
    pos = get(axs(ii),'Position');
%     set(axii,'Position',[pos(1)-0.08+(ii-1)*0.022 pos(2)+0.04 pos(3)*1.3 pos(4)]);
    set(axs(ii),'Position',[pos(1)+(ii-1)*0.004 pos(2) pos(3)*1.19 pos(4)*0.7]);
end
drawnow

% ------------ PLOT MELT ------------ 
% Create a second axes object on top
ax2 = axes('Position', ax1.Position,...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none','box','on');
drawnow
hold on;
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    % plot
    plot_shaded(10.^(logphi_perc.l68),10.^(logphi_perc.u68),z,'x',clrs(iproj,:), alph); hold on;
end
for iproj = 1:length(mcmcfiles)
    z = marginal{iproj}.Vs.zmat(:,1);
    Vs = marginal{iproj}.Vs;
    Qinv = marginal{iproj}.Qinv;
    T_C = marginal{iproj}.T_C;
    logdg_mm = marginal{iproj}.logdg_mm;
    logphi_perc = marginal{iproj}.logphi_perc;
    try
    Ch2o_bulk_ppm = marginal{iproj}.Ch2o_bulk_ppm;
    catch
    end
    Ch2o_sol_ppm = marginal{iproj}.Ch2o_sol_ppm;
    logeta_diff = marginal{iproj}.logeta_diff;
    try
    logeta_disl = marginal{iproj}.logeta_disl;
    catch
    end
    try
    logeta_tot = marginal{iproj}.logeta_tot;
    catch
    end
    try
    sr_disl_frac = marginal{iproj}.sr_disl_frac;
    catch
    end
    
    %plot
    plot(10.^(logphi_perc.med),z,'-','color',clrs(iproj,:),'linewidth',LW);
end
xlabel('Melt Fraction (%)');
set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','layer','top'); %,'XMinorTick','on','YMinorTick','on');
% set(gca,'XMinorTick','on','YMinorTick','on');
xlim([0 0.3]);
ylim(ylims);
ax2.YAxis.Visible = 'on';   % hide duplicate y-axis
yticklabels([]);
drawnow

% ------------ PLOT GRAIN SIZE HISTOGRAM ------------ 
Z_plot = 120; % depth to plot histogram;
ax6 = axes('Position', [ax3.Position(1) ax3.Position(2)+0.6 ax3.Position(3) ax3.Position(4)*0.3],...
           'Color','none','box','off','layer','top');
for iproj = 1:length(mcmcfiles)
    iZ = find(marginal{iproj}.logeta_tot.zmat(:,1)==Z_plot);
%     Nparams = length(priors{iproj}.vec);
    if iproj == 1
        area(priors{iproj}.vec{5},priors{iproj}.pdf{5},'facecolor','k','facealpha',0.1); hold on;
    end
    area(marginal{iproj}.vec{5},marginal{iproj}.params_pdf{5},'facecolor',clrs(iproj,:),'facealpha',0.3); hold on;
end
for iproj = 1:length(mcmcfiles)
    if iproj == 1
        plot(priors{iproj}.vec{5},priors{iproj}.pdf{5},'k','linewidth',LW-1); hold on;
    end
    h40(iproj) = plot(marginal{iproj}.vec{5},marginal{iproj}.params_pdf{5},'-','color',clrs(iproj,:),'linewidth',LW); hold on;
%         ylims2 = get(gca,'YLim');
%     plot(spcoeffs_true(ic)*[1 1],ylim,'--g','linewidth',1.5);
%         title([fldname{ic},': ic=',num2str(ic)],'Interpreter','none');
end       
% xlim(ax3.XLim);
xlim([min(marginal{iproj}.vec{5}) max(marginal{iproj}.vec{5})]);
set(gca,'fontsize',FS,'linewidth',1.5,'layer','top','XAxisLocation','top','YAxisLocation','left');
set(gca,'XMinorTick','on','YMinorTick','on');
% title(['Asthenosphere Grain Size'],'Interpreter','none');
xlabel({'Asthenosphere Grain Size';'log_{10}(d; mm)'});
text(1.55,0.023,'Prior','fontsize',13);

drawnow

save2pdf(['./figs_paper/','/Z2_plot_MCMCBayesianVBR_posterior_profiles_PAPER_simplify_phiInt_v2.pdf'],41,500);
