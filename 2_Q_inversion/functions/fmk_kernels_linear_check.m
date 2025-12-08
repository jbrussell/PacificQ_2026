% Driver to Calculate Frechet Kernels in terms of Phase Velocity
% NJA, 2014
%
% This involves calling fortran programs plot_wk, frechet, frechet_gv,
% frechet_pv
%
% 2/3/2015 added switch to turn on calculation of psi kernels

function [FRECH_T,FRECH_S] = fmk_kernels_linear_check(CARD,RUNPATH,PERIODS_T,PERIODS_S,TMODEid,SMODEid,ispsi)

setup_parameters;
% CARD = param.CARDID;
% RUNPATH = param.RUNPATH;
% PERIODS = param.periods;
CARDID = param.CARDID;
TID = param.TID;
SID = param.SID;
% SMODE = param.SMODE;
% TMODE = param.TMODE;
BINPATH = param.BINPATH;
DATAPATH = param.DATAPATH;


yaxis = [6100000 6371000];

isfigure = 0;

% Set path to executables
% set_plotwk_path;

% Change environment variables to deal with gfortran
setenv('GFORTRAN_STDIN_UNIT', '5')
setenv('GFORTRAN_STDOUT_UNIT', '6')
setenv('GFORTRAN_STDERR_UNIT', '0')
setenv('DYLD_LIBRARY_PATH', '/usr/local/bin:/opt/local/lib:')

%% Make branch files
TYPE = 'T';
disp('--- Make Branch Files ---');
write_plotwk(TYPE,CARD);

com = ['cat ',RUNPATH,'run_plotwk.t | ',BINPATH,'plot_wk'];
[status,log] = system(com);
if status ~= 0     
    disp( 'something is wrong at plot_wk T')
    return
end

%%%%%%% Make Frechet Kernels!
disp('--- Make Frechet Kernels ---');
% set_mineos_path;

NDISC = 0;
ZDISC = [];
% Check for fixed eigenfunction files
com = ['ls ',DATAPATH,'/',CARD,'.',TID,'_1.eig_fix | cat'];
[status eig_fils] = system(com);
if strcmp(eig_fils(end-25:end-1),'No such file or directory')
    disp('Found no *.eig_fix files')
    write_frechet(TYPE,CARD,NDISC,ZDISC)
else
    disp('Found *.eig_fix files')
    write_frech_chk(TYPE,CARD,NDISC,ZDISC)
end
% write_frechet(TYPE,CARD,NDISC,ZDISC)

if ispsi == 1
    com = ['cat ',RUNPATH,'run_frechet.t | ',BINPATH,'frechet_psi'];
else
com = ['cat ',RUNPATH,'run_frechet.t | ',BINPATH,'frechet'];
end
[status,log] = system(com);
if status ~= 0     
    error( 'something is wrong at frechet T')
end


MODES = unique(TMODEid);
PERsaveT = [];
FRECHsaveT = [];
for ibr = 1:length(MODES)
    branch = MODES(ibr);
    PERIODSind = find(TMODEid==branch);
    periods = PERIODS_T(PERIODSind);
    %%%%%%% Make CV Frechet Kernels
    disp('--- Make CV Frechet Kernels ---');

    write_frechcv(TYPE,CARD,branch);

    com = ['cat ',RUNPATH,'run_frechcv.t | ',BINPATH,'frechet_cv'];
    [status,log] = system(com);
    if status ~= 0     
        error( 'something is wrong at frechet_cv T')
    end

    % Convert CV Frechet kernels to ascii
    % Will do this for all periods of interest
    % Set inside the setparam_MINE.m
    disp('--- Convert Frechet CV to ascii ---');

    % Program writes run file for draw_frechet_gv, runs it, and reads in
    % sensitivity kernels for all periods of interest

    if ispsi == 1
        % psi is in place of sh and sv remains unchanged

        FRECH_T = frechpsi_asc(TYPE,CARD,branch,periods);
    else
        FRECH_T = frechcv_asc(TYPE,CARD,branch,periods);
    end
    
    PERsaveT = [PERsaveT; periods(:)];
    FRECHsaveT = [FRECHsaveT, FRECH_T];
end
% Sort periods
[PERsave_sort,Isort] = sort(PERsaveT,'descend');
FRECH_T = FRECHsaveT(Isort);

%% Spheroidal
TYPE = 'S';
%%%%% Make branch files
disp('--- Make Branch Files ---');
write_plotwk(TYPE,CARD);

com = ['cat ',RUNPATH,'run_plotwk.s | ',BINPATH,'plot_wk'];
[status,log] = system(com);
if status ~= 0     
    disp( 'something is wrong at plot_wk S')
    return
end

%%%%%%% Make Frechet Kernels!
disp('--- Make Frechet Kernels ---');
% set_mineos_path;

% Check for fixed eigenfunction files
com = ['ls ',DATAPATH,'/',CARD,'.',SID,'_1.eig_fix | cat'];
[status eig_fils] = system(com);
if strcmp(eig_fils(end-25:end-1),'No such file or directory')
    disp('Found no *.eig_fix files')
    write_frechet(TYPE,CARD,NDISC,ZDISC)
else
    disp('Found *.eig_fix files')
    write_frech_chk(TYPE,CARD,NDISC,ZDISC)
end
% write_frechet(TYPE,CARD,NDISC,ZDISC)
% disp('Be patient! This will take ~25 s');
tic
com = ['cat ',RUNPATH,'run_frechet.s | ',BINPATH,'frechet'];
[status,log] = system(com);
toc
if status ~= 0     
    error( 'something is wrong at frechet S')
end


MODES = unique(SMODEid);
PERsaveS = [];
FRECHsaveS = [];
for ibr = 1:length(MODES)
    branch = MODES(ibr);
    PERIODSind = find(SMODEid==branch);
    periods = PERIODS_S(PERIODSind);
    %%%%%%% Make CV Frechet Kernels
    write_frechcv(TYPE,CARD,branch)

    com = ['cat ',RUNPATH,'run_frechcv.s | ',BINPATH,'frechet_cv'];
    [status,log] = system(com);
    if status ~= 0     
        error( 'something is wrong at frechet_cv S')
    end

    % Convert CV Frechet kernels to ascii
    % Will do this for all periods of interest
    % Set inside the setparam_MINE.m
    disp('--- Convert Frechet CV to ascii ---');

    % Program writes run file for draw_frechet_gv, runs it, and reads in
    % sensitivity kernels for all periods of interest

    FRECH_S = frechcv_asc(TYPE,CARD,branch,periods);
    
    PERsaveS = [PERsaveS; periods(:)];
    FRECHsaveS = [FRECHsaveS, FRECH_S];
end
% Sort periods
[PERsave_sort,Isort] = sort(PERsaveS,'descend');
FRECH_S = FRECHsaveS(Isort);

%%
if isfigure
    figure(61)
    clf
    figure(62)
    clf
    xaxis = [0 3E-8];
    for ip = 1:length(PERIODS_S)
        CC = winter(length(PERIODS_S));
        figure(61)
        subplot(1,2,1)
        hold on
        plot(FRECH_S(ip).vsv,FRECH_S(ip).rad,'-k','linewidth',2,'color',CC(ip,:))
        ylim(yaxis)
        %         xlim(xaxis)
        title('Spheroidal SV')
        subplot(1,2,2)
        hold on
        plot(FRECH_S(ip).vsh,FRECH_S(ip).rad,'--k','linewidth',2,'color',CC(ip,:))
        ylim(yaxis)
        %         xlim(xaxis)
        title('Spheroidal SH')
    end
    for ip = 1:length(PERIODS_T)
        CC = winter(length(PERIODS_T));
        figure(62)
        subplot(1,2,2)
        hold on
        plot(FRECH_T(ip).vsv,FRECH_T(ip).rad,'-k','linewidth',2,'color',CC(ip,:))
        ylim(yaxis)
        %         xlim(xaxis)
        title('Toroidal SV')
        subplot(1,2,1)
        hold on
        plot(FRECH_T(ip).vsh,FRECH_T(ip).rad,'--k','linewidth',2,'color',CC(ip,:))
        if ispsi == 1
            title('Toroidal PSI')
        else
            title('Toroidal SH')
        end
        ylim(yaxis)
       
    end
%     pause
    %
    %     subplot(1,2,1)
    %     hold on
    %     legend(llegend)
    %     subplot(1,2,2)
    %     hold on
    %     legend(llegend)
end

% savefile = [CARD,'_fcv.mat'];
% save(savefile,'FRECH_T','FRECH_S');
% Change the environment variables back to the way they were
setenv('GFORTRAN_STDIN_UNIT', '-1')
setenv('GFORTRAN_STDOUT_UNIT', '-1')
setenv('GFORTRAN_STDERR_UNIT', '-1')
