clear;
fullMAINpath = mfilename('fullpath');
functionspath = [fullMAINpath(1:regexp(fullMAINpath,mfilename)-1),'functions'];
addpath(functionspath);

% Mat file names
matnames = {
%             'JdF_Vs_Vp_Rho_lsqr_kernel.mat';
            'YoungORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
%             'YoungORCA_Vs_Vp_Rho_lsqr_kernel_bs1000_SAVE.mat';
            'NoMelt_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
            'OldORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
            };
        
matname_bayesian = {
%             'JdF_uniform_Vs_bayesian_Nspline5.mat';
            'YoungORCA_uniform_Vs_bayesian_Nspline5.mat';
%             'YoungORCA_uniform_Vs_bayesian_Nspline5.mat';
            'NoMelt_uniform_Vs_bayesian_Nspline5.mat';
            'OldORCA_uniform_Vs_bayesian_Nspline5.mat';
            };
        
lgd = {
%         'JdF (3 Ma)';
        'Young ORCA (43 Ma)';
%         'Young ORCA (43 Ma)';
        'NoMelt (70 Ma)';
        'Old ORCA (90 Ma)';
        };
    
ages = [
%         3;
        43;
        70;
        90;
        ];

% path2lsqr_Vs = './lsqr_kernel_Vs_vpvsPerplex_bootstrap/';
% path2lsqr_Vs = './lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap/';
% path2lsqr_Vs = './lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap_sm1e4/';
% path2lsqr_Vs = './lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap_smLVZdQdz/';
path2lsqr_Vs = './lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap_BSsmLVZdQdz/';
path2bayesian_Vs = './bayesian_mcmc_Vs_spline_zknot_1e6/';
path2bayesian_Vs_vpvsPerplex = './bayesian_mcmc_Vs_spline_zknot_1e6_vpvsPerplex/';

zlims = [0 300];

%%
clrs = brewermap(length(matnames),'spectral');
set3 = brewermap(15,'set1');
clrs = [set3(1,:); set3(5,:); set3(3,:); set3(2,:)];
clrs(2,:) = [252, 157, 5]/255;
% clrs = clrs * 0.95;
% clrs(3,:) = clrs(3,:) * 0.95;
% clrs(4,:) = clrs(4,:) * 0.95;
for ii = [1,3,4]
    clrs(ii,:) = equivalpha(clrs(ii,:),0.85);
end

clrs = clrs([1 2 4],:);

%%

% Load Nishimura and Forsyth (1989) Vsv
nf89_vsv = load_NF89_vsv('./NF89/');
nf89_vsv_4_20 = nf89_vsv(2);
% nf89_vsv = nf89_vsv([1 3 4 5]);
nf89_vsv = nf89_vsv([3 4 5]);


figure(1); clf;
set(gcf,'position',[250         296        1079         638],'color','w');
lw = 5;
alph = 0.25;
% Vs_lims = [3.95 4.8];
Vs_lims = [4.1 4.8];
FS = 18;

for imod = 1:length(lgd)
    temp = load([path2bayesian_Vs_vpvsPerplex,'/',matname_bayesian{imod}]);
    bayesian_vpvsPerplex = temp.bayesian; clear temp;
    
    matname = matnames{imod};
    temp = load([path2lsqr_Vs,'/',matname]);
    lsqrinv = temp.lsqrinv; clear temp;
    
    subplot(1,2,1); box on; hold on;
    plot_shaded(bayesian_vpvsPerplex.post.vs_l68,bayesian_vpvsPerplex.post.vs_u68,bayesian_vpvsPerplex.z_int,'x',clrs(imod,:), alph); hold on;
%     h62(iproj) = plot(bayesian_vpvsPerplex.post.vs_med,bayesian_vpvsPerplex.z_int,'-','color',clrs(iproj,:),'linewidth',lw);
    ylim(zlims);
    xlim(Vs_lims);
    ylabel('Depth (km)');
    xlabel('V_{S} (km/s)');
    set(gca,'fontsize',FS,'linewidth',1.5,'ydir','reverse','XMinorTick','on','YMinorTick','on');
%     legend(h62,lgd,'location','southwest');

    subplot(1,2,2); box on; hold on;
    plot_shaded(lsqrinv.bootstrap_disc.stats.vsv.l68/1000,lsqrinv.bootstrap_disc.stats.vsv.u68/1000,lsqrinv.bootstrap_disc.stats.z.median,'x',clrs(imod,:), alph); hold on;
end

h1=[]; h2=[];
for imod = 1:length(matnames)
    matname = matnames{imod};
    temp = load([path2lsqr_Vs,'/',matname]);
    lsqrinv = temp.lsqrinv; clear temp;
    
    temp = load([path2bayesian_Vs,'/',matname_bayesian{imod}]);
    bayesian = temp.bayesian; clear temp;
    
    temp = load([path2bayesian_Vs_vpvsPerplex,'/',matname_bayesian{imod}]);
    bayesian_vpvsPerplex = temp.bayesian; clear temp;
    
    subplot(1,2,1); box on; hold on;
    plot(nf89_vsv(imod).vsv,nf89_vsv(imod).z,'--','color',clrs(imod,:)*0.85,'linewidth',3);
%     if imod == 1
%         plot(nf89_vsv_4_20.vsv,nf89_vsv_4_20.z,'--','color',clrs(imod,:)*0.85,'linewidth',3);
%     end
%     plot(bayesian.post.vs_med,bayesian.z_int,':','color',clrs(imod,:),'linewidth',4);
    h1(imod) = plot(bayesian_vpvsPerplex.post.vs_med,bayesian_vpvsPerplex.z_int,'-','color',clrs(imod,:),'linewidth',4);
%     h1(imod) = plot(lsqrinv.card_smooth.vsv/1000,lsqrinv.card_smooth.z,'-','color',clrs(imod,:),'linewidth',4);
    xlabel('V_{SV} (km/s)');
    ylabel('Depth (km)');
    set(gca,'FontSize',FS,'linewidth',1.5,'ydir','reverse');
    legend(h1,lgd,'Location','southwest','fontsize',15)
    xlim(Vs_lims)
    ylim(zlims);
    title('Smooth (Bayesian)');

    subplot(1,2,2); box on; hold on;
    plot(nf89_vsv(imod).vsv,nf89_vsv(imod).z,'--','color',clrs(imod,:)*0.85,'linewidth',3);
%     if imod == 1
%         plot(nf89_vsv_4_20.vsv,nf89_vsv_4_20.z,'--','color',clrs(imod,:)*0.85,'linewidth',3);
%     end
%     plot(bayesian.post.vs_med,bayesian.z_int,':','color',clrs(imod,:),'linewidth',4);
%     plot(bayesian_vpvsPerplex.post.vs_med,bayesian_vpvsPerplex.z_int,':','color',clrs(imod,:),'linewidth',4);
%     h2(imod) = plot(lsqrinv.card_disc.vsv/1000,lsqrinv.card_disc.z,'-','color',clrs(imod,:),'linewidth',4);
    h2(imod) = plot(lsqrinv.bootstrap_disc.stats.vsv.median/1000,lsqrinv.bootstrap_disc.stats.z.median,'-','color',clrs(imod,:),'linewidth',4);
    xlabel('V_{SV} (km/s)');
    ylabel('Depth (km)');
    set(gca,'FontSize',FS,'linewidth',1.5,'ydir','reverse','XMinorTick','on','YMinorTick','on');
%     legend(h2,lgd,'Location','southwest','fontsize',15)
    xlim(Vs_lims)
    ylim(zlims);
    title('Q-informed Inversion');
    
end

save2pdf('./figs/compare_lsqr_bayesian_AGU24.pdf',1,250)

%%

figure(2); clf;
set(gcf,'position',[250         496        1079         438],'color','w');
h1=[]; h2=[];
for imod = 1:length(matnames)
    matname = matnames{imod};
    temp = load([path2lsqr_Vs,'/',matname]);
    lsqrinv = temp.lsqrinv; clear temp;
    
    subplot(1,2,1); box on; hold on;
    errorbar(lsqrinv.periods,lsqrinv.cobs,lsqrinv.cstd,'ok','markerfacecolor',clrs(imod,:)*0.85,'linewidth',1.5,'markersize',10);
    plot_shaded(lsqrinv.bootstrap_smooth.stats.cpre.l68,lsqrinv.bootstrap_smooth.stats.cpre.u68,lsqrinv.periods,'y',clrs(imod,:), alph); hold on;
    h1(imod) = plot(lsqrinv.periods,lsqrinv.bootstrap_smooth.stats.cpre.median,'-','color',clrs(imod,:),'linewidth',4);
    xlabel('Periods (s)');
    ylabel('Phase Velocity (km/s)');
    set(gca,'FontSize',16,'linewidth',1.5);
    legend(h1,lgd,'Location','southeast')
    xlim([10 160])
%     ylim(zlims);
    title('Smooth');

    subplot(1,2,2); box on; hold on;
    errorbar(lsqrinv.periods,lsqrinv.cobs,lsqrinv.cstd,'ok','markerfacecolor',clrs(imod,:)*0.85,'linewidth',1.5,'markersize',10);
    plot_shaded(lsqrinv.bootstrap_smooth.stats.cpre.l68,lsqrinv.bootstrap_disc.stats.cpre.u68,lsqrinv.periods,'y',clrs(imod,:), alph); hold on;
    h2(imod) = plot(lsqrinv.periods,lsqrinv.bootstrap_disc.stats.cpre.median,'-','color',clrs(imod,:),'linewidth',4);
    xlabel('Periods (s)');
    ylabel('Phase Velocity (km/s)');
    set(gca,'FontSize',16,'linewidth',1.5);
    legend(h2,lgd,'Location','southeast')
    xlim([10 160])
%     ylim(zlims);
    title('Discontinuous');
    
end

figure(3); clf;
set(gcf,'position',[174         399        1493         473],'color','w');
for imod = 1:length(matnames)
    matname = matnames{imod};
    temp = load([path2lsqr_Vs,'/',matname]);
    lsqrinv = temp.lsqrinv; clear temp;
    
    temp = load([path2bayesian_Vs_vpvsPerplex,'/',matname_bayesian{imod}]);
    bayesian_vpvsPerplex = temp.bayesian; clear temp;
    
    cobs = bayesian_vpvsPerplex.cobs(:);
    cstd = bayesian_vpvsPerplex.cstd(:);
    
    chi2_bayesian = sum((cobs(:)-bayesian_vpvsPerplex.post.phv_med_pre(:)).^2./cstd(:).^2)./length(cobs);
    chi2_lsqr_smooth = sum((cobs(:)-lsqrinv.bootstrap_smooth.stats.cpre.median(:)).^2./cstd(:).^2)./length(cobs);
    chi2_lsqr_disc = sum((cobs(:)-lsqrinv.bootstrap_disc.stats.cpre.median(:)).^2./cstd(:).^2)./length(cobs);
    
    subplot(1,2,1); box on; hold on;
    h31(1) = plot(lsqrinv.periods,(cobs(:)-bayesian_vpvsPerplex.post.phv_med_pre(:))./cstd(:),'-','color',clrs(imod,:),'linewidth',4);
    h31(2) = plot(lsqrinv.periods,(cobs(:)-lsqrinv.bootstrap_smooth.stats.cpre.median(:))./cstd(:),'--','color',clrs(imod,:),'linewidth',4);
    h31(3) = plot(lsqrinv.periods,(cobs(:)-lsqrinv.bootstrap_disc.stats.cpre.median(:))./cstd(:),':','color',clrs(imod,:),'linewidth',4);
    plot([10 160],[1 1],'--k','linewidth',1.5);
    plot([10 160],[-1 -1],'--k','linewidth',1.5);
    xlabel('Periods (s)');
    ylabel('Residual Phase Velocity (dc/\sigma_c)');
    set(gca,'FontSize',16,'linewidth',1.5);
    legend(h31,{'Bayesian','LSQR (smooth)','LSQR (disc.)'},'Location','southwest')
    xlim([10 160])
%     ylim(zlims);
%     title('Smooth');

    subplot(1,2,2); box on; hold on;
    h32(1) = plot(imod,chi2_bayesian,'ok','markerfacecolor',clrs(imod,:),'linewidth',1.5,'markersize',15);
    h32(2) = plot(imod,chi2_lsqr_smooth,'sk','markerfacecolor',clrs(imod,:),'linewidth',1.5,'markersize',15);
    h32(3) = plot(imod,chi2_lsqr_disc,'^k','markerfacecolor',clrs(imod,:),'linewidth',1.5,'markersize',15);
    xlabel('Location');
    ylabel('\chi^2');
    set(gca,'FontSize',16,'linewidth',1.5);
    legend(h32,{'Bayesian','LSQR (smooth)','LSQR (disc.)'},'Location','southeast')
    xlim([0 length(matnames)+1])
%     ylim(zlims);
%     title('Discontinuous');
    
end

