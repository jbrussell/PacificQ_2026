function [bootstrap_Vs,bootstrap_Q,discs] = load_VsQ_models_bayesian(PROJ,path2Vs,path2Q,type,fignum)
    

clrs = [1 0 0];
iproj = 1;

%% Plot
figure(fignum); clf;
set(gcf,'color','w');
sgtitle(PROJ,'fontsize',18,'fontweight','bold');
lw = 5;
alph = 0.25;

temp = load([path2Vs]);
bootstrap_Vs = temp;
% lsqrinv = temp.lsqrinv;
% bootstrap_Vs = lsqr2bayesian_2(lsqrinv,type);

% discs = [lsqrinv.par.discs(1); lsqrinv.par.discs(end); lsqrinv.par.zdisc_Q(:)];
discs = [];

temp = load([path2Q]);
bootstrap_Q = temp;
%     temp = load([path2vbr,'/','VBRout_',vbr_method,'_',modeltype,'_',num2str(ages(iproj)),'Myr_T',num2str(Tp),'C_',num2str(dg_mm),'mm','.mat']);
%     vbr = temp;
zh2o = bootstrap_Vs.bayesian.z_int(2);


% Load S362ANI profile
stations = readtable(['./station_files/stations_',strrep(PROJ,' ',''),'.txt']);
lat = mean(stations.Var2(:));
lon = mean(stations.Var3(:));
s362ani = load_S362ANI_profile(['./S362ANI_plotting/S362ANI_kmps.nc'],lat,lon);
s362ani.vs = sqrt((2*s362ani.vsv.^2 + s362ani.vsh.^2)/3);
bootstrap_Vs.xi = interp1(s362ani.z,s362ani.xi,bootstrap_Vs.bayesian.z_int);
%     bootstrap_Vs.xi(isnan(bootstrap_Vs.xi)) = 1;
bootstrap_Vs.xi(isnan(bootstrap_Vs.xi)) = s362ani.xi(1);
%     bootstrap_Vs.xi = 1.04 * ones(size(bootstrap_Vs.xi));
%     bootstrap_Vs.xi = 1 * ones(size(bootstrap_Vs.xi));

% Estimate isotropic Vs
bootstrap_Vs.bayesian.post.vsh_l68 = bootstrap_Vs.bayesian.post.vs_l68 .* sqrt(bootstrap_Vs.xi);
bootstrap_Vs.bayesian.post.vsh_u68 = bootstrap_Vs.bayesian.post.vs_u68 .* sqrt(bootstrap_Vs.xi);
bootstrap_Vs.bayesian.post.vsh_med = bootstrap_Vs.bayesian.post.vs_med .* sqrt(bootstrap_Vs.xi);
bootstrap_Vs.bayesian.post.vsvoigt_l68 = sqrt((2*bootstrap_Vs.bayesian.post.vs_l68.^2 + bootstrap_Vs.bayesian.post.vsh_l68.^2)/3);
bootstrap_Vs.bayesian.post.vsvoigt_u68 = sqrt((2*bootstrap_Vs.bayesian.post.vs_u68.^2 + bootstrap_Vs.bayesian.post.vsh_u68.^2)/3);
bootstrap_Vs.bayesian.post.vsvoigt_med = sqrt((2*bootstrap_Vs.bayesian.post.vs_med.^2 + bootstrap_Vs.bayesian.post.vsh_med.^2)/3);


% Plot Vs
ax2 = subplot(1,2,1); box on; hold on;
h62(iproj) = plot_shaded(bootstrap_Vs.bayesian.post.vsvoigt_l68,bootstrap_Vs.bayesian.post.vsvoigt_u68,bootstrap_Vs.bayesian.z_int,'x',clrs(iproj,:), alph); hold on;
h62(iproj) = plot(bootstrap_Vs.bayesian.post.vsvoigt_med,bootstrap_Vs.bayesian.z_int,'-','color',clrs(iproj,:),'linewidth',lw);
legend(h62,PROJ,'location','southwest');
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
ylabel('Depth (km)');
xlabel('V_{S} (km/s)');
xlim([4.1 4.8]);

% Plot Q^-1
ax3 = subplot(1,2,2); box on; hold on;
if iproj == 1
%         plot(prem_Q.qmu_inv,prem_Q.z,'--k','linewidth',2);
end
plot_shaded(bootstrap_Q.bayesian.post.qmu_inv_l68,bootstrap_Q.bayesian.post.qmu_inv_u68,bootstrap_Q.bayesian.z_int,'x',clrs(iproj,:), alph); hold on;
plot(bootstrap_Q.bayesian.post.qmu_inv_med,bootstrap_Q.bayesian.z_int,'-','color',clrs(iproj,:),'linewidth',lw);
set(gca,'fontsize',16,'linewidth',1.5,'ydir','reverse');
ylabel('Depth (km)');
xlabel('Q_{\mu}');

end

