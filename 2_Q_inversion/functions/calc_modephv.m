% Function to pick out estimated phase velocities from calculated
% dispersion curves.
% This is hardwired when in the spheroidal case because the card files are
% named with set PERIODS (e.g. 0_30, 31_70, 71_120)
% Calls the read_forward_model.m function to read the ascii cards output
% from MINEOS;
% Returns the period and phase velocity closest to the phase velocities of
% interest
%
% NJA, 2014

function [PER,PHV,PERq,PHVq] = calc_modephv(PERIODS,TYPE,MODEid,CARD)

setup_parameters;

% PERIODS = periods;
% MODE = SMODE;
% CARD = cardid;


% PERIODS = param.PERIODS;
% TYPE = 'T';

% CARD = param.CARDID;
isfigure = 0;

       
MODES = unique(MODEid);
ipall = 0;
for ibr = 1:length(MODES)
    MODE = MODES(ibr);
    PERIODSind = find(MODEid==MODE);
    PERS = PERIODS(PERIODSind);
    %     Smode = read_forward_model(CARD,TYPE);
    [Smode, card] = read_forward_model_qfile(CARD,TYPE,MODE);

    modeind = find(Smode(ibr).n == MODE);

    mode_grv = Smode(ibr).grv(modeind);
    mode_t = Smode(ibr).t(modeind);
    mode_phv = Smode(ibr).phv(modeind);
    mode_tq = Smode(ibr).tq(modeind);
    mode_phvq = Smode(ibr).phvq(modeind);

    for ip = 1:length(PERS)
        ipall = ipall+1;
        
        match = abs(mode_t - PERS(ip));
        tinds = find(match == min(match));
        tind = tinds(1);
        PER(ipall) = mode_t(tind);
        PHV(ipall) = mode_phv(tind);
        
        match = abs(mode_tq - PERS(ip));
        tinds = find(match == min(match));
        tind = tinds(1);
        PERq(ipall) = mode_tq(tind);
        PHVq(ipall) = mode_phvq(tind);
    end

    if isfigure
    figure(1)
    clf
    plot(mode_t,mode_grv,'-b','linewidth',2)
    hold on
    plot(mode_t,mode_phv,'--b','linewidth',2)
    plot(PER,PHV,'ok','linewidth',2);
    xlim([min(PERS)-5 max(PERS)+5])
    ylim([2.5 5])
    set(gca,'fontsize',16);
    title('Fundamental Mode');
    end
end

% Sort periods
[PER,Isort] = sort(PER,'descend');
PHV = PHV(Isort);

[PERq,Isort] = sort(PERq,'descend');
PHVq = PHVq(Isort);


end





