clear; close all;
fullMAINpath = mfilename('fullpath');
functionspath = [fullMAINpath(1:regexp(fullMAINpath,mfilename)-1),'functions'];
addpath(functionspath);


%% 12 splines

% % JdF
% matname = './bayesian_mcmc_Qspline_zknot/JdF_uniform_Qmu_bayesian_Nspline12.mat';

% % Young ORCA
% matname = './bayesian_mcmc_Qspline_zknot_112s/YoungORCA_uniform_Qmu_bayesian_Nspline12.mat';

% % NoMelt
% matname = './bayesian_mcmc_Qspline_zknot_112s/NoMelt_uniform_Qmu_bayesian_Nspline12.mat';

% Old ORCA
matname = './bayesian_mcmc_Qspline_zknot_112s/OldORCA_uniform_Qmu_bayesian_Nspline12.mat';

%% 7 splines

% % JdF
% matname = './bayesian_mcmc_Qspline_zknot/JdF_uniform_Qmu_bayesian_Nspline12.mat';

% % Young ORCA
% matname = './bayesian_mcmc_Qspline_zknot_112s_Nspline6/YoungORCA_uniform_Qmu_bayesian_Nspline7.mat';

% % NoMelt
% matname = './bayesian_mcmc_Qspline_zknot/NoMelt_uniform_Qmu_bayesian_Nspline12.mat';

% % Old ORCA
% matname = './bayesian_mcmc_Qspline_zknot_112s/OldORCA_uniform_Qmu_bayesian_Nspline12.mat';

zlims = [0 250];

clrbase = viridis;
cmap = [ flipud([linspace(clrbase(1,1),1,10)',linspace(clrbase(1,2),1,10)',linspace(clrbase(1,3),1,10)']);
        clrbase];

%% Load

temp = load(matname);
bayesian = temp.bayesian; clear temp;

% Read PREM
prem_Q = read_qmod2('./CARDS/PREM.qmod');


%% Plot misfit/likelihood evolution
figure(888); clf;
subplot(2,1,1);
plot([1:length(bayesian.chi2_mat)] * bayesian.nit_save,bayesian.chi2_mat,'o'); hold on;
xlabel('Model #');
ylabel('Misfit');

subplot(2,1,2);
plot([1:length(bayesian.Likelihood)] * bayesian.nit_save,log10(bayesian.Likelihood),'o'); hold on;
xlabel('Model #');
ylabel('log_{10}(Likelihood)');

%% Histograms

figure(1001); clf;
Ncoeffs = size(bayesian.qmu_inv_mat_sp,1);
for ic = 1:Ncoeffs
    
    subplot(ceil(sqrt(Ncoeffs)),ceil(sqrt(Ncoeffs)),ic);
%     plot(priors.qinv_vec,priors.pdf_sp{ic},'-k','linewidth',2); hold on;
    plot(bayesian.qinv_vec,bayesian.post.qmu_inv_pdf_sp(ic,:),'-r','linewidth',1.5); hold on;
%     ylims = get(gca,'YLim');
%     plot(spcoeffs_true(ic)*[1 1],ylims,'--g','linewidth',1.5);
    title(['Coefficient ',num2str(ic)]);
    xlim([min(bayesian.qinv_vec) max(bayesian.qinv_vec)]);
    
end

%%

[~,imin] = min(bayesian.chi2_mat);
i25pct = find(bayesian.chi2_mat <= prctile(bayesian.chi2_mat,1));
% igood = find(chi2_mat < chi_2_thresh);
[chi2_mat_srt, isrt] = sort(bayesian.chi2_mat);
igood = sort(isrt(1:bayesian.params.N_bestfitting));

figure(2); clf;
set(gcf,'Position',[189   507   689   518],'color','w')
sgtitle(bayesian.PROJ,'fontweight','bold','fontsize',20);

subplot(2,2,[1 3]); box on; 
% plot(qmu_inv_mat(:,i25pct),z_int,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
plot(bayesian.qmu_inv_mat_good,bayesian.z_int,'-','color',[0.75 0.75 0.75],'linewidth',3); hold on;
% plot(qmu_inv_ref,z_int,'-k','linewidth',3); hold on;
plot(1./bayesian.frech_S(1).qmu,bayesian.frech_S(1).z,'-k','linewidth',3); hold on;
plot(bayesian.qmu_inv_mat_best,bayesian.z_int,'-r','linewidth',3); hold on;
xlabel('Q_{\mu}^{-1}');
ylabel('Depth (km)');
set(gca,'ydir','reverse');
set(gca,'fontsize',15,'linewidth',1.5);

subplot(2,2,2); box on;
% plot(periods,qinv_pre_mat(:,i25pct),'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
plot(bayesian.periods,bayesian.qinv_pre_mat_good,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
errorbar(bayesian.obs.Rperiods,bayesian.obs.Rqinv,bayesian.obs.Rstdqinv,'-ok','linewidth',2); hold on;
plot(bayesian.periods,bayesian.qinv_pre_mat_best,'-r','linewidth',3);
xlabel('Period (s)');
ylabel('Q^{-1}');
set(gca,'fontsize',15,'linewidth',1.5);

subplot(2,2,4); box on;
% histogram(chi2_mat(i25pct),'linewidth',2); hold on;
histogram(bayesian.chi2_mat(igood),'linewidth',2); hold on;
xlabel('\chi^2')
set(gca,'fontsize',15,'linewidth',1.5);

%% Confidence intervals

qmu_inv_test = 1/1500 * ones(size(bayesian.z_int));
% qmu_inv_test(bayesian.z_int>100 & bayesian.z_int<120) = 1/9;
% qmu_inv_test(bayesian.z_int>100 & bayesian.z_int<115) = 1/6;
% qmu_inv_test(bayesian.z_int>90 & bayesian.z_int<130) = 1/16;
% qmu_inv_test(bayesian.z_int>85 & bayesian.z_int<105) = 1/9;
% qmu_inv_test(bayesian.z_int>99 & bayesian.z_int<101) = 1/0.45;

qinv_pre_test = bayesian.GG * [qmu_inv_test(:); bayesian.qkap_inv(:)];

alph = 0.25;
clr = [0 0 1];
figure(3); clf;
set(gcf,'Position',[189   507   689   518],'color','w')
sgtitle(bayesian.PROJ,'fontweight','bold','fontsize',20);

subplot(2,2,[1 3]); box on; hold on;
qmu_inv_l95 = prctile(bayesian.qmu_inv_mat_good,5,2);
qmu_inv_u95 = prctile(bayesian.qmu_inv_mat_good,95,2);
qmu_inv_med = prctile(bayesian.qmu_inv_mat_good,50,2);
% plot(qmu_inv_mat(:,i25pct),z_int,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
% plot_shaded(qmu_inv_l95,qmu_inv_u95,bayesian.z_int,'x',clr, alph); hold on;
plot_shaded(bayesian.post.qmu_inv_l95,bayesian.post.qmu_inv_u95,bayesian.z_int,'x',clr, alph); hold on;
% plot(qmu_inv_mat(:,igood),z_int,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
% plot(qmu_inv_ref,z_int,'-k','linewidth',2); hold on;
plot(1./bayesian.frech_S(1).qmu,bayesian.frech_S(1).z,'-k','linewidth',3); hold on;
% plot(qmu_inv_med,bayesian.z_int,'-','color',clr,'linewidth',3); hold on;
plot(bayesian.post.qmu_inv_med,bayesian.z_int,'-','color',clr,'linewidth',3); hold on;
plot(bayesian.qmu_inv_mat_best,bayesian.z_int,'-r','linewidth',3); hold on;
xlabel('Q_{\mu}^{-1}');
ylabel('Depth (km)');
set(gca,'ydir','reverse');
set(gca,'fontsize',15,'linewidth',1.5);
ylim(zlims);
plot(qmu_inv_test,bayesian.z_int,'-','color',[1 0.7 0],'linewidth',5);

subplot(2,2,2); box on;
qinv_pre_l95 = prctile(bayesian.qinv_pre_mat_good,5,2);
qinv_pre_u95 = prctile(bayesian.qinv_pre_mat_good,95,2);
qinv_pre_med = prctile(bayesian.qinv_pre_mat_good,50,2);
% plot(periods,qinv_pre_mat(:,i25pct),'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
% plot_shaded(qinv_pre_l95,qinv_pre_u95,bayesian.periods,'y',clr, alph); hold on;
plot_shaded(bayesian.post.qinv_l95_pre,bayesian.post.qinv_u95_pre,bayesian.periods,'y',clr, alph); hold on;
% plot(periods,qinv_pre_mat(:,igood),'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
errorbar(bayesian.obs.Rperiods,bayesian.obs.Rqinv,bayesian.obs.Rstdqinv,'-ok','linewidth',2); hold on;
% plot(bayesian.periods,qinv_pre_med,'-','color',clr,'linewidth',3); hold on;
plot(bayesian.periods,bayesian.post.qinv_med_pre,'-','color',clr,'linewidth',3); hold on;
plot(bayesian.periods,bayesian.qinv_pre_mat_best,'-r','linewidth',3);
xlabel('Period (s)');
ylabel('Q^{-1}');
set(gca,'fontsize',15,'linewidth',1.5);
ylims = get(gca,'ylim');
plot(bayesian.periods,qinv_pre_test,'-','color',[1 0.7 0],'linewidth',5);

subplot(2,2,4); box on;
% histogram(chi2_mat(i25pct),'linewidth',2); hold on;
histogram(bayesian.chi2_mat(igood),'linewidth',2); hold on;
xlabel('\chi^2')
set(gca,'fontsize',15,'linewidth',1.5);

%% Plot Q_mu^-1 Likihood PDF
par.dqinv_vec = 0.001;
bayesian.post.qmu_inv_med = pdf_prctile(bayesian.post.qmu_inv_pdf,bayesian.qinv_vec+par.dqinv_vec/2,50);
bayesian.post.qmu_inv_med(isnan(bayesian.post.qmu_inv_med)) = bayesian.post.qmu_inv_mean(isnan(bayesian.post.qmu_inv_med));
bayesian.post.qmu_inv_l95 = pdf_prctile(bayesian.post.qmu_inv_pdf,bayesian.qinv_vec+par.dqinv_vec/2,2.5);
bayesian.post.qmu_inv_l95(isnan(bayesian.post.qmu_inv_l95)) = bayesian.post.qmu_inv_mean(isnan(bayesian.post.qmu_inv_l95));
bayesian.post.qmu_inv_u95 = pdf_prctile(bayesian.post.qmu_inv_pdf,bayesian.qinv_vec+par.dqinv_vec/2,97.5);
bayesian.post.qmu_inv_u95(isnan(bayesian.post.qmu_inv_u95)) = bayesian.post.qmu_inv_mean(isnan(bayesian.post.qmu_inv_u95));
bayesian.post.qmu_inv_l68 = pdf_prctile(bayesian.post.qmu_inv_pdf,bayesian.qinv_vec+par.dqinv_vec/2,16);
bayesian.post.qmu_inv_l68(isnan(bayesian.post.qmu_inv_l68)) = bayesian.post.qmu_inv_mean(isnan(bayesian.post.qmu_inv_l68));
bayesian.post.qmu_inv_u68 = pdf_prctile(bayesian.post.qmu_inv_pdf,bayesian.qinv_vec+par.dqinv_vec/2,84);
bayesian.post.qmu_inv_u68(isnan(bayesian.post.qmu_inv_u68)) = bayesian.post.qmu_inv_mean(isnan(bayesian.post.qmu_inv_u68));

qmu_inv_pdf_pl = bayesian.post.qmu_inv_pdf;
% % qmu_inv_pdf_pl(log10(qmu_inv_pdf_pl)<-5) = nan;

figure(5); clf;
set(gcf,'Position',[189   507   689   518],'color','w')


ax1 = subplot(2,2,[1 3]); box on; hold on;
surface(bayesian.qinvgrid,bayesian.zgrid,log10(qmu_inv_pdf_pl)); shading interp;
% plot(qmu_inv_mat(:,i25pct),z_int,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
% plot_shaded(qmu_inv_l95,qmu_inv_u95,z_int,'x',clr, alph); hold on;
% plot(qmu_inv_mat(:,igood),z_int,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
% plot(qmu_inv_ref,z_int,'-k','linewidth',2); hold on;
% plot(1./bayesian.frech_S(1).qmu,bayesian.frech_S(1).z,'-k','linewidth',3); hold on;
% plot(qmu_inv_med,bayesian.z_int,'-','color',clr,'linewidth',3); hold on;
% plot(bayesian.qmu_inv_mat_best,bayesian.z_int,'-r','linewidth',3); hold on;
% plot(bayesian.post.qmu_inv_mean,bayesian.z_int,'-c','linewidth',3);
plot(bayesian.post.qmu_inv_med,bayesian.z_int,'-','color',[0.9 0 0],'linewidth',3);
plot(bayesian.post.qmu_inv_l95,bayesian.z_int,'--','color',[0.9 0 0],'linewidth',3);
plot(bayesian.post.qmu_inv_u95,bayesian.z_int,'--','color',[0.9 0 0],'linewidth',3);
% contour(bayesian.qinvgrid,bayesian.zgrid,bayesian.post.qmu_inv_conf_mat,[0.95 0.95],'-m');
plot(prem_Q.qmu_inv,prem_Q.z,'-w','linewidth',2);
plot(prem_Q.qmu_inv,prem_Q.z,'--k','linewidth',2);
caxis([-5 0]);
pos = get(gca,'Position');
cb = colorbar;
ylabel(cb,'log_{10}(Probability)');
set(cb,'linewidth',1.5);
set(gca,'Position',pos);
colormap(cmap);
% colormap(flip(cptcmap('GMT_haxby')));
xlabel('Q_{\mu}^{-1}');
ylabel('Depth (km)');
set(gca,'ydir','reverse','Position',[ax1.Position(1)-0.02 ax1.Position(2) ax1.Position(3) ax1.Position(4)],'layer','top');
set(gca,'fontsize',15,'linewidth',1.5);
cbpos = get(cb,'position');
set(cb,'position',[cbpos(1)+0.0 cbpos(2) cbpos(3) 0.4]);
title(bayesian.PROJ,'fontweight','bold','fontsize',20);
xlim([0 0.05]);
ylim(zlims);

% pos = ax1.Position;
% ax2 = axes('Position',[pos(1)+0.35 pos(2) pos(3)*0.25 pos(4)]);
% % fill(bayesian.post.disc_pdf,bayesian.z_int,'-k','linewidth',2,'FaceColor',[0.9 0 0]);
% ylim(ax1.YLim);
% set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
% yticklabels([]);


% PdF

qinv_pdf_pl = bayesian.post.qinv_pdf;
% % qinv_pdf_pl(log10(qinv_pdf_pl)<-5) = nan;
% qinv_meanpost = sum(qinv_pdf.*qinv_grid,1);

ax3 = subplot(2,2,2); box on; hold on;
surface(bayesian.periods_grid,bayesian.qinv_grid,log10(qinv_pdf_pl)); shading interp;
% scatter(bayesian.periods_grid(:),bayesian.qinv_grid(:),80,log10(qinv_pdf_pl(:)),'filled','markeredgecolor','k');
errorbar(bayesian.obs.Rperiods,bayesian.obs.Rqinv,bayesian.obs.Rstdqinv,'-ok','linewidth',2); hold on;
% plot(bayesian.periods,qinv_pre_med,'-','color',clr,'linewidth',3); hold on;
% plot(bayesian.periods,bayesian.qinv_pre_mat_best,'-r','linewidth',3);
% plot(periods_v,qinv_meanpost,'-c','linewidth',3);
% plot(bayesian.periods,bayesian.post.qinv_mean_pre,'-c','linewidth',3);
plot(bayesian.periods,bayesian.post.qinv_med_pre,'-','color',[0.9 0 0],'linewidth',3);
% plot(bayesian.periods,bayesian.post.qinv_l95_pre,'--','color',[0.9 0 0],'linewidth',3);
% plot(bayesian.periods,bayesian.post.qinv_u95_pre,'--','color',[0.9 0 0],'linewidth',3);
% contour(bayesian.periods_grid,bayesian.qinv_grid,bayesian.post.qinv_conf_mat,[0.95 0.95],'-m');
xlim([min(bayesian.periods) max(bayesian.periods)]);
ylim([0 0.02]);
caxis([-5 0]);
% pos = get(gca,'Position');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)');
% set(cb,'linewidth',1.5);
% set(gca,'Position',pos);
% colormap(cmap);
ylabel('Q^{-1}');
xlabel('Period (s)');
set(gca,'fontsize',15,'linewidth',1.5,'Position',[ax3.Position(1)+0.06 ax3.Position(2) ax3.Position(3) ax3.Position(4)],'layer','top');

if ~exist('./figs')
    mkdir('./figs')
end
% save2pdf(['./figs/',strrep(bayesian.PROJ,' ',''),'_Qinv_Posterior.pdf'],5,1000);
% export_fig(['./figs/Z1_',strrep(bayesian.PROJ,' ',''),'_Qinv_Posterior_PAPER25.pdf'],'-pdf','-q300','-p0.02',5);
print(gcf, ['./figs/Z1_',strrep(bayesian.PROJ,' ',''),'_Qinv_Posterior_PAPER25.png'], '-dpng', '-r600');

% % Force vector renderer
% % 2) Match paper exactly to figure size (tight page)
% set(gcf,'Renderer','painters','InvertHardcopy','off');  % vector, keep bg
% set(gcf,'Units','inches'); pos = get(gcf,'Position');   % [x y w h]
% set(gcf,'PaperUnits','inches', ...
%         'PaperPositionMode','manual', ...
%         'PaperPosition',[0 0 pos(3) pos(4)], ...
%         'PaperSize',[pos(3) pos(4)]);
% print(gcf,'-dpdf', '-painters','-bestfit',['./figs/Z1_',strrep(bayesian.PROJ,' ',''),'_Qinv_Posterior_PAPER25.pdf']);


%% Plot PdF of knot locations

% PdF
figure(6); clf;
set(gcf,'color','w','position',[894   503   377   507]);
box on; hold on;

zsp_pdf_pl = bayesian.post.zsp_pdf ;

knot_ind = [1:size(bayesian.post.zsp_pdf,1)];
[z_int_mat,knot_ind_mat] = meshgrid(bayesian.z_int_vec,knot_ind);

bayesian.post.zsp_med = pdf_prctile(bayesian.post.zsp_pdf,bayesian.z_int_vec,50);
[~,imax] = max(bayesian.post.zsp_pdf');

% w = sum(posteriorsp,1);
% bayesian.post.qmu_inv_mean = sum(w.*bayesian.qmu_inv_mat,2)./sum(w);

% surface(knot_ind_mat-0.5,z_int_mat,log10(zsp_pdf_pl),'EdgeColor','none'); %shading interp;
imagesc(knot_ind,bayesian.z_int_vec,log10(zsp_pdf_pl')); %shading interp;
plot(knot_ind,bayesian.zsp,'ok','MarkerFaceColor','w','markersize',15);
% plot(knot_ind,bayesian.post.zsp_mean,'+','color',[0 0 0],'markersize',12,'linewidth',5);
% plot(knot_ind,bayesian.post.zsp_mean,'+c','color',[1 0 0],'markersize',10,'linewidth',3);
% plot(knot_ind,bayesian.post.zsp_med,'+','color',[0 0 0],'markersize',12,'linewidth',5);
% plot(knot_ind,bayesian.post.zsp_med,'+c','color',[1 0 0],'markersize',10,'linewidth',3);
plot(knot_ind,bayesian.z_int_vec(imax),'+','color',[0 0 0],'markersize',12,'linewidth',5);
plot(knot_ind,bayesian.z_int_vec(imax),'+c','color',[1 0 0],'markersize',10,'linewidth',3);
% scatter(knot_ind_mat(:),z_int_mat(:),80,log10(zsp_pdf_pl(:)),'filled','markeredgecolor','k');
% plot(bayesian.periods,qinv_pre_med,'-','color',clr,'linewidth',3); hold on;
% plot(bayesian.periods,bayesian.qinv_pre_mat_best,'-r','linewidth',3);
% % plot(periods_v,qinv_meanpost,'-c','linewidth',3);
% plot(bayesian.periods,bayesian.post.qinv_mean_pre,'-c','linewidth',3);
% plot(bayesian.periods,bayesian.post.qinv_med_pre,'-','color',[1 0.7 0],'linewidth',3);
% contour(bayesian.periods_grid,bayesian.qinv_grid,bayesian.post.qinv_conf_mat,[0.95 0.95],'-m');
xlim([0.5 max(knot_ind)+0.5]);
ylim([min(bayesian.z_int),max(bayesian.z_int)]);
caxis([-5 0]);
% pos = get(gca,'Position');
cb = colorbar;
ylabel(cb,'log_{10}(Probability)');
set(cb,'linewidth',1.5);
title('Knot Depth');
% set(gca,'Position',pos);
colormap(cmap);
ylabel('Depth (km)');
xlabel('Knot index');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse','layer','top');
% ylim(zlims);
ylim([0 350]);


print(gcf, ['./figs/Z1_',strrep(bayesian.PROJ,' ',''),'_Qinv_knots_PAPER25.png'], '-dpng', '-r600');

% % Force vector renderer
% % 2) Match paper exactly to figure size (tight page)
% set(gcf,'Renderer','painters','InvertHardcopy','off');  % vector, keep bg
% set(gcf,'Units','inches'); pos = get(gcf,'Position');   % [x y w h]
% set(gcf,'PaperUnits','inches', ...
%         'PaperPositionMode','manual', ...
%         'PaperPosition',[0 0 pos(3) pos(4)], ...
%         'PaperSize',[pos(3) pos(4)]);
% print(gcf,'-dpdf', '-painters','-bestfit',['./figs/Z1_',strrep(bayesian.PROJ,' ',''),'_Qinv_knots_PAPER25.pdf']);


figure(7); clf;
plot(sum(zsp_pdf_pl,1),bayesian.z_int_vec)
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse','layer','top');
