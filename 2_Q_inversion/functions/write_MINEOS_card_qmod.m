% Write out both a MINEOS card file and matching qmod file
%
% jbrussell 11/24/2021


function [] = write_MINEOS_card_qmod(bot,qmu_sl,qkap_sl,sz,CARDID,card)
% clear
% Controls
isfigure = 0;
yaxis=[0 400];
% turn off warnings momentarily because they are annoying!
warning('off','all');

setup_parameters;
CARDPATH = param.CARDPATH;

%% Find the depths greater than which we will keep everything the same
dist = 0; %100; % distance overwhich the transition from perturbed velocities to PREM velocities
dp = find(card.z >= bot+dist); % dp = deep -- used to be dp = find(card.rad > bot+1);
z_dp = card.z(dp);
rad_dp = card.rad(dp);
qmu_dp = card.qmu(dp);
qkap_dp = card.qkap(dp);

% Fix NaN in ph
dum = find(isnan(qmu_dp)==1);
qmu_dp(dum) = 99999;
dum = find(isnan(qkap_dp)==1);
qmu_dp(dum) = 99999;

%% Smooth the transition from perturbed velocities to PREM
% Want to create a shallow linear gradient between where the splines stop
% and PREM starts.

ndp = find(card.z > bot & card.z <=bot+dist);

z_tr = card.z(ndp);
rad_tr = card.rad(ndp);
qmu_tr = card.qmu(ndp);
qkap_tr = card.qkap(ndp);

if ~isempty(qmu_tr)
    clear P
    %qmu
    P = polyfit([sz(1) sz(1)+dist],[qmu_sl(1) qmu_tr(1)],1);
    y = polyval(P,z_tr);
    qmu_ntr = y;

    clear P
    %qkap
    P = polyfit([sz(1) sz(1)+dist],[qkap_sl(1) qkap_tr(1)],1);
    y = polyval(P,z_tr);
    qkap_ntr = y;

else
    qmu_ntr = [];
    qkap_ntr = [];
end



if isfigure
    
    figure(22)
    clf
    subplot(1,2,1)
    hold on
    plot(qmu_sl,sz','-r','linewidth',2);
    plot(qmu_dp,z_dp,'-b','linewidth',2);
    plot(qmu_ntr,z_tr,'ok','linewidth',2);
    plot([qmu_sl(1) qmu_tr(1)],[sz(1) sz(1)+dist],'om','linewidth',2)
    ylim(yaxis)
    set(gca,'ydir','reverse')
    
    subplot(1,2,2)
    hold on
    plot(qkap_sl,sz','-r','linewidth',2);
    plot(qkap_dp,z_dp,'-b','linewidth',2);
    plot(qkap_ntr,z_tr,'-k','linewidth',2);
    ylim(yaxis)
    set(gca,'ydir','reverse')
    
end

card.qmu = [qmu_dp',qmu_ntr',qmu_sl'];
card.qkap = [qkap_dp',qkap_ntr',qkap_sl'];

card.qmu(card.qmu>999999) = 999999;
card.qkap(card.qkap>999999) = 999999;
card.qmu(card.qmu<0) = 0;
card.qkap(card.qkap<0) = 0;

nsz = [z_dp',z_tr',sz'];
if isfigure
figure(17)
clf
hold on
plot(nqmu,nsz,'-k','linewidth',2)
plot(nqkap,nsz,'-r','linewidth',2)
end

%% Write qmod

fid=fopen([CARDPATH,CARDID,'.qmod'],'w');
fprintf(fid, '%13i%10s%10s\n',length(card.qmu),'shear','bulk');
for id = 1:length(card.qmu)
    fprintf(fid,'%13.2f%10.2f%10.2f\n'...
        ,[card.rad(id)/1000 card.qmu(id) card.qkap(id)]);
end
fclose(fid);

%% Now begin to write things out to the new model card

fid=fopen([CARDPATH,CARDID,'.card'],'w');

% First the header information
% L1 - Model Card Name
fprintf(fid,'%s\n',CARDID);

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
