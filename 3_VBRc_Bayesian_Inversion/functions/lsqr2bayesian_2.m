function [bootstrap_Vs] = lsqr2bayesian_2(lsqrinv,type)

% type = 'smooth';
% type = 'disc';

% Convert lsqr structure to bayesian structure
ind = find(lsqrinv.(['bootstrap_',type]).stats.z.median <= lsqrinv.zbot);

z = flip(lsqrinv.(['bootstrap_',type]).stats.z.median(ind));
vsv = flip(lsqrinv.(['bootstrap_',type]).stats.vsv.median(ind)) / 1000;

bootstrap_Vs.bayesian.z_int = z;
bootstrap_Vs.bayesian.post.vs_med = vsv;
bootstrap_Vs.bayesian.post.vs_l68 = flip(lsqrinv.(['bootstrap_',type]).stats.vsv.l68(ind)) / 1000;
bootstrap_Vs.bayesian.post.vs_u68 = flip(lsqrinv.(['bootstrap_',type]).stats.vsv.u68(ind)) / 1000;
bootstrap_Vs.bayesian.post.vs_l95 = flip(lsqrinv.(['bootstrap_',type]).stats.vsv.l95(ind)) / 1000;
bootstrap_Vs.bayesian.post.vs_u95 = flip(lsqrinv.(['bootstrap_',type]).stats.vsv.u95(ind)) / 1000;

bootstrap_Vs.bayesian.periods = lsqrinv.periods;
bootstrap_Vs.bayesian.post.phv_med_pre = lsqrinv.(['bootstrap_',type]).stats.cpre.median;
bootstrap_Vs.bayesian.post.phv_l68_pre = lsqrinv.(['bootstrap_',type]).stats.cpre.l68;
bootstrap_Vs.bayesian.post.phv_u68_pre = lsqrinv.(['bootstrap_',type]).stats.cpre.u68;
bootstrap_Vs.bayesian.post.phv_l95_pre = lsqrinv.(['bootstrap_',type]).stats.cpre.l95;
bootstrap_Vs.bayesian.post.phv_u95_pre = lsqrinv.(['bootstrap_',type]).stats.cpre.u95;
bootstrap_Vs.bayesian.cobs = lsqrinv.cobs;
bootstrap_Vs.bayesian.cstd = lsqrinv.cstd;

bootstrap_Vs.bayesian.par = lsqrinv.par;

end

