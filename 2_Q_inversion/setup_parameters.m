% Setup Parameters
% Invert Rayleigh and Love waves for Vsv and Vsh in a layered structure
% using Mineos to calculate kernels and dispersion
%
% NJA, 9/30/2014
% Edited JBR, 10/23/2016

% prepend functions directory to MATLAB path
fullMAINpath = mfilename('fullpath');
functionspath = [fullMAINpath(1:regexp(fullMAINpath,mfilename)-1),'functions'];
addpath(functionspath);

% Read in card name and data file
fid = fopen('fileinfo.txt','r');
param.CARDID = fgetl(fid);
datafile = fgetl(fid);
fclose(fid);

param.Path2runMineos = './MINEOS/run_MINEOS/';

% param.layers = [25 50 :50: 500]; % define mantle layer boundaries for inversion (break constraints at boundaries)
param.layers = [100 250 650 2000];

per_max = 112; % [s]

% datafile = ['NoMelt_azi_measurements_RL_5_150s_JGR18_extendedpers_eik_interp.mat'];
% datafile = ['YoungORCA_meas.mat'];
param.is_err2sigma = 1;

is_kernelcalc = 1; % Recalculate kernels after each model iteration?
param.bot = param.layers(end); % Bottom of model space
param.bot_aniso = param.bot; %20; %40  % Bottom of radial anisotropy
param.maxiter = 6; % Number of iterations
param.max_per_love = [6]; %[] % maximum period Love wave to invert
param.is_Qcorr = 0; % correct for phase velocities for physical dispersion?

% Define Discontinuities
% param.discs.sed = 6371 - 6365582/1000;
% param.discs.moho = 6371 - 6359346/1000;

% damping_parameters;
% 
% % ----------- parameters for inversion ----------- 
% param.PROJ = ['NoMelt_',param.CARDID,'_',num2str(param.bot),'km_aniso',num2str(param.bot_aniso),'km_maxiter',num2str(param.maxiter),'_kerncalc',num2str(is_kernelcalc), ...
%     '_d2',num2str(damp_cr_d2),'cr',num2str(damp_man_d2_shal),'man', ...
%     ];
param.maxpert = 100; % (UNUSED) amount we will let layer velocities change (m/s)

% temp = regexp(pwd, '@|\/(?=\w+$)', 'split');
% PROJECT_DIR = temp{end};
% param.PROJ_path = ['./save_mat/',param.PROJ,'.',num2str(param.maxiter),'.',num2str(param.maxpert),'/'];
% param.FIG_path = ['./figs/',param.PROJ,'.',num2str(param.maxiter),'.',num2str(param.maxpert),'/'];

% ----------- Parameters from Phase Velocities ----------- 
param.data = [datafile];
data = load_data(param);
if isvarname('per_max')
    % Keep only periods <= per_max
    flds = fields(data.rayl);
    Ikeep = (data.rayl.periods_iso<=per_max);
    for ii = 1:length(flds)
        fld = flds{ii};
        if isempty(data.rayl.(fld))
            continue
        end
        data.rayl.(fld) = data.rayl.(fld)(Ikeep);
    end
end
% param.LAperiods = [7.5000    6.6667    6.0000    5.4545    5.0000]; %[8.5714    7.5000    6.6667    6.0000    5.4545    5.0000];
% param.RAperiods = [7.5000    6.6667    6.0000    5.4545    5.0000]; %[8.5714    7.5000    6.6667    6.0000    5.4545    5.0000];
if isfield(data,'love')
    param.LAperiods = data.love.periods_iso;
else
    param.LAperiods = [];
end
if isfield(data,'rayl')
    param.RAperiods = data.rayl.periods_iso;
else
    param.RAperiods = [];
end
param.allperiods = []; %[param.RAperiods];

% ----------- Parameters for Running Mineos -----------
param.BINPATH = './MINEOS/FORTRAN/bin/'; %Path to the gfortran MINEOS executables
param.TABLEPATH = [param.Path2runMineos,'/MODE/TABLES/']; %'/Users/naccardo/Unix/MINEOS/MODE_tables/';
param.MODEPATH = [param.Path2runMineos,'/MODE/TABLES/MODE.in/']; %param.INPUTPATH;
param.DATAPATH = [param.TABLEPATH,param.CARDID,'/tables_inv/']; % same as CARDTABLE
CARDTABLE = param.DATAPATH;
if ~exist(CARDTABLE)
    mkdir([param.TABLEPATH,param.CARDID])
    mkdir(CARDTABLE)
end
param.frechetpath = param.DATAPATH;
param.RUNSPATH = [param.TABLEPATH,param.CARDID,'/runs/'];
if ~exist(param.RUNSPATH)
    mkdir(param.RUNSPATH)
end
param.CARDPATH = pwd;
param.CARDPATH = [param.CARDPATH,'/CARDS/'];
param.RUNPATH = pwd;
param.RUNPATH = [param.RUNPATH,'/run/'];

% ----------- Parameters for Mineos Programs ----------- 
% param.eps = 1e-15;
% param.wgrav = 1000;
% param.jcom = 2;
% param.lmin = 0;
% param.lmax = 20000;
% param.nmin = 0;
% param.nmax = 0;
% N_Tmodes = 1; % number of mode branches
% N_Smodes = 2; % number of mode branches
if isfield(data,'love')
    N_Tmodes = length(unique(data.love.mode_br_iso)); % number of mode branches
else
    N_Tmodes = [];
end
if isfield(data,'rayl')
    N_Smodes = length(unique(data.rayl.mode_br_iso)); % number of mode branches
else
    N_Smodes = [];
end
% param.SMODE = 1; % first overtone
% param.TMODE = 0; % fundamental mode
param.ch_modeS = 0; % mode to check? (0 => fundamental);
param.ch_modeT = 0;
param.maxN = 400000; %18000; % max number of modes
param.minF = 0; % min frequency in mHz -- should match file names
minF = param.minF;
param.maxF = 1./min([param.LAperiods, param.RAperiods])*1000+0.05; %200.05; %150.05; % max frequency in mHz
maxF = param.maxF;
param.minL = 0; % min angular order
minL = param.minL;
param.maxL = 50000; %6000; % max angular order
maxL = param.maxL;
param.wmin = param.minF; %0.05; % should match minF and maxF
param.wmax = param.maxF; %151;
param.TID = ['t',num2str(floor(param.minF)),'to',num2str(floor(param.maxF))]; %'t0to150'; % same as param.TTYPEID
param.SID = ['s',num2str(floor(param.minF)),'to',num2str(floor(param.maxF))]; %'s0to150'; % same as param.STYPEID
param.TTYPEID = param.TID;
param.STYPEID = param.SID;
param.SMODEIN = ['s.mode',num2str(floor(param.minF)),'_',num2str(floor(param.maxF)),'_b',num2str(N_Smodes)];
param.TMODEIN = ['t.mode',num2str(floor(param.minF)),'_',num2str(floor(param.maxF)),'_b',num2str(N_Tmodes)];
