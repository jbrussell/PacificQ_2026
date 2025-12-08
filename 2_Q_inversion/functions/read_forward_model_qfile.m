% Program to plot MINEOS model cards
% NJA, 2014
%
% 10/27/2014 Modified to handle either longer period S models (S0_50) or
% shorter period S models (S50_150).
% 
% 10/24/2016 JBR - Reads from .q file instead of .asc file, so that it
% includes the q-corrected period (tq) and phase velocity (phvq)

function [mode, card] = read_forward_model_qfile(CARD,TYPE,MODEid)
% tic
% CARD='EARS.card';
% TYPE = 'T';
% FREQ = '';

isfigure = 0;

% Get useful information for parameter file
setup_parameters;

DATAPATH = param.DATAPATH;
SID = param.SID;
TID = param.TID;
% dum = strsplit(CARD,'.');
% 
% CARD = dum{1};


if strcmp(TYPE,'S') == 1
    CASC = [DATAPATH,CARD,'.',SID,'.asc'];
    QIN = [DATAPATH,CARD,'.',SID,'.q'];
elseif strcmp(TYPE,'T') == 1
    CASC = [DATAPATH,CARD,'.',TID,'.asc'];
    QIN = [DATAPATH,CARD,'.',TID,'.q'];
else
    disp('Type does not exist! Use T or S')
end
cardname = QIN;

% Parameters spcefic to the format of these files
hlines1 = 5;
hlines2 = 6;

% Read model card information
cardname = CASC;
fid = fopen(cardname,'r');
A=textscan...
    (fid,'%f %f %f %f %f %f %f %f %f %f','headerlines',hlines1);

card.fname=cardname;
card.lev = A{1};
card.rad = 6371-A{2}/1000;
card.rho = A{3};
card.vpv = A{4};
card.vph = A{5};
card.vsv = A{6};
card.vsh = A{7};
card.eta = A{8};
card.qmu = A{9};
card.qkap = A{10};


% Read .q file
dat = {};
MODES = unique(MODEid);
for ibr = 1:length(MODES)
    MODE = MODES(ibr);
    imode = MODE+1;
    com = ['awk ''{ if ($1 ==',num2str(MODE),' && $10 != "") print $0}'' ',QIN];
    [log3, dat{imode}] = system(com);
    dat{imode} = str2num(dat{imode});
    nn =  dat{imode}(:,1);
    ll =  dat{imode}(:,2);
    w =   dat{imode}(:,3)/(2*pi)*1000; %convert rad/s ---> mhz
    qq =  dat{imode}(:,4);
    phi = dat{imode}(:,5);
    cv =  dat{imode}(:,6);
    gv =  dat{imode}(:,7);
    cvq = dat{imode}(:,8);
    Tq =  dat{imode}(:,9);
    T =   dat{imode}(:,10);

    mode(imode).fname=cardname;
    mode(imode).n = nn;
    mode(imode).l = ll;
    mode(imode).wrad = w;
    mode(imode).w = w/(2*pi)*1000;
    mode(imode).t = T;
    mode(imode).tq = Tq;
    mode(imode).grv = gv;
    mode(imode).q = qq;
    mode(imode).phv = cv;
    mode(imode).phvq = cvq;
end


% savefile = [CARD,'.',TYPE,'.mat'];
% 
% save(savefile,'card','mode');

% toc
% Choose which card you want to look at

yaxis=[0 500];

% figure(1)
% clf
% subplot(1,2,1)
% plot(card.vsv,card.rad,':','color','k','linewidth',2);
% hold on
% plot(card.vsh,card.rad,'-k','linewidth',2);
% ylabel('Depth');
% xlabel('Vs');
% ylim(yaxis)
% set(gca,'ydir','reverse','fontsize',16)
% title('Vsv vs. Vsh');
% subplot(1,2,2)
% plot(mod.t,mod.grv,':','color','k','linewidth',2);
% xlabel('Period (s)')
% ylabel('Group Velocity');
% hold on
% % plot(mod.t,mod.phv,'-','color','k','linewidth',2);
% xlim([0 150])
% set(gca,'fontsize',16);
% title('Group Velocity against Period');

% Find all fundamental modes





figure(2)
clf
subplot(2,3,1)
plot(card.vpv,card.rad,':','color','r','linewidth',2);
hold on
plot(card.vph,card.rad,'-r','linewidth',2);
ylim(yaxis)
set(gca,'ydir','reverse','fontsize',16)
title('Vpv and Vph')
subplot(2,3,2)
plot(card.eta,card.rad,':','color','r','linewidth',2);
ylim(yaxis)
set(gca,'ydir','reverse','fontsize',16)
title('Eta')
subplot(2,3,3)
plot(card.qmu,card.rad,':','color','r','linewidth',2);
ylim(yaxis)
set(gca,'ydir','reverse','fontsize',16)
title('Qmu')
subplot(2,3,4)
plot(card.qkap,card.rad,':','color','r','linewidth',2);
ylim(yaxis)
set(gca,'ydir','reverse','fontsize',16)
title('Q Kappa')
subplot(2,3,5)
plot(card.rho,card.rad,':','color','r','linewidth',2);
ylim(yaxis)
set(gca,'ydir','reverse','fontsize',16)
title('Density')
% pause
end