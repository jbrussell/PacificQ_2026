function [bootstrap_Vs] = lsqr2bayesian(lsqrinv,type)

% type = 'smooth';
% type = 'disc';

% Convert lsqr structure to bayesian structure
ind = find(lsqrinv.(['card_',type]).z <= lsqrinv.zbot);

z = flip(lsqrinv.(['card_',type]).z(ind));
vsv = flip(lsqrinv.(['card_',type]).vsv(ind)) / 1000;

bootstrap_Vs.bayesian.z_int = z;
bootstrap_Vs.bayesian.post.vs_med = vsv;
bootstrap_Vs.bayesian.post.vs_l68 = vsv;
bootstrap_Vs.bayesian.post.vs_u68 = vsv;

bootstrap_Vs.bayesian.periods = lsqrinv.periods;
bootstrap_Vs.bayesian.post.phv_med_pre = lsqrinv.(['cpre_',type]);
bootstrap_Vs.bayesian.post.phv_l95_pre = lsqrinv.(['cpre_',type]);
bootstrap_Vs.bayesian.post.phv_u95_pre = lsqrinv.(['cpre_',type]);
bootstrap_Vs.bayesian.cobs = lsqrinv.cobs;
bootstrap_Vs.bayesian.cstd = lsqrinv.cstd;

end

