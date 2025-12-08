% Inversion code to invert phase velocities for perturbations to spline
% coefficients
%
% NJA, 11/22/2014
%
% Based off of code from 5/2014
%
% JBR 3/28/18
% Reformulate the problem such that have damping towards a model m instead
% of dm
% G(m-m0) = dobs-d0
% Gm = G*m0 + dobs-d0
%    = Ddobs
%

function mest = reformulation_TESTmodelperturb_dr(Lphv,Lstd,Rphv,Rstd,forward,frech_T,frech_S,periods,card)
% Lphv = obs.Lphv;
% Rphv = obs.Rphv;
% Lstd = obs.Lstd;
% Rstd = obs.Rstd;
% % 

isfigure = 0;

setup_parameters;
% periods = param.Cperiods;
bot = param.bot;
% Get forward model
tphv = forward.tphv;
tper = forward.tper;
sphv = forward.sphv;
sper = forward.sper;

for ip = 1:length(periods)
    % Double check that periods match
    
    tmatch = abs(tper - periods(ip));
    tind = find(tmatch == min(tmatch));
    smatch = abs(sper - periods(ip));
    sind = find(smatch == min(smatch));
	% disp(tper)
	% length(tphv(tind))
	% length(sphv(sind))
    Lphv0(ip) = tphv(tind);
    Rphv0(ip) = sphv(sind);
    
%     dCL(ip) = (Lphv0(ip)-Lphv(ip));
%     dCR(ip) = (Rphv0(ip)-Rphv(ip));
%       dCL(ip) = (Lphv(ip));
%       dCR(ip) = (Rphv(ip));
    dCL(ip) = (Lphv(ip)-Lphv0(ip));
    dCR(ip) = (Rphv(ip)-Rphv0(ip));
end

dobs = [dCL,dCR]';

nanind = find(isnan(dobs)==1);

dobs(nanind) = 0;

% change to m/s
dobs = dobs*1000;

% disp(dobs)

%% Build G matrix - pull in coefficient specific sensitivities from the
% perturb_mod script
% This will be organized with the Love wave sensitivities first and then
% the VSV sensitivities
% 
% dTSVdCOEF = kern.TSV;
% dTSHdCOEF = kern.TSH;
% dSSVdCOEF = kern.SSV;
% dSSHdCOEF = kern.SSH;
% 
% % check to make sure matrices look correct
% if size(dTSVdCOEF) ~= size(dSSVdCOEF)
%     disp('Error! Kernel Matrices dont match!')
%     error;
% elseif size(dTSHdCOEF) ~= size(dSSHdCOEF)
%         disp('Error! Kernel Matrices dont match!')
%     error;
% end
% 
% [Ncoef Nper] = size(dTSHdCOEF);

% Find only those sensitiviites ar at depth we care about.

%toph20 = 6365850; % crust1.0

tindrad = find(frech_T(1).rad > (6371-bot)*1000);
sindrad = find(frech_S(1).rad > (6371-bot)*1000);

vsv = card.vsv(sindrad);
vsh = card.vsh(sindrad);
vpv = card.vpv(sindrad);
vph = card.vph(sindrad);
eta = card.eta(sindrad);
vp_vs = vpv./vsv;
rad = card.rad(sindrad);
% dr = [0;diff(rad)*-1]*1000; % km -> m
dr = gradient(rad)*-1*1000; % km -> m

% length(tindrad)
% length(sindrad)
% % 

GG = zeros(ip*2,length(tindrad)*5); % SV, SH, PV, PH, ETA

% size(GG)

% % Sensitivities from Love
% for ip = 1:length(frech_T)
%     GG(ip,1:length(tindrad)) = frech_T(ip).vsv(tindrad)';
%     GG(ip,length(tindrad)+1:length(tindrad)*2) = frech_T(ip).vsh(tindrad);
%     %GG(ip,length(tindrad)*2+1:length(tindrad)*3) dc/dVPV = 0;
%     %GG(ip,length(tindrad)*3+1:length(tindrad)*4) dc/dVPH = 0;
%     %GG(ip,length(tindrad)*4+1:length(tindrad)*5) dc/dETA = 0;
% end
% 
% % Sensitivities from Rayleigh
% for ip = 1:length(frech_S)
%     GG(ip+length(frech_T),1:length(sindrad)) = frech_S(ip).vsv(sindrad);
%     %GG(ip+length(frech_T),length(sindrad)+1:length(sindrad)*2) = frech_S(ip).vsh(sindrad); % dc/dVSH = 0
%     GG(ip+length(frech_T),length(sindrad)*2+1:length(sindrad)*3) = frech_S(ip).vpv(sindrad);
%     GG(ip+length(frech_T),length(sindrad)*3+1:length(sindrad)*4) = frech_S(ip).vph(sindrad);
%     GG(ip+length(frech_T),length(sindrad)*4+1:length(sindrad)*5) = frech_S(ip).eta(sindrad);    
% end

% MAKE SURE H20 LAYERS ARE NOT INCLUDED IN G MATRIX
flipcard = 6371-card.rad;
Tvsh_chk_h20 = card.vsh(flipcard*1000 >= frech_T(1).rad(1));
Svsh_chk_h20 = card.vsh; %card.vsh(flipcard*1000 >= frech_S(1).rad(1));
if length(Tvsh_chk_h20) > length(frech_T(1).rad)
    Tvsh_chk_h20 = Tvsh_chk_h20(2:end);
end
if length(Svsh_chk_h20) > length(frech_S(1).rad)
    Svsh_chk_h20 = Svsh_chk_h20(2:end);
end
tindrad_noh20 = find(frech_T(1).rad > (6371-bot)*1000 & Tvsh_chk_h20 ~= 0);
sindrad_noh20 = find(frech_S(1).rad > (6371-bot)*1000 & Svsh_chk_h20 ~= 0);

% Sensitivities from Love
h20_lays = length(tindrad)-length(tindrad_noh20);
for ip = 1:length(frech_T)
    GG(ip,1:length(tindrad)) = frech_T(ip).vsv(tindrad).*1000;
    GG(ip,length(tindrad)+1:length(tindrad)*2) = frech_T(ip).vsh(tindrad).*1000;
    %GG(ip,length(tindrad)*2+1:length(tindrad)*3) dc/dVPV = 0;
    %GG(ip,length(tindrad)*3+1:length(tindrad)*4) dc/dVPH = 0;
    %GG(ip,length(tindrad)*4+1:length(tindrad)*5) dc/dETA = 0;
end

% Sensitivities from Rayleigh
h20_lays = length(sindrad)-length(sindrad_noh20);
for ip = 1:length(frech_S)
    GG(ip+length(frech_T),1:length(sindrad)) = frech_S(ip).vsv(sindrad).*1000;
    %GG(ip+length(frech_T),length(sindrad)+1:length(sindrad)*2) = frech_S(ip).vsh(sindrad); % dc/dVSH = 0
    GG(ip+length(frech_T),length(sindrad)*2+1:length(sindrad)*3) = frech_S(ip).vpv(sindrad).*1000;
    GG(ip+length(frech_T),length(sindrad)*3+1:length(sindrad)*4) = frech_S(ip).vph(sindrad).*1000;
    GG(ip+length(frech_T),length(sindrad)*4+1:length(sindrad)*5) = frech_S(ip).eta(sindrad).*1000;    
end

%% Reformulate data vector such that have damping toward model m instead of dm
% (See notes from Goran)
% Starting model
m0 = [vsv; vsh; vpv; vph; eta];
Dd = GG*m0;
DdCL = Dd(1:length(periods))' +  dCL;
DdCR = Dd(length(periods)+1:end)' +  dCR;
Ddobs = [DdCL,DdCR]';
Dr = [dr; dr; dr; dr; dr];

%% Make the error weight matrix
[M N] = size(GG);

We = zeros(ip*2,ip*2);

for ip = 1:length(periods)
    
    if Lstd(ip) == 0
        LTstd = 0.15;
    else
        LTstd = Lstd(ip);
    end
    if Rstd(ip) == 0
        RTstd = 0.15;
    else
        RTstd = Rstd(ip);
    end
%     We(ip,ip) = LTstd;
%     We(ip+length(periods),ip+length(periods)) = RTstd;
    We(ip,ip) = 1; %1./sqrt(LTstd);
    We(ip+length(periods),ip+length(periods)) = 1; %1./sqrt(RTstd);

end

% We = We;
% We

% return
%%
if isfigure
% double check the G matrix via observation

figure(1)
clf

CC = jet(length(frech_T));
for ip=1:length(frech_T)
subplot(1,2,1)
hold on
    plot(GG(ip+length(frech_T),1:length(sindrad)),frech_S(ip).rad(sindrad),'-k','color',CC(ip,:));
    plot(GG(ip,1:length(tindrad)),frech_T(ip).rad(tindrad),'--','color',CC(ip,:))
   ylim([(6371-bot)*1000 6371*1000])
   title('Vsv')
   xlim([0 3E-8])
    subplot(1,2,2)
hold on
plot(GG(ip,length(tindrad)+1:length(tindrad)*2),frech_T(1).rad(tindrad),'--','color',CC(ip,:));
% plot(GSH(ip+length(frech_T),:),frech_S(ip).rad(sindrad),'-','color',CC(ip,:));
ylim([(6371-bot)*1000 6371*1000])
title('Vsh')
end


% Lets compare the observed and estimated phase velocities
figure(3)
clf
hold on
plot(periods,Lphv,'-k','linewidth',2)
plot(periods,Rphv,'-','color','r','linewidth',2)
plot(periods,tphv,'ok','linewidth',2)
plot(periods,sphv,'or','linewidth',2)
xlabel('Periods')
ylabel('Phase Velocity')
leg = legend('Obs L Phv','Obs R Phv','Est T Phv','Est S Phv');
end


%% Sediments, crust, mantle depths
clear mest_all
clear D
epsilon = 1e-18; %1e-13; %1e-15; %0.5e-13; %1e-13; %1e-2; %1e-13;%1e-14;%1E-13;
epsilon2 = 1; %1e-2; %1e-13;%1e-14;%1E-13;

bot_seds = 6371-6365; %6371-6369.7; %SEDS 6371-6365; % CRUST 6371-6358;
top_crust = 6371-6365.70;
bot_crust = 6371-6359; %6371-6369.7; %SEDS 6371-6365; % CRUST 6371-6358;
top_man = 6371-6360;
%seds
tindrad_weight = find(frech_T(1).rad > (6371-bot_seds)*1000);
sindrad_weight = find(frech_S(1).rad > (6371-bot_seds)*1000);
tindrad_weight = tindrad_weight(2:end);
sindrad_weight = sindrad_weight(2:end);
%crust
tindrad_weight2 = find(frech_T(1).rad > (6371-bot_crust)*1000 & frech_T(1).rad < (6371-top_crust)*1000);
sindrad_weight2 = find(frech_S(1).rad > (6371-bot_crust)*1000 & frech_S(1).rad < (6371-top_crust)*1000);
tindrad_weight2 = tindrad_weight2(2:end-1);
sindrad_weight2 = sindrad_weight2(2:end-1);
%mantle
tindrad_weightman = find(frech_T(1).rad > (6371-bot)*1000 & frech_T(1).rad < (6371-top_man)*1000);
sindrad_weightman = find(frech_S(1).rad > (6371-bot)*1000 & frech_S(1).rad < (6371-top_man)*1000);
tindrad_weightman = tindrad_weightman(1:end-1);
sindrad_weightman = sindrad_weightman(1:end-1);
L_t_sed = length(tindrad_weight);
L_s_sed = length(sindrad_weight);
L_sed = L_t_sed + L_s_sed;
L_t_cr = length(tindrad_weight2);
L_s_cr = length(sindrad_weight2);
L_cr = L_t_cr + L_s_cr;
L_t_man = length(tindrad_weightman);
L_s_man = length(sindrad_weightman);
L_man = L_t_man + L_s_man;
L = L_sed+L_cr;

%% Make the smoothness matrix
[M N] = size(GG);
% Second Derivative Smoothing
% Crust
D2_cr = zeros(N,N);
for in = 2:N-1 % SV
    D2_cr(in,in-1) = 1;
    D2_cr(in,in) = -2;
    D2_cr(in,in+1) =1;
end
D2_cr(1,1) = -1;
D2_cr(1,2) = 1;
D2_cr(N,N-1) = -1;
D2_cr(N,N) = 1;

D2_cr = zeros(N,N);
for in = 2:N-1 % SV
    D2_cr(in,in-1) = 1;
    D2_cr(in,in) = -2;
    D2_cr(in,in+1) =1;
end
D2_cr(1,1) = -1;
D2_cr(1,2) = 1;
D2_cr(N,N-1) = -1;
D2_cr(N,N) = 1;


D1 = zeros(N,N);
for in = 1:N-1
    D1(in,in) = 1;
    D1(in,in+1) = -1;
end

% Wm
% Wm(N-1,N-2) = 1;
% Wm(N-1,N-1) = -1;
% Wm(N,N-1) = 1;
% Wm(N,N) = -1;

%% CONSTRAINT EQUATIONS : Damped weighted least squares. (solve Fm=f)

% CONSTRAINT EQUATIONS TO DAMP TOWARDS STARTING MODEL : VSV, VSH
%seds
damp_sed = 1e3; %1e-5; %1e15;
%crust
damp_cr = 1e3; %1e-5; %3e-2; %1e-2
%mantle
damp_man = 1e3; %1e-5; %3e-2; %1e-2
% sediments
H3_sed = zeros(L_sed,N);
for iweight = 1:L_s_sed % SV
    ilay = sindrad_weight(iweight)-sindrad(1)+1;
    H3_sed(iweight,ilay) = 1;
    h3_sed(iweight,1) = vsv(ilay);
end
for iweight = 1:L_t_sed % SH
    ilay = tindrad_weight(iweight)-tindrad(1)+1;
    H3_sed(iweight+L_s_sed,ilay+length(sindrad)) = 1;
    h3_sed(iweight+L_s_sed,1) = vsh(ilay);
end
% crust
H3_cr = zeros(L_cr,N);
for iweight = 1:L_s_cr % SV
    ilay = sindrad_weight2(iweight)-sindrad(1)+1;
    H3_cr(iweight,ilay) = 1;
    h3_cr(iweight,1) = vsv(ilay);
end
for iweight = 1:L_t_cr % SH
    ilay = tindrad_weight2(iweight)-tindrad(1)+1;
    H3_cr(iweight+L_s_cr,ilay+length(sindrad)) = 1;
    h3_cr(iweight+L_s_cr,1) = vsh(ilay);
end
% mantle
H3_man = zeros(L_man,N);
for iweight = 1:L_s_man % SV  
    ilay = sindrad_weightman(iweight)-sindrad(1)+1;
    H3_man(iweight,ilay) = 1;
    h3_man(iweight,1) = vsv(ilay);
end
for iweight = 1:L_t_man % SH
    ilay = tindrad_weightman(iweight)-tindrad(1)+1;
    H3_man(iweight+L_s_man,ilay+length(sindrad)) = 1;
    h3_man(iweight+L_s_man,1) = vsh(ilay);
end
H3 = [H3_sed*damp_sed; H3_cr*damp_cr; H3_man*damp_man];
h3 = [h3_sed*damp_sed; h3_cr*damp_cr; h3_man*damp_man];

% CONSTRAINT EQUATIONS TO DAMP H20 COLUMN TOWARDS STARTING MODEL :
% VSV,VSH,VPV,VPH
%h20
damp_h20 = 1e3; %1e-5; %1e15;
% sediments
H6_sed = zeros(L_sed,N);
for iweight = 1:L_s_sed:h20_lays % SV
    ilay = sindrad_weight(iweight)-sindrad(1)+1;
    H6_sed(iweight,ilay) = 1;
    h6_sed(iweight,1) = vsv(ilay);
end
for iweight = L_s_sed-h20_lays+1:L_s_sed % SH
    ilay = tindrad_weight(iweight)-tindrad(1)+1;
    H6_sed(iweight+L_s_sed,ilay+length(sindrad)) = 1;
    h6_sed(iweight+L_s_sed,1) = vsh(ilay);
end
for iweight = L_s_sed-h20_lays+1:L_s_sed % PV  
    ilay = sindrad_weight(iweight)-sindrad(1)+1;
    H6_sed(iweight+2*L_s_sed,ilay+length(sindrad)*2) = 1; %vpv
    h6_sed(iweight+2*L_s_sed,1) = vpv(ilay);
end
for iweight = L_s_sed-h20_lays+1:L_s_sed % PH
    ilay = tindrad_weight(iweight)-tindrad(1)+1;
    H6_sed(iweight+3*L_s_sed,ilay+length(sindrad)*3) = 1; %vph
    h6_sed(iweight+3*L_s_sed,1) = vph(ilay);
end
H6 = [H6_sed*damp_h20];
h6 = [h6_sed*damp_h20];

% CONSTRAINT EQUATIONS TO ENFORCE ETA constant % dETA = 0;
damp1 = 1e4; %1e2;
L = length(tindrad);
H1 = zeros(L,N);
for i = 1:L % ETA 
    ilay = sindrad(i)-sindrad(1)+1;
    H1(i,ilay+length(sindrad)*4) = 1;
    h1(i,1) = eta(ilay);
end
if size(H1,1)~=L
    error('Check D matrix!');
end
H1 = H1*damp1;
h1 = h1*damp1;

% CONSTRAINT EQUATIONS TO DAMP VP/VS TOWARDS STARTING VP/VS %       VP - (Vp/Vs)*VS = 0
%seds
damp_sed = 1e3; %1e3; %1e15;
% VpVs_sed = 1.85;
%crust
damp_cr = 1e3; %1e3; %3e-2; %1e-2
% VpVs_cr = 1.85;
%mantle
damp_man = 1e3;
% VpVs_man = 1.85;
% sediments
H2_sed = zeros(L_sed-2*h20_lays,N);
for iweight = 1:(L_s_sed-h20_lays) % PV  
    ilay = sindrad_weight(iweight)-sindrad(1)+1;
    H2_sed(iweight,ilay) = -vp_vs(ilay); %vsv
    H2_sed(iweight,ilay+length(sindrad)*2) = 1; %vpv
    h2_sed(iweight,1) = 0;
end
for iweight = 1:(L_t_sed-h20_lays) % PH
    ilay = tindrad_weight(iweight)-tindrad(1)+1;
    H2_sed(iweight+L_s_sed,ilay+length(sindrad)) = -vp_vs(ilay); %vsh
    H2_sed(iweight+L_s_sed,ilay+length(sindrad)*3) = 1; %vph
    h2_sed(iweight+L_s_sed,1) = 0;
end
% crust
H2_cr = zeros(L_cr,N);
for iweight = 1:L_s_cr % PV  
    ilay = sindrad_weight2(iweight)-sindrad(1)+1;
    H2_cr(iweight,ilay) = -vp_vs(ilay); %vsv
    H2_cr(iweight,ilay+length(sindrad)*2) = 1; %vpv
    h2_cr(iweight,1) = 0;
end
for iweight = 1:L_t_cr % PH
    ilay = tindrad_weight2(iweight)-tindrad(1)+1;
    H2_cr(iweight+L_s_cr,ilay+length(sindrad)) = -vp_vs(ilay); %vsh
    H2_cr(iweight+L_s_cr,ilay+length(sindrad)*3) = 1; %vph
    h2_cr(iweight+L_s_cr,1) = 0;
end
% mantle
H2_man = zeros(L_man,N);
for iweight = 1:L_s_man % PV  
    ilay = sindrad_weightman(iweight)-sindrad(1)+1;
    H2_man(iweight,ilay) = -vp_vs(ilay); %vsv
    H2_man(iweight,ilay+length(sindrad)*2) = 1; %vpv
    h2_man(iweight,1) = 0;
end
for iweight = 1:L_t_man % PH
    ilay = tindrad_weightman(iweight)-tindrad(1)+1;
    H2_man(iweight+L_s_man,ilay+length(sindrad)) = -vp_vs(ilay); %vsh
    H2_man(iweight+L_s_man,ilay+length(sindrad)*3) = 1; %vph
    h2_man(iweight+L_s_man,1) = 0;
end
H2 = [H2_sed*damp_sed; H2_cr*damp_cr; H2_man*damp_man];
h2 = [h2_sed*damp_sed; h2_cr*damp_cr; h2_man*damp_man];

% % CONSTRAINT EQUATIONS TO ENFORCE Vp/Vs ratio % dVp - VpVs*dVs = VpVs*Vs - Vp
% % ENTIRE MODEL
% damp = 1e3;
% VpVs = 1.8;
% bot_crust = 6371-6365.8; %H20 %6371-6369.7; %SEDS 6371-6365; % CRUST 6371-6358;
% tindrad_vpvs = find(frech_T(1).rad <= (6371-bot_crust)*1000 & frech_T(1).rad > (6371-bot)*1000);
% tindrad_vpvs = tindrad_vpvs(1:end-1);
% sindrad_vpvs = find(frech_S(1).rad <= (6371-bot_crust)*1000 & frech_S(1).rad > (6371-bot)*1000);
% sindrad_vpvs = sindrad_vpvs(1:end-1);
% L_t = length(tindrad_vpvs);
% L_s = length(sindrad_vpvs);
% L = L_t + L_s;
% H2 = zeros(L,N);
% for i = 1:L_s % PV  
%     ilay = sindrad_vpvs(i)-sindrad(1)+1;
%     H2(i,ilay) = -VpVs; %dvsv
%     H2(i,ilay+length(sindrad)*2) = 1; %dvpv
%     h2(i,1) = VpVs*vsv(ilay)-vpv(ilay);
% end
% for i = 1:L_t % PH
%     ilay = tindrad_vpvs(i)-tindrad(1)+1;
%     H2(i+L_s,ilay+length(sindrad)) = -VpVs; %dvsh
%     H2(i+L_s,ilay+length(sindrad)*3) = 1; %dvph
%     h2(i+L_s,1) = VpVs*vsh(ilay)-vph(ilay);
% end
% H2 = H2*damp;
% h2 = h2*damp;
% if size(H2,1)~=L
%     error('Check D matrix!');
% end

% CONSTRAINT EQUATIONS TO ENFORCE ISOTROPIC (VSH/VSV)^2=1 % (dVsh - dVsv = Vsv - Vsh);
%seds
damp_sed = 1e3; %1e0; %0; %0; %1e0; %1e15;
%crust
damp_cr = 1e3; %1e0; %3e-2; %0; %1e0; %3e-2; %1e-2
%mantle
damp_man = 1e3; %1e0; %0;
% sediments
H4_sed = zeros(L_s_sed,N);
for iweight = 1:L_s_sed
    ilay = sindrad_weight(iweight)-sindrad(1)+1;
    H4_sed(iweight,ilay) = -1; %dvsv
    H4_sed(iweight,ilay+length(sindrad)*1) = 1; %dvsh
    h4_sed(iweight,1) = 0;
end
% crust
H4_cr = zeros(L_s_cr,N);
for iweight = 1:L_s_cr
    ilay = sindrad_weight2(iweight)-sindrad(1)+1;
    H4_cr(iweight,ilay) = -1; %dvsv
    H4_cr(iweight,ilay+length(sindrad)*1) = 1; %dvsh
    h4_cr(iweight,1) = 0;
end
% mantle
H4_man = zeros(L_s_man,N);
for iweight = 1:L_s_man
    ilay = sindrad_weightman(iweight)-sindrad(1)+1;
    H4_man(iweight,ilay) = -1; %dvsv
    H4_man(iweight,ilay+length(sindrad)*1) = 1; %dvsh
    h4_man(iweight,1) = 0;
end
H4 = [H4_sed*damp_sed; H4_cr*damp_cr; H4_man*damp_man];
h4 = [h4_sed*damp_sed; h4_cr*damp_cr; h4_man*damp_man];

% FORCE MODEL PERTURBATION
%mantle
damp_cr = 0; %1e3; %0;
%mantle
damp_man = 1e5; %1e3; %0;
perturb_man = 0.04; % in units %
% crust
H5_cr = zeros(L_cr,N);
for iweight = 1:L_s_cr % SV
    ilay = sindrad_weight2(iweight)-sindrad(1)+1;
    H5_cr(iweight,ilay) = 1;
    h5_cr(iweight,1) = vsv(ilay);
end
for iweight = 1:L_t_cr % SH
    ilay = tindrad_weight2(iweight)-tindrad(1)+1;
    H5_cr(iweight+L_s_cr,ilay+length(sindrad)) = 1;
    h5_cr(iweight+L_s_cr,1) = vsh(ilay);
end
% mantle
H5_man = zeros(L_man,N);
for iweight = L_s_man-5:L_s_man % SV  
    ilay = sindrad_weightman(iweight)-sindrad(1)+1;
    H5_man(iweight,ilay) = 1;
    h5_man(iweight,1) = vsv(ilay)*(1+perturb_man);
end
for iweight = L_t_man-5:L_t_man % SH
    ilay = tindrad_weightman(iweight)-tindrad(1)+1;
    H5_man(iweight+L_s_man,ilay+length(sindrad)) = 1;
    h5_man(iweight+L_s_man,1) = vsh(ilay)*(1+perturb_man);
end
H5 = [H5_cr*damp_cr; H5_man*damp_man];
h5 = [h5_cr*damp_cr; h5_man*damp_man];

H = [H1; H2; H3; H4; H5; H6]; % where H = D
h = [h1; h2; h3; h4; h5; h6]; % h = D*mhat
F = [We.^(1/2)*GG; epsilon2*H];
% f = [We.^(1/2)*dobs; epsilon2*h];
f = [We.^(1/2)*Ddobs; epsilon2*h];
[MF, NF] = size(F);
% Finv = F'/(F*F'); % minimum length
% Finv = F'/(F*F'+epsilon*eye(MF,MF)); % minimum length
%Finv = (F'*F)\F'; % least squares
Finv = (F'*F+epsilon*eye(NF,NF))\F'; % least squares
mest_all = Finv*f;

% Predicted Phase velocities
% LRphv_pre = GG*mest_all;
dLRphv_pre = (GG.*Dr')*(mest_all-m0);
dLphv_pre = dLRphv_pre(1:length(periods))'/1000;
dRphv_pre = dLRphv_pre(length(periods)+1:2*length(periods))'/1000;

Lphv_pre = Lphv0 + dLphv_pre;
Rphv_pre = Rphv0 + dRphv_pre;

%%
% mest.SV = mest.SV/(1000^3);
% mest.SV = mest.SV/(10^8);
% mest_all = mest_all/(1E6); %mest_all/(1E0); %mest_all/(1E6); %mest_all/(1E10); %mest_all/(1E6); % m/s
mest.SV = mest_all(1:length(tindrad));
mest.SH = mest_all(length(tindrad)+1:length(tindrad)*2);
mest.PV = mest_all(length(sindrad)*2+1:length(sindrad)*3);
mest.PH = mest_all(length(sindrad)*3+1:length(sindrad)*4);
mest.ETA = mest_all(length(sindrad)*4+1:length(sindrad)*5);
disp('SV')
disp(mest.SV);
disp('SH')
disp(mest.SH);

mest.Lphv_pre = Lphv_pre;
mest.Rphv_pre = Rphv_pre;

% mest.SH = (GSH'*GSH)\(GSH'*dobs);
% mest.SH = lsqr(GSH,dobs);
% mest.SH = lsqr(GSH,dCL');
% 
% mest.SH = mest.SH/(1e6);

% mest.SH = mest.SH/(10^8);
% mest.SH = mest.SH/(1000^3);

% disp('SH')
% disp(mest.SH);
% 
% save(savefile,'mest');

%     end % Ny
% end % Nx
