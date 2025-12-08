% Test inversion using surf96 kernels
%
% This version reads in the Q models from the mcmc Bayesian inversion and
% determines discontinuities consistent with the maximum gradient in Q^-1.
%
% - bootstrap resample dataset within uncertainty bounds
%
% jbrussell 6/5/2020
% modified 11/23/2021
% 10/21/2023
%
clear
path2BIN = './bin_v3.30/'; % path to surf96 binary
PATH = getenv('PATH');
if isempty(strfind(PATH,path2BIN))
%     setenv('PATH', [PATH,':',path2BIN]);
    setenv('PATH', [path2BIN,':',PATH]);
end
addpath('./functions/')
% Make binary files executable
!chmod ++x ./bin_v3.30/*

% Add perplex paths
addpath('../5_Perple_X/Simple_X/functions/');
path2perlextab_vs = '../5_Perple_X/Simple_X/RESULTS/Hacker08_noky_400km_stx21/stx21_vs.tabs';
path2perlextab_vp = '../5_Perple_X/Simple_X/RESULTS/Hacker08_noky_400km_stx21/stx21_vp.tabs';
path2perlextab_rho = '../5_Perple_X/Simple_X/RESULTS/Hacker08_noky_400km_stx21/stx21_rho.tabs';

is_save_mat = 1; % save mat file?

%% JdF
% param.CARDID = 'JdF_Nbs50_chi2thresh3.25';
% param.data = ['./data/JdF_meas.mat'];
% param.is_err2sigma = 1; % are errors in data file 2-sigma?
% PROJ = 'JdF';
% prior_type = 'uniform';
% age_myr = 3;
% matnameQ = './bayesian_mcmc_Qspline_zknot/JdF_uniform_Qmu_bayesian_Nspline12.mat';

%% Young ORCA
param.CARDID = 'YoungORCA_Nbs50_chi2thresh3.25';
param.data = ['./data/YoungORCA_meas.mat'];
param.is_err2sigma = 1; % are errors in data file 2-sigma?
PROJ = 'Young ORCA';
prior_type = 'uniform';
age_myr = 43;
matnameQ = './bayesian_mcmc_Qspline_zknot/YoungORCA_uniform_Qmu_bayesian_Nspline12.mat';

%% NoMelt
% param.CARDID = 'NoMelt_Nbs50_chi2thresh3.25';
% param.data = ['./data/NoMelt_meas.mat'];
% param.is_err2sigma = 1; % are errors in data file 2-sigma?
% PROJ = 'NoMelt';
% prior_type = 'uniform';
% age_myr = 70;
% matnameQ = './bayesian_mcmc_Qspline_zknot/NoMelt_uniform_Qmu_bayesian_Nspline12.mat';

%% Old ORCA
% param.CARDID = 'OldORCA_Nbs50_chi2thresh3.25';
% param.data = ['./data/OldORCA_meas.mat'];
% param.is_err2sigma = 1; % are errors in data file 2-sigma?
% PROJ = 'Old ORCA';
% prior_type = 'uniform';
% age_myr = 89;
% matnameQ = './bayesian_mcmc_Qspline_zknot/OldORCA_uniform_Qmu_bayesian_Nspline12.mat';

%% Inversion regularization parameters
eps_data = 1; % data fit
eps_H = 0.05; % norm damping
eps_J = 1*5; %0*0.001; % first derivative smoothing
eps_F = 0.05; %1; % second derivative smoothing
eps_vpvs = 10; % enforce Vp/Vs
eps_rhovs = 10; % enforce Rho/Vs

z_dampbot = 300; % [km] damp to starting model below this depth
zbot = 500; % maximum depth of entire model

% Other inversion parameters
nit = 3; %8; % total number of iterations
nit_recalc_c = 1; % number of iterations after which to recalculate phase velocity and kernels

Nbs = 1000; % number of bootstraps
chi2_thresh = 3.25; %1.5; % Ignore models with chi^2 misfit greater than this

errmultfac = 1; %2; %2; % factor to multiply errors by

Tp_C = 1380; 
modeltype = 'HSC';

outdir = './lsqr_kernel_Vs_vpvsPerplex_bootstrap/';
outname = [strrep(PROJ,' ',''),'_Vs_Vp_Rho_lsqr_kernel_bs',num2str(Nbs)];

if ~exist(outdir)
    mkdir(outdir)
end

%% Load dataset

% Load data
mat = load(param.data);
Idata = find(mat.data.rayl.mode_br_iso == 0);
periods = mat.data.rayl.periods_iso(Idata);
cobs = mat.data.rayl.c_iso(Idata);
cobs = cobs(:);
cstd = mat.data.rayl.err_c_iso(Idata) * errmultfac;
cstd = cstd(:);

%% Load Q model to get discontinuities

temp = load(matnameQ);
bayesianQ = temp.bayesian; clear temp;
qmu_inv = bayesianQ.post.qmu_inv_med;
z_q = bayesianQ.z_int;
dqmu_inv_dr = smooth(gradient(qmu_inv,z_q),5);
[pks, locs] = findpeaks(abs(dqmu_inv_dr),'MinPeakWidth',20,'NPeaks',2);
zdisc_Q = z_q(locs(:))';

figure(999); clf;
set(gcf,'color','w');
sgtitle(PROJ,'fontsize',20,'fontweight','bold');

subplot(1,2,1); box on; hold on;
plot(qmu_inv,z_q,'-r','linewidth',2);
xvals = get(gca,'XLim');
plot(xvals,zdisc_Q(1)*[1 1],'--b','linewidth',1.5);
plot(xvals,zdisc_Q(2)*[1 1],'--b','linewidth',1.5);
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
xlabel('Q_{\mu}^{-1}');
ylabel('Depth (km)');

subplot(1,2,2); box on; hold on;
plot(abs(dqmu_inv_dr),z_q,'-r','linewidth',2);
plot(pks,z_q(locs),'ob');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
xlabel('|{\partial}Q_{\mu}^{-1}/{\partial}r|');
ylabel('Depth (km)');

%% Starting model
% Get MINEOS model
%Read in MINEOS model and convert to SURF96 layered model format
cardname = param.CARDID;
CARD = ['./CARDS/',cardname,'.card'];
[refmod, discs] = card2mod(CARD,zbot+20); % true model
% Keep track of discontinuities
zh2o = discs(1);
zsed = discs(2);
zmoho = discs(3);
% Find redundant water layers and combine
Ih2o = find(refmod(:,2)==1.5);
VpVsRho = refmod(Ih2o(1),2:4);
refmod(Ih2o,:) = [];
refmod = [ zh2o VpVsRho ; refmod];
% Remove very thin layers, which surf96 does not like
dzthresh_km = 0.5;
Ilay = find(refmod(:,1)<dzthresh_km & refmod(:,1)~=0);
for ilay = 1:length(Ilay)
    refmod(Ilay(ilay)+1,1) = refmod(Ilay(ilay)+1) + refmod(Ilay(ilay));
end
refmod(Ilay,:) = [];

startmod = refmod;

figure(1); clf;
box on; hold on;
h = plotlayermods(startmod(:,1),startmod(:,3),'-b');
h.LineWidth = 2;
xlabel('Vs (km/s)');
ylabel('Depth (km)');
title('Starting Model');
set(gca,'FontSize',18,'linewidth',1.5);

%% Load Vp/Vs and Rho/Vs from Perplex
Nsmooth = 5;
isplot = 1;

% Shift knots to coincide with midpoints of layer rather than edge
% (treats discontinuities as though they are already in correct place)
dz = startmod(:,1);
z = [0; cumsum(dz(1:end-1,1))];

[vs_perplex,vp_perplex,rho_perplex,z_perplex,T_C_perplex] = load_VsVpRho_perplex(z,zh2o,Nsmooth,age_myr,Tp_C,modeltype,path2perlextab_vs,path2perlextab_vp,path2perlextab_rho,isplot);
par.vp_vs = vp_perplex ./ vs_perplex; par.vp_vs(isinf(par.vp_vs))=0;
par.rho_vs = rho_perplex ./ vs_perplex; par.rho_vs(isinf(par.rho_vs))=0;

par.vp_vs = par.vp_vs(2:end);
par.rho_vs = par.rho_vs(2:end);

startmod(:,2) = par.vp_vs .* startmod(:,3); startmod(startmod(:,3)==0,2)=1.5;
startmod(:,4) = par.rho_vs .* startmod(:,3); startmod(startmod(:,3)==0,4)=1.03;

%% Do linearized inversion using surf96
cstart = dispR_surf96(periods,startmod); % "predictions";

% Read in card
card_ref=read_model_card(CARD);

% Define discontinuities
discs_save = discs;
discs(discs>max(zdisc_Q)) = [];
discs_all = sort([discs; zdisc_Q(:)]);

mat_smooth = [];
mat_disc = [];
for ibs = 1:Nbs
    
    if ibs==1
        % First iteration, use unperturbed dataset
        cobs_pert = cobs;
    else
        [ cobs_pert ] = perturb_data( cobs, cstd  );
    end

    nmode = 0;
    % First solve for smooth model
    % [finalmod_smooth, cpre_smooth, vs_std_smooth] = run_surf96_inv_Rayl_Vs(cobs,cstd,periods,startmod,discs,eps_data,eps_H,eps_J,eps_F,z_dampbot,nit,nit_recalc_c,par.vp_vs,par.rho_vs);
    % [finalmod_smooth, cpre_smooth, vs_std_smooth] = run_surf96_inv_Rayl_Vs_Vp_Rho(cobs,cstd,periods,startmod,discs,eps_data,eps_H,eps_J,eps_F,eps_vpvs,eps_rhovs,z_dampbot,nit,nit_recalc_c,par.vp_vs,par.rho_vs,nmode);
    [finalmod_smooth, cpre_smooth, vs_std_smooth] = run_surf96_inv_Rayl_Vs_Vp_Rho_dampcr(cobs_pert,cstd,periods,startmod,discs,eps_data,eps_H,eps_J,eps_F,eps_vpvs,eps_rhovs,z_dampbot,nit,nit_recalc_c,par.vp_vs,par.rho_vs,nmode);

    % Now solve for model with discontinuitites
    % [finalmod, cpre, vs_std] = run_surf96_inv_Rayl_Vs(cobs,cstd,periods,startmod,discs_all,eps_data,eps_H,eps_J,eps_F,z_dampbot,nit,nit_recalc_c,par.vp_vs,par.rho_vs);
    % [finalmod, cpre, vs_std] = run_surf96_inv_Rayl_Vs_Vp_Rho(cobs,cstd,periods,startmod,discs_all,eps_data,eps_H,eps_J,eps_F,eps_vpvs,eps_rhovs,z_dampbot,nit,nit_recalc_c,par.vp_vs,par.rho_vs,nmode);
    % [finalmod, cpre, vs_std] = run_surf96_inv_Rayl_Vs_Vp_Rho_dampcr(cobs,cstd,periods,startmod,discs_all,eps_data,eps_H,eps_J,eps_F,eps_vpvs,eps_rhovs,z_dampbot,nit,nit_recalc_c,par.vp_vs,par.rho_vs,nmode);
    % % [finalmod, cpre, vs_std] = run_surf96_inv_Rayl_Vs_Vp_Rho_dampcr(cobs,cstd,periods,startmod,discs_all,eps_data,eps_H,eps_J,eps_F,eps_vpvs,eps_rhovs,max(zdisc_Q),nit,nit_recalc_c,par.vp_vs,par.rho_vs,nmode);
    [finalmod_disc, cpre_disc, vs_std_disc] = run_surf96_inv_Rayl_Vs_Vp_Rho_dampcr_relaxbot(cobs_pert,cstd,periods,startmod,discs_all,eps_data,eps_H,eps_J,eps_F,eps_vpvs,eps_rhovs,z_dampbot,nit,nit_recalc_c,par.vp_vs,par.rho_vs,nmode);
    
    % Calculate reduced chi^2 misfit
    dc = (cobs(:) - cpre_smooth(:)) ./ (cstd(:)*2);
    chi_2_smooth = sum(dc.^2) ./ length(dc);
    dc = (cobs(:) - cpre_disc(:)) ./ (cstd(:)*2);
    chi_2_disc = sum(dc.^2) ./ length(dc);
    
    % Replace fields with values from surf96 model
    [card_disc] = mod2card_discs(finalmod_disc,discs_all,card_ref);
    [card_smooth] = mod2card_discs(finalmod_smooth,discs_save,card_ref);
    
    % Save outputs
    mat_smooth(1).periods = periods;
    mat_smooth(1).cobs = cobs;
    mat_smooth(1).cstd = cstd;
    mat_smooth(ibs).mod = finalmod_smooth;
    mat_smooth(ibs).cpre = cpre_smooth;
    mat_smooth(ibs).chi2 = chi_2_smooth;
    mat_smooth(ibs).card = card_smooth;
    
    mat_disc(1).periods = periods;
    mat_disc(1).cobs = cobs;
    mat_disc(1).cstd = cstd;
    mat_disc(ibs).mod = finalmod_disc;
    mat_disc(ibs).cpre = cpre_disc;
    mat_disc(ibs).chi2 = chi_2_disc;
    mat_disc(ibs).card = card_disc;
    
end

%% Get statistics

bootstrap_smooth = collect_models(mat_smooth);
bootstrap_smooth = get_stats(bootstrap_smooth);

bootstrap_disc = collect_models(mat_disc);
bootstrap_disc = get_stats(bootstrap_disc);
    
%% Plot final kernels
figure(101); clf;
set(gcf,'position',[300         547        1281         422],'color','w')
Npers = length(periods);
clr = jet(Npers);
lgd = {};
[dcdvs, dcdvp, dudvs, dudvp, zkern, dcdrho, dudrho] = calc_kernel96(finalmod_disc, periods, 'R', 1, 0,nmode);
subplot(1,3,1); box on; hold on;
for ip = 1:Npers
    plot(dcdvs(:,ip),zkern,'-','color',clr(ip,:),'linewidth',2); hold on;
    lgd{ip} = [num2str(periods(ip)),' s'];
end
xlabel('dc/dVs');
ylabel('Depth (km)');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
% legend(lgd,'location','eastoutside');

subplot(1,3,2);
for ip = 1:Npers
    plot(dcdvp(:,ip),zkern,'-','color',clr(ip,:),'linewidth',2); hold on;
    lgd{ip} = [num2str(periods(ip)),' s'];
end
xlabel('dc/dVp');
ylabel('Depth (km)');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
% legend(lgd,'location','eastoutside');

subplot(1,3,3);
for ip = 1:Npers
    plot(dcdrho(:,ip),zkern,'-','color',clr(ip,:),'linewidth',2); hold on;
    lgd{ip} = [num2str(periods(ip)),' s'];
end
xlabel('dc/d\rho');
ylabel('Depth (km)');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
pos = get(gca,'Position');
legend(lgd,'location','eastoutside');
set(gca,'position',pos);

%%
% Plot
figure(100); clf; 
set(gcf,'position',[370   372   967   580],'color','w');
sgtitle(PROJ,'fontsize',20,'fontweight','bold');

pa5=read_model_card('./CARDS/pa5_5km.card');
pa5.vsv = pa5.vsv(pa5.z<=zbot);
pa5.vph = pa5.vph(pa5.z<=zbot);
pa5.rho = pa5.rho(pa5.z<=zbot);
pa5.z = pa5.z(pa5.z<=zbot);

subplot(2,2,[1 3]); box on; hold on;
h1(1) = plot(pa5.vsv/1000,pa5.z,'-','color',[0.8 0.8 0.8],'linewidth',3);
h1(2) = plotlayermods(startmod(:,1),startmod(:,3),'-b');
h1(2).LineWidth = 2;
for ibs = 1:Nbs
    h1(3) = plotlayermods(mat_smooth(ibs).mod(:,1),mat_smooth(ibs).mod(:,3),'-m');
    h1(3).LineWidth = 2;
    h1(3).Color = equivalpha(h1(3).Color,0.3);
    % h = plotlayermods(finalmod_smooth(:,1),finalmod_smooth(:,3)-vs_std_smooth,'--m');
    % h.LineWidth = 2;
    % h = plotlayermods(finalmod_smooth(:,1),finalmod_smooth(:,3)+vs_std_smooth,'--m');
    % h.LineWidth = 2;
    h1(4) = plotlayermods(mat_disc(ibs).mod(:,1),mat_disc(ibs).mod(:,3),'-r');
    h1(4).LineWidth = 2;
    h1(4).Color = equivalpha(h1(4).Color,0.3);
    % h = plotlayermods(finalmod_disc(:,1),finalmod_disc(:,3)-vs_std_disc,'--r');
    % h.LineWidth = 2;
    % h = plotlayermods(finalmod_disc(:,1),finalmod_disc(:,3)+vs_std_disc,'--r');
    % h.LineWidth = 2;
end
plot(bootstrap_smooth.stats.vsv.median/1000,bootstrap_smooth.stats.z.median,'-m','linewidth',2);
plot(bootstrap_smooth.stats.vsv.l95/1000,bootstrap_smooth.stats.z.median,'--m','linewidth',2);
plot(bootstrap_smooth.stats.vsv.u95/1000,bootstrap_smooth.stats.z.median,'--m','linewidth',2);
plot(bootstrap_disc.stats.vsv.median/1000,bootstrap_disc.stats.z.median,'-r','linewidth',2);
plot(bootstrap_disc.stats.vsv.l95/1000,bootstrap_disc.stats.z.median,'--r','linewidth',2);
plot(bootstrap_disc.stats.vsv.u95/1000,bootstrap_disc.stats.z.median,'--r','linewidth',2);
xlabel('Velocity');
ylabel('Depth');
set(gca,'FontSize',18,'linewidth',1.5);
legend(h1,{'PA5','start','final (smooth)','final (disc.)'},'Location','southwest')
% legend({'start','final'},'Location','southwest')
xlim([4 4.8])
ylim([0 400]);

subplot(2,2,2); box on; hold on;
% cpre_disc = dispR_surf96(periods,finalmod_disc);
h2(1) = plot(periods,cstart,'-ob','linewidth',2);
for ibs = 1:Nbs
    h2(2) = plot(periods,mat_smooth(ibs).cpre,'-m','linewidth',2);
    h2(2).Color = equivalpha(h2(2).Color,0.3);
    h2(3) = plot(periods,mat_disc(ibs).cpre,'-r','linewidth',2);
    h2(3).Color = equivalpha(h2(3).Color,0.3);
end
plot(bootstrap_smooth.stats.periods.median,bootstrap_smooth.stats.cpre.median,'-m','linewidth',2);
plot(bootstrap_smooth.stats.periods.median,bootstrap_smooth.stats.cpre.l95,'--m','linewidth',2);
plot(bootstrap_smooth.stats.periods.median,bootstrap_smooth.stats.cpre.u95,'--m','linewidth',2);
plot(bootstrap_disc.stats.periods.median,bootstrap_disc.stats.cpre.median,'-r','linewidth',2);
plot(bootstrap_disc.stats.periods.median,bootstrap_disc.stats.cpre.l95,'--r','linewidth',2);
plot(bootstrap_disc.stats.periods.median,bootstrap_disc.stats.cpre.u95,'--r','linewidth',2);
h2(4) = errorbar(periods,cobs,2*cstd,'sk','markersize',8,'markerfacecolor','k','linewidth',2);
legend(h2,{'c start','c final (smooth)','c final (disc.)','c obs'},'Location','northwest')
xlabel('Period');
ylabel('Phase Velocity');
set(gca,'FontSize',18,'linewidth',1.5);

%% Convert surf96 model to CARD

% % Read in card
% card_ref=read_model_card(CARD);
% % Replace fields with values from surf96 model
% discs_all = sort([discs_save; zdisc_Q(:)]);
% [card_disc] = mod2card_discs(finalmod_disc,discs_all,card_ref);
% [card_smooth] = mod2card_discs(finalmod_smooth,discs_save,card_ref);

% Card medians
card_disc_med = card_disc;
card_disc_med.z = bootstrap_disc.stats.z.median;
card_disc_med.rad = bootstrap_disc.stats.rad.median;
card_disc_med.rho = bootstrap_disc.stats.rho.median;
card_disc_med.vpv = bootstrap_disc.stats.vpv.median;
card_disc_med.vph = bootstrap_disc.stats.vph.median;
card_disc_med.vsv = bootstrap_disc.stats.vsv.median;
card_disc_med.vsh = bootstrap_disc.stats.vsh.median;
card_disc_med.eta = bootstrap_disc.stats.eta.median;
card_disc_med.qmu = bootstrap_disc.stats.qmu.median;
card_disc_med.qkap = bootstrap_disc.stats.qkap.median;

card_smooth_med = card_smooth;
card_smooth_med.z = bootstrap_smooth.stats.z.median;
card_smooth_med.rad = bootstrap_smooth.stats.rad.median;
card_smooth_med.rho = bootstrap_smooth.stats.rho.median;
card_smooth_med.vpv = bootstrap_smooth.stats.vpv.median;
card_smooth_med.vph = bootstrap_smooth.stats.vph.median;
card_smooth_med.vsv = bootstrap_smooth.stats.vsv.median;
card_smooth_med.vsh = bootstrap_smooth.stats.vsh.median;
card_smooth_med.eta = bootstrap_smooth.stats.eta.median;
card_smooth_med.qmu = bootstrap_smooth.stats.qmu.median;
card_smooth_med.qkap = bootstrap_smooth.stats.qkap.median;

% Save card files
write_MINEOS_mod(card_disc,['./CARDS/',outname,'_disc.card']);
write_MINEOS_mod(card_smooth,['./CARDS/',outname,'_smooth.card']);

% figure(102); clf; 
% set(gcf,'position',[370   372   967   580],'color','w');
% subplot(2,2,[1 3]); box on; hold on;
% h1(1) = plotlayermods(finalmod(:,1),finalmod(:,3),'-b');
% h1(1).LineWidth = 2;
% h1(2) = plot(card.vsv/1000,card.z,'-','color',[1 0 0],'linewidth',3);
% xlabel('Velocity');
% ylabel('Depth');
% set(gca,'FontSize',18,'linewidth',1.5);
% legend(h1,{'PA5','start','final (smooth)','final (disc.)'},'Location','southwest')
% % legend({'start','final'},'Location','southwest')
% xlim([4 4.8])
% ylim([0 500]);

%% Save mat file

lsqrinv.bootstrap_disc = bootstrap_disc;
lsqrinv.bootstrap_smooth = bootstrap_smooth;
lsqrinv.card_disc = card_disc;
lsqrinv.card_smooth = card_smooth;
lsqrinv.card_ref = card_ref;
lsqrinv.finalmod_disc = finalmod_disc;
lsqrinv.finalmod_smooth = finalmod_smooth;
lsqrinv.startmod = startmod;
lsqrinv.vs_std_disc = vs_std_disc;
lsqrinv.vs_std_smooth = vs_std_smooth;
lsqrinv.periods = periods;
lsqrinv.cobs = cobs;
lsqrinv.cstd = cstd;
lsqrinv.cpre_disc = cpre_disc;
lsqrinv.cpre_smooth = cpre_smooth;
lsqrinv.cstart = cstart;
lsqrinv.par = par;
lsqrinv.par.discs = discs;
lsqrinv.par.zdisc_Q = zdisc_Q;
lsqrinv.par.discs_all = discs_all;
lsqrinv.kernels.zkern = zkern;
lsqrinv.kernels.dcdvs = dcdvs;
lsqrinv.kernels.dcdvp = dcdvp;
lsqrinv.kernels.dcdrho = dcdrho;
lsqrinv.kernels.zkern = zkern;
lsqrinv.param = param;
lsqrinv.param.PROJ = PROJ;
lsqrinv.param.age_myr = age_myr;
lsqrinv.qmu_inv = qmu_inv;
lsqrinv.abs_dqmu_inv_dr = abs(dqmu_inv_dr);
lsqrinv.z_q = z_q;
lsqrinv.zbot = zbot;

if is_save_mat
    if ~exist(outdir)
        mkdir(outdir);
    end
    outmat = [outdir,'/',outname,'.mat'];
    save(outmat,'lsqrinv');
end
