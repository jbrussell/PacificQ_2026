% write_MINE_mod
% Takes in an input file and writes out finely sampled model card for
% MINEOS
% We only care about the top 250 km because the rest of the model will be
% identical to the anisotropic PREM model we already have
%
% NJA, 2014]
%
% BEWARE -- modifications were made to simplify things for a linear test


function [] = write_MINE_mod(bot,sv_sl,sh_sl,sz,pv_sl,ph_sl,eta_sl,CARD)
% clear
% Controls
isfigure = 0;
yaxis=[0 400];
% turn off warnings momentarily because they are annoying!
warning('off','all');

setup_parameters;
CARDPATH = param.CARDPATH;



%% Get information from original model card
card = read_model_card([param.CARDID,'.card']);

%% Find the depths greater than which we will keep everything the same
dist = 0; %100; % distance overwhich the transition from perturbed velocities to PREM velocities
dp = find(card.z >= bot+dist); % dp = deep -- used to be dp = find(card.rad > bot+1);
z_dp = card.z(dp);
rad_dp = card.rad(dp);
sv_dp = card.vsv(dp);
sh_dp = card.vsh(dp);
pv_dp = card.vpv(dp);
ph_dp = card.vph(dp);
eta_dp = card.eta(dp);
% qkap_dp = card.qkap(dp);
% rho_dp = card.rho(dp);
% qmu_dp = card.qmu(dp);

% Fix NaN in ph
dum = find(isnan(ph_dp)==1);
ph_dp(dum) = 0;
%% Smooth the transition from perturbed velocities to PREM
% Want to create a shallow linear gradient between where the splines stop
% and PREM starts.

ndp = find(card.z > bot & card.z <=bot+dist);

z_tr = card.z(ndp);
rad_tr = card.rad(ndp);
% qmu_tr = card.qmu(ndp);
% rho_tr = card.rho(ndp);
% qkap_tr = card.qkap(ndp);
eta_tr = card.eta(ndp);
sv_tr = card.vsv(ndp);
sh_tr = card.vsh(ndp);
pv_tr = card.vpv(ndp);
ph_tr = card.vph(ndp);

if ~isempty(sv_tr)
    clear P
    %sv
    P = polyfit([sz(1) sz(1)+dist],[sv_sl(1) sv_tr(1)],1);
    y = polyval(P,z_tr);
    sv_ntr = y;

    clear P
    %sh
    P = polyfit([sz(1) sz(1)+dist],[sh_sl(1) sh_tr(1)],1);
    y = polyval(P,z_tr);
    sh_ntr = y;

    clear P
    %pv
    P = polyfit([sz(1) sz(1)+dist],[pv_sl(1) pv_tr(1)],1);
    y = polyval(P,z_tr);
    pv_ntr = y;

    clear P
    %ph
    P = polyfit([sz(1) sz(1)+dist],[ph_sl(1) ph_tr(1)],1);
    y = polyval(P,z_tr);
    ph_ntr = y;
    
    clear P
    %eta
    P = polyfit([sz(1) sz(1)+dist],[eta_sl(1) eta_tr(1)],1);
    y = polyval(P,z_tr);
    eta_ntr = y;
else
    sv_ntr = [];
    sh_ntr = [];
    pv_ntr = [];
    ph_ntr = [];
    eta_ntr = [];
end



if isfigure
    
    figure(22)
    clf
    subplot(1,2,1)
    hold on
    plot(sv_sl,sz','-r','linewidth',2);
    plot(sv_dp,z_dp,'-b','linewidth',2);
    plot(sv_ntr,z_tr,'ok','linewidth',2);
    plot([sv_sl(1) sv_tr(1)],[sz(1) sz(1)+dist],'om','linewidth',2)
    ylim(yaxis)
    set(gca,'ydir','reverse')
    
    subplot(1,2,2)
    hold on
    plot(sh_sl,sz','-r','linewidth',2);
    plot(sh_dp,z_dp,'-b','linewidth',2);
    plot(sh_ntr,z_tr,'-k','linewidth',2);
    ylim(yaxis)
    set(gca,'ydir','reverse')
    
    figure(23)
    clf
    subplot(1,2,1)
    hold on
    plot(pv_sl,sz','-g','linewidth',2);
    plot(pv_dp,z_dp,'-b','linewidth',2);
    plot(pv_ntr,z_tr,'ok','linewidth',2);
    ylim(yaxis)
    set(gca,'ydir','reverse')
    
    subplot(1,2,2)
    hold on
    plot(ph_sl,sz','-g','linewidth',2);
    plot(ph_dp,z_dp,'-b','linewidth',2);
    plot(ph_ntr,z_tr,'ok','linewidth',2);
    ylim(yaxis)
    set(gca,'ydir','reverse')
    
end

card.vsv = [sv_dp',sv_ntr',sv_sl'];
card.vsh = [sh_dp',sh_ntr',sh_sl'];
card.vpv = [pv_dp',pv_ntr',pv_sl'];
card.vph = [ph_dp',ph_ntr',ph_sl'];
card.eta = [eta_dp',eta_ntr',eta_sl'];

nsz = [z_dp',z_tr',sz'];
if isfigure
figure(17)
clf
hold on
plot(nsv,nsz,'-k','linewidth',2)
plot(nsh,nsz,'-r','linewidth',2)
end

%% Now begin to write things out to the new model card

fid=fopen([CARDPATH,CARD],'w');

% First the header information
% L1 - Model Card Name
fprintf(fid,'%s\n',CARD);

% L2 - ifanis, tref, ifdeck
ifanis=1;
trec = -1;
ifdeck = 1;

fprintf(fid, '%i\t%f\t%i\n',[ifanis trec ifdeck]);

% L3 - N, nic, noc
% N = length(sz)+length(z_disc_all)+length(z_dp);

% N = length(rad_dp)+length(rad_sl)+length(rad_tr);
N = length(card.rho);
ind_oc = find(card.vsv==0 & card.vpv>7000); % index liquid outer core
nic = ind_oc(1)-1; % top of inner core
noc = ind_oc(end); % top of outer core

fprintf(fid,'%3i\t%2i\t%2i\n',[N nic noc]);

% L4 until end - r, rho, vpv, vsv, qkapp, qshear, vph, vsh, eta
% Remember that r means radius (not depth!)
% Everything else is in m/s (not km/s!)

count = 0;

% First the deeper (unchanged) parts of the model
for id = 1:length(card.rho)
    del = ' ';
    fprintf(fid,'%8.0f%9.2f%9.2f%9.2f%9.1f%9.1f%9.2f%9.2f%9.5f\n'...
        ,[card.rad(id) card.rho(id) card.vpv(id) card.vsv(id) card.qkap(id) card.qmu(id) card.vph(id) card.vsh(id) card.eta(id)]);
    count = count+1;
end

fclose(fid);

if count ~= N
    disp(['N : ',num2str(N),' COUNT : ',num2str(count)]);
    error('Mismatch in layer count!');
end

%turn the warnings back on b/c they can be useful in some cases
warning('on','all')
