% This version allows a fixed number of splines to shift up and down
%

clear;
warning('off','all')
fullMAINpath = mfilename('fullpath');
functionspath = [fullMAINpath(1:regexp(fullMAINpath,mfilename)-1),'functions'];
addpath(functionspath);
addpath('../functions/')

% % Compile the faster mex files for spline calculation
% % !!!!! This only needs to be compiled the first time !!!!!
% cd ./functions
% CompileMexFiles
% cd ..

is_save_mat = 1; % Save results .mat file?
is_overwrite_kernels = 0; % overwrite kernels?

%% JdF
% param.CARDID = 'JdF_Nbs50_chi2thresh3.25';
% param.data = ['./data/JdF_meas.mat'];
% param.is_err2sigma = 1; % are errors in data file 2-sigma?
% PROJ = 'JdF';
% prior_type = 'uniform';

%% Young ORCA
% param.CARDID = 'YoungORCA_Vs_Vp_Rho_lsqr_kernel_bs1000_smLVZdQdz_disc'; %'YoungORCA_Nbs50_chi2thresh3.25';
% param.lsqr_in = './lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap_smLVZdQdz/YoungORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
% param.card_in = './CARDS/YoungORCA_Nbs50_chi2thresh3.25_Qinv.card';
% param.matnameQ_in = './bayesian_mcmc_Qspline_zknot_112s/YoungORCA_uniform_Qmu_bayesian_Nspline12.mat';
% param.data = ['./data/YoungORCA_meas.mat'];
% param.is_err2sigma = 1; % are errors in data file 2-sigma?
% PROJ = 'Young ORCA';
% prior_type = 'uniform';

%% NoMelt
% param.CARDID = 'NoMelt_Vs_Vp_Rho_lsqr_kernel_bs1000_smLVZdQdz_disc'; %'NoMelt_Nbs50_chi2thresh3.25';
% param.lsqr_in = './lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap_smLVZdQdz/NoMelt_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
% param.card_in = './CARDS/NoMelt_Nbs50_chi2thresh3.25_Qinv.card';
% param.matnameQ_in = './bayesian_mcmc_Qspline_zknot_112s/NoMelt_uniform_Qmu_bayesian_Nspline12.mat';
% param.data = ['./data/NoMelt_meas.mat'];
% param.is_err2sigma = 1; % are errors in data file 2-sigma?
% PROJ = 'NoMelt';
% prior_type = 'uniform';

%% Old ORCA
param.CARDID = 'OldORCA_Vs_Vp_Rho_lsqr_kernel_bs1000_smLVZdQdz_disc'; %'OldORCA_Nbs50_chi2thresh3.25';
param.lsqr_in = './lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap_smLVZdQdz/OldORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat';
param.card_in = './CARDS/OldORCA_Nbs50_chi2thresh3.25_Qinv.card';
param.matnameQ_in = './bayesian_mcmc_Qspline_zknot_112s/OldORCA_uniform_Qmu_bayesian_Nspline12.mat';
param.data = ['./data/OldORCA_meas.mat'];
param.is_err2sigma = 1; % are errors in data file 2-sigma?
PROJ = 'Old ORCA';
prior_type = 'uniform';

%% MCMC parameters
% Other inversion parameters
nit_mcmc = 2000000; % total number of iterations
nit_restart = 5000; %1e10; % number of iterations after which to restart with new random model (if never want to restart, set to giant number)
N_cooldown = 100; %50; % number of iterations over which temperature parameter (tau) decays
m_perturb_method = 'single'; %'all'; % 'single' (perturb one model parameter at a time) | 'all' (perturb all at once)
nit_plot = 1e9; %250; % number of iterations after which to plot
N_bestfitting = 500; % consider N best fitting models for confidence intervals
nit_save = 20; % Number of iterations after which to save model output

% Define bounds of allowed model space M relative to ref. model. For the spline
% inversion, this applies to the Vs spline coefficients, not the layers.
% Models occuring outside this space will not be allowed.
% (these values also act as the min and max of the uniform prior)
% If a water layer exists, it is held at fixed velocity/density
% par.dQinv_M = [-0.5 +0.5]; % pct of reference model
par.min_qinv = 1/2000; % minimum allowable Q^-1
par.max_qinv = 1/20; %1/20; %1/25; % maximum allowable Q^-1
par.dqinv_vec = 0.001;

% Define widths of gaussian perturbations made at each iteration
par.dQ_std = 20; %2.5; % units of Q
par.dzknot_std = 10; % km

% Spline parameters
Nspline = 12; % Number of desired splines, evenly spaced from surface (or base of water layer) to zmax
dz_int = 1; % (km) interpolated layer thicknesses
zmax = 800; % Maximum depth of starting model
zmax_sp = 300; % Maximum depth of splines, below which will be a flat layer

errmultfac = 1; %2; % factor to multiply errors by

outname = [strrep(PROJ,' ',''),'_',prior_type,'_Qmu_bayesian'];

%% Read lsqr data structure, write card and qmod file

% Load card structure for updated Vs
temp = load(param.lsqr_in);
lsqrinv = temp.lsqrinv;
card = lsqrinv.card_disc;

% Load card structure for reference Q
z_int = card.z + flip([0:length(card.z)-1]'*1e-10);
card_in = read_model_card3(param.card_in);
card_in_int.z = card.z;
card_in_int.qmu = interp1(card_in.z+flip([0:length(card_in.z)-1]'*1e-10),card_in.qmu,z_int);
card_in_int.qkap = interp1(card_in.z+flip([0:length(card_in.z)-1]'*1e-10),card_in.qkap,z_int);

figure(999); clf;
subplot(1,2,1);
box on; hold on;
plot(1./card_in.qmu,-card_in.z,'-k');
plot(1./card_in_int.qmu,-card_in_int.z,'--r','linewidth',1.5);

% Load Q structure
temp = load(param.matnameQ_in);
bayesian = temp.bayesian;
qmu_inv_med = bayesian.post.qmu_inv_med;
z_q = bayesian.z_int;
Iz = z_int<=max(z_q);
qmu_inv_med_int = interp1(z_q+[0:length(z_q)-1]'*1e-10,qmu_inv_med,z_int(Iz));

plot(qmu_inv_med,-z_q,'-g');
plot(qmu_inv_med_int,-z_int(Iz),'--c','linewidth',1.5);

% Setup output card
card.qkap = card_in_int.qkap;
card.qmu = card_in_int.qmu;
card.qmu(Iz) = 1./qmu_inv_med_int;
% card.qmu(card.qmu>999999) = 999999;
card.qmu(card.vsv==0) = 999999;
card.qkap(card.vsv==0) = 999999;

% Find and remove layers that are too thin
ind_too_thin = find(abs(diff(card.z))>0 & abs(diff(card.z))<0.1);
for ii = 1:length(ind_too_thin)
    flds = fields(card);
    for ifld = 1:length(flds)
        fld = flds{ifld};
        if ~strcmp(fld,'fname')
            card.(fld)(ind_too_thin(ii)) = [];
        end
    end
end

plot(1./card.qmu,-card.z,'--b','linewidth',2);

subplot(1,2,2);
plot(1./card.qkap,-card.z,'--b','linewidth',2);

% Save card and qmod files
write_MINEOS_qmod(card,['./CARDS/',param.CARDID]);


%% Read kernels and load data
fid = fopen('fileinfo.txt','w');
fprintf(fid,'%s\n%s',param.CARDID,param.data);
fclose(fid);
setup_parameters;
runpath = param.RUNPATH;
DATAPATH = param.DATAPATH;
SID = param.SID;

% Load data
data = load_data(param);
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

RAperiods = param.RAperiods;
R = data.rayl;
obs.Ralpha = R.alpha;
obs.Rstdalpha = R.err_alpha;
obs.Rperiods = RAperiods;

Path_kernels_phv = ['./StartingModel_Kernels_Rayl_Q_112s_smLVZdQdz/',param.CARDID,'/'];
% Load kernels
if ~exist(Path_kernels_phv)
    mkdir(Path_kernels_phv);
end
if ~exist([Path_kernels_phv,param.CARDID,'.mat']) || is_overwrite_kernels
    TYPE = 'S';
    frun_mineos_check_TYPE([param.CARDID],1,TYPE);
    [frech_S] = fmk_Qkernels_linear_check_TYPE(param.CARDID,runpath,obs.Rperiods,data.rayl.mode_br_iso,0,TYPE);

    % Grab the estimated phase velocities
    clear SQ SCPER

    TYPE = 'S';
    [SCPER,SQ] = calc_modeQ(obs.Rperiods,TYPE,data.rayl.mode_br_iso,param.CARDID);
    [~,grv,~,~] = readMINEOS_qfile_2([DATAPATH,'/',param.CARDID,'.',param.SID,'.q'],SCPER,data.rayl.mode_br_iso);

    forward.sq = SQ;
    forward.sqinv = 1./SQ;
    forward.sper = SCPER;
    forward.salpha = (2*pi./SCPER) ./ (2.*grv.*SQ);

%             [~, card] = read_forward_model_qfile(cardid,'S',SMODE);
    card = read_model_card2([param.CARDID,'.card']);
    card.qmu = frech_S(1).qmu;
    card.qkap = frech_S(1).qkappa;
    card.qmu_inv = 1./card.qmu;
    card.qkap_inv = 1./card.qkap;

    system(['cp ',DATAPATH,'*.q ',Path_kernels_phv]);
    system(['cp ',DATAPATH,'*.asc ',Path_kernels_phv]);
    save([Path_kernels_phv,param.CARDID,'.mat'],'frech_S','forward','card');
else
    system(['cp ',Path_kernels_phv,'*.q ',DATAPATH]);
    system(['cp ',Path_kernels_phv,'*.asc ',DATAPATH]);
    load([Path_kernels_phv,param.CARDID,'.mat']);
end

%Make sure only necessary frequencies are used
TYPE = 'S';
[frech_S,forward] = organize_Qkernels_TYPE(frech_S,forward,data,TYPE);

% Trim kernels at the bottom of the model space
[frech_S] = trim_kernels_TYPE( frech_S, zmax );
periods = [frech_S(:).per];

% Convert alpha to qinv
[phV,grV,phVq,Q] = readMINEOS_qfile_2([DATAPATH,'/',param.CARDID,'.',param.SID,'.q'],param.RAperiods,data.rayl.mode_br_iso);
obs.Rqinv = obs.Ralpha*2.*grV ./ (2*pi./obs.Rperiods);
obs.Rstdqinv = obs.Rstdalpha*2.*grV ./ (2*pi./obs.Rperiods);
obs.Rstdqinv = obs.Rstdqinv * errmultfac;

%% Setup G matrix for quick calculation
z = frech_S(1).z;
z_int = [min(z):dz_int:max(z)]';
zh2o = max(card.z(card.vpv==1500));
if ~isempty(zh2o)
    z_int = sort([z_int; zh2o]);
end
% dr = [0;diff(rad)*-1]*1000; % km -> m
dr = gradient(z_int)*1000; % km -> m

% Sensitivities from Rayleigh
GG = zeros(length(frech_S),length(z_int)*2); % Qmu, Qkap
for ip = 1:length(frech_S)
    K_qmu = interp1(flip(z)+[0:length(z)-1]'*1e-10,flip(frech_S(ip).K_qmu),z_int);
    inan = find(isnan(K_qmu));
    K_qmu(inan) = K_qmu(inan+1);
    GG(ip,1:length(z_int)) = K_qmu .* dr;
    
    K_qkappa = interp1(flip(z)+[0:length(z)-1]'*1e-10,flip(frech_S(ip).K_qkappa),z_int);
    inan = find(isnan(K_qkappa));
    K_qkappa(inan) = K_qkappa(inan+1);
    GG(ip,length(z_int)*1+1:length(z_int)*2) = K_qkappa .* dr;   
end

qkap = interp1(flip(card.z)+[0:length(card.z)-1]'*1e-10,flip(card.qkap),z_int);
inan = find(isnan(qkap));
qkap(inan) = qkap(inan+1);
qkap_inv = 1./qkap;
qmu_ref = interp1(flip(card.z)+[0:length(card.z)-1]'*1e-10,flip(card.qmu),z_int);
qmu_inv_ref = 1./qmu_ref;

vpv = interp1(flip(card.z)+[0:length(card.z)-1]'*1e-10,flip(card.vpv),z_int);

%% Do initial spline calculation

% Define spline knots
% zsp = [zh2o:50:zmax];
% zsp = [linspace(zh2o,70,5-1) linspace(70,zmax,6-1)]; % example of custom spline spacing with a discontinuity
% zsp = linspace(zh2o,zmax,Nspline-1);
zsp = [linspace(zh2o,zmax_sp,Nspline-1)];
% zsp = [zh2o 20:20:200 zmax_sp];

Inoh2o = find(vpv~=1500);
Ih2o = find(vpv==1500);
[spbasis,spcoeffs,spzz]=make_splines(zsp(:),[],z_int(Inoh2o),qmu_inv_ref(Inoh2o));
% spcoeffs(spcoeffs<0) = par.min_qinv;
qmu_inv_ref_sp = spbasis * spcoeffs;
qmu_inv_ref_sp = [qmu_inv_ref(Ih2o); qmu_inv_ref_sp];


figure(1000); clf;
set(gcf,'position',[370   372   967   580]);
subplot(2,2,[1 3]); box on; hold on;
plot(qmu_inv_ref,z_int,'-k','linewidth',2)
plot(qmu_inv_ref_sp,z_int,'--b','linewidth',1.5);
plot(spbasis'*0.005,z_int(Inoh2o));
plot(zeros(size(zsp)),zsp,'ok');
xlabel('Q_{\mu}^{-1}');
ylabel('Depth');
set(gca,'FontSize',18,'linewidth',1.5,'ydir','reverse');
pos = get(gca,'Position');
legend({'Ref (layers)','Ref (spline)','basis fxns'},'Location','southeastoutside')
set(gca,'position',pos);

subplot(2,2,2); box on; hold on;
[~,~,~,q_ref_mines] = readMINEOS_qfile_2([DATAPATH,'/',param.CARDID,'.',param.SID,'.q'],periods,data.rayl.mode_br_iso);
qinv_ref_mineos = 1./q_ref_mines;
qinv_ref = GG * [qmu_inv_ref(:); qkap_inv(:)]; % predicted phase velocity
qinv_ref_sp = GG * [qmu_inv_ref_sp(:); qkap_inv(:)]; % predicted phase velocity
plot(periods,qinv_ref_mineos,'s-b','linewidth',3);
plot(periods,qinv_ref,'-og','linewidth',2);
plot(periods,qinv_ref_sp,'--or','linewidth',2);
legend({'mineos','kernel (layers)','kernel (spline)'},'Location','southeast')
xlabel('Period');
ylabel('Q^{-1}');
set(gca,'FontSize',18,'linewidth',1.5);

%% Define priors for each layer
% Define edges of the model space M
Ncoeffs = length(spcoeffs);
model_bounds = nan(length(spcoeffs),2);
% for ic = 1:Ncoeffs
%     model_bounds(ic,1) = spcoeffs(ic)*(1+par.dQinv_M(1));
%     model_bounds(ic,2) = spcoeffs(ic)*(1+par.dQinv_M(2));
% end
for ic = 1:Ncoeffs
    model_bounds(ic,1) = par.min_qinv;
    model_bounds(ic,2) = par.max_qinv;
end

% Uniform priors spanning M
priors.sample = @(N,ic) unifrnd(model_bounds(ic,1), model_bounds(ic,2) ,N,1);

% Function to perturb model
% perturb_model = @(model,std_vec) normrnd(model(:)',std_vec)';
perturb_model = @(model,std_vec) 1./normrnd(1./model(:)',std_vec)';
perturb_zknot = @(model,std_vec) normrnd(model(:)',std_vec)';

% Get pdf from distributions
qinv_edges = [par.min_qinv : par.dqinv_vec : par.max_qinv]; %1/2000:0.00025:0.035;
qinv_vec = 0.5*(qinv_edges(1:end-1)+qinv_edges(2:end));
figure(1000);
for ic = 1:Ncoeffs
    h = histogram(priors.sample(1000000,ic),qinv_edges,'Normalization','probability');
    priors.pdf_sp{ic} = h.Values;
end
priors.qinv_vec = qinv_vec;

figure(999); clf;
for ic = 1:Ncoeffs
    plot(priors.qinv_vec,priors.pdf_sp{ic}); hold on;
end
title('Priors on Coefficients');
ylim([0 max([priors.pdf_sp{:}])]);

% Project priors to layer space using spline basis
pdf_mat_sp = [];
for ic = 1:Ncoeffs
    pdf_mat_sp(ic,:) = priors.pdf_sp{ic};
end
pdf_mat = spbasis*pdf_mat_sp;
for ilay = 1:size(pdf_mat,1)
    priors.pdf{ilay} = pdf_mat(ilay,:);
end
figure(11); clf;
plot(priors.qinv_vec,pdf_mat')
title('Priors on Layers');
ylim([0 max([priors.pdf{:}])]);

%% Do MCMC
Nmodels = ceil(nit_mcmc / nit_save);
qmu_inv_mat = nan(length(z_int),Nmodels);
qmu_inv_mat_sp = nan(Ncoeffs,Nmodels);
zsp_mat = nan(Nspline-1,Nmodels);
qinv_pre_mat = nan(length(periods),Nmodels);
chi2_mat = nan(1,Nmodels);
% L_mat = zeros(length(periods),Ngs);
misfit = nan(1,Nmodels);
Likelihood = nan(1,Nmodels);
posterior = nan(length(z_int),Nmodels);
posterior_sp = nan(Ncoeffs,Nmodels);
disc_pdf = nan(size(z_int));

% Initiate
m_j(:,1) = sample_model(priors.sample,1,Ncoeffs);
spbasis_j = spbasis;
zsp_j = zsp;
% m_j(m_j<0) = par.min_qinv;
ii = 0;
ibad = 0;
icooldown = 0;
ii_save = 0;
tic
while ii < nit_mcmc
    if ii>0 && mod(ii,nit_restart) == 0 % reinitialize mcmc, start over
        m_j(:,1) = sample_model(priors.sample,1,Ncoeffs);
%         m_j(m_j<0) = par.min_qinv;
        icooldown = 0;
    end
    
    % Previous model
    Inoh2o = find(vpv~=1500);
    Ih2o = find(vpv==1500);
%     [spbasis,spcoeffs,spzz]=make_splines(zsp(:),[],z_int(Inoh2o),qmu_inv_ref(Inoh2o));
%     spcoeffs(spcoeffs<0) = par.min_qinv;
    qmu_inv_splinemod_j = spbasis_j * m_j(:);
%     qmu_inv_splinemod_j(qmu_inv_splinemod_j<0) = par.min_qinv;
    qmu_inv_splinemod_j = [qmu_inv_ref(Ih2o); qmu_inv_splinemod_j];
    qinv_j = GG * [qmu_inv_splinemod_j(:); qkap_inv(:)]; % predicted qinv
    if length(qinv_j) ~= length(periods) % check if something is wrong...
        ibad = ibad+1;
        m_j(:,1) = sample_model(priors.sample,1,Ncoeffs);
%         m_j(m_j<0) = par.min_qinv;
        continue
    end

    % calculate chi^2 misfit
    qinv_obs = obs.Rqinv;
    qinv_std = obs.Rstdqinv;
    chi_2_j = sum((qinv_obs(:)-qinv_j(:)).^2./qinv_std(:).^2)/length(periods);
    
    % Likelihood P(Qinv | Qmu_inv)
    chi_2_unnorm_j = sum((qinv_obs(:)-qinv_j(:)).^2./qinv_std(:).^2);
    L_j = ((2 * pi)^(length(periods)) * prod(qinv_std(:).^2)).^(-0.5) .* exp(-0.5 * chi_2_unnorm_j(:));
%     L_j = exp(-0.5 * S_j); % likelihood
    
    % Ensure that model is within model space M
    is_in_bounds = is_model_in_bounds(m_j(:,1),model_bounds);
    
    % If model is really bad, try a new one
    if isinf(1./L_j) || isnan(L_j) || ~is_in_bounds
        ibad = ibad+1;
        
        m_j(:,1) = sample_model(priors.sample,1,Ncoeffs);
%         m_j(m_j<0) = par.min_qinv;
        dzknot = perturb_zknot(zsp,repmat(par.dzknot_std,1,length(zsp)));
        dzknot(dzknot<zh2o) = zh2o;
        dzknot(dzknot>zmax_sp) = zmax_sp;
        dzknot(1) = zh2o;
        dzknot(end) = zmax_sp;
        zsp_j = sort(dzknot);
        Inoh2o = find(vpv~=1500);
        Ih2o = find(vpv==1500);
        [spbasis_j,~,~]=make_splines(zsp_j(:),[],z_int(Inoh2o),qmu_inv_splinemod_j(Inoh2o));
            
        display(['Searching for stable starting model: ',num2str(ibad)]);
        
        if 0
            figure(9999); clf;
            set(gcf,'position',[370   372   967   580]);
            subplot(2,2,[1 3]); box on; hold on;
            plot(qmu_inv_ref,z_int,'-k','linewidth',2)
            plot(qmu_inv_ref_sp,z_int,'--b','linewidth',1.5);
            plot(spbasis_j'*0.005,z_int(Inoh2o));
            xlabel('Q_{\mu}^{-1}');
            ylabel('Depth');
            set(gca,'FontSize',18,'linewidth',1.5,'ydir','reverse');
            pos = get(gca,'Position');
            legend({'Ref (layers)','Ref (spline)','basis fxns'},'Location','southeastoutside')
            set(gca,'position',pos);

            subplot(2,2,2); box on; hold on;
            [~,~,~,q_ref_mines] = readMINEOS_qfile_2([DATAPATH,'/',param.CARDID,'.',param.SID,'.q'],periods,data.rayl.mode_br_iso);
            qinv_ref_mineos = 1./q_ref_mines;
            qinv_ref = GG * [qmu_inv_ref(:); qkap_inv(:)]; % predicted phase velocity
            qinv_ref_sp = GG * [qmu_inv_ref_sp(:); qkap_inv(:)]; % predicted phase velocity
            plot(periods,qinv_ref_mineos,'s-b','linewidth',3);
            plot(periods,qinv_ref,'-og','linewidth',2);
            plot(periods,qinv_ref_sp,'--or','linewidth',2);
            legend({'mineos','kernel (layers)','kernel (spline)'},'Location','southeast')
            xlabel('Period');
            ylabel('Q^{-1}');
            set(gca,'FontSize',18,'linewidth',1.5);
        end
        
        continue
    end
    ii = ii + 1;
    
    if mod(ii,100) == 0
        display([num2str(ii),'/',num2str(nit_mcmc)]);
    end
    
    % Store output
    if ii>0 && mod(ii,nit_save) == 0
        ii_save = ii_save + 1;
        
        % Calculate posterior probability of model j (spline coefficients)
        for ic = 1:Ncoeffs
            [~,I] = min(abs(m_j(ic,1)-priors.qinv_vec));
            posterior_sp(ic,ii_save) = L_j .* priors.pdf_sp{ic}(I);
        end
        % Calculate posterior for layered structure
        ipdf = 0;
        for ilay = 1:size(posterior,1)
            if vpv(ilay)==1500 % water layer
                posterior(ilay,ii_save) = L_j * 1;
                continue
            end
            ipdf = ipdf + 1;
            [~,I] = min(abs(qmu_inv_splinemod_j(ilay)-priors.qinv_vec));
            posterior(ilay,ii_save) = L_j .* priors.pdf{ipdf}(I);
        end
    %     posterior(:,ii) = L_j;
   
        qmu_inv_mat(:,ii_save) = qmu_inv_splinemod_j;
        qmu_inv_mat_sp(:,ii_save) = m_j;
        zsp_mat(:,ii_save) = zsp_j;
        qinv_pre_mat(:,ii_save) = qinv_j;
        chi2_mat(ii_save) = chi_2_j;
        misfit(ii_save) = chi_2_unnorm_j;
        Likelihood(ii_save) = L_j;
    end
    
%     % Sum discontinuity pdf
% %     i_disc = zeros(size(z_int));
%     ind = (z_int<=ZDISC(ii)+dz/2 & z_int>ZDISC(ii)-dz/2) | (z_int<=ZDISC2(ii)+dz/2 & z_int>ZDISC2(ii)-dz/2);
% %     i_disc(ind) = 1;
%     disc_pdf(ind) = disc_pdf(ind) + Post_vec(ii);
    
    
    % Decaying thermal parameter (cool down parameter) from simulated 
    % annealing (Kirkpatrick et al. 1983). This allows larger changes 
    % between sequential models at early iterations. This premultiplies the
    % Gaussian distributions from which random model parameters are drawn
    % and also the likelihood of the trial model, so misfit increases are
    % more likely accepted early in the MCMC.
%     tau = 1 + 3 * erfc(ii/500); % denom = 500 means decays over ~1500 iterations (Eilon et al. 2018)
    tau = 1 + 3 * erfc(icooldown/(N_cooldown/3)); % denom = 500 means decays over ~1500 iterations
    
    % Trial model
    is_in_bounds = 0;
    % Get index for type of perturbation to perform
    I_perturbation_type = ceil(rand(1)*2);
    icnt = 0; is_restart = 0;
    while is_in_bounds == 0
        icnt = icnt + 1;
        m_i = m_j;
        zsp_i = zsp_j;
        spbasis_i = spbasis_j;
        
        if I_perturbation_type == 1 % PERTURB VALUE OF COEFFICIENT
            dqinv = perturb_model(m_i(:,1),tau*repmat(par.dQ_std,1,Ncoeffs)); % perturb Qinv
%             dqinv(dqinv<0) = par.min_qinv;
%             dqinv = sample_model(priors.sample,1,Ncoeffs);; % random Vs
            switch m_perturb_method
                case 'single'
                    I_pert = ceil(rand(1)*Ncoeffs); % randomly pick model parameter to perturb
                    m_i(I_pert,1) = dqinv(I_pert);
                case 'all'
                    m_i(:,1) = dqinv; % perturb all model parameters at once
                otherwise
                    error('m_perturb_method not a valid choice. must be ''single'' or ''all'' ');
            end
        elseif I_perturbation_type == 2 % PERTURB DEPTH OF KNOT
            dzknot = perturb_zknot(zsp_i,tau*repmat(par.dzknot_std,1,length(zsp_i)));
%             dzknot(dzknot<zh2o) = zh2o;
%             dzknot(dzknot>zmax_sp) = zmax_sp;
            switch m_perturb_method
                case 'single'
                    I_pert = randi([2,length(zsp_i)-1]); % randomly pick knot index (but avoid top and bottom knots)
                    if dzknot(I_pert)<zh2o || dzknot(I_pert)>zmax_sp
                        is_in_bounds = 0;
                        continue
                    end
                    zsp_i(I_pert) = dzknot(I_pert);
                case 'all'
                    if ~isempty(dzknot(dzknot<zh2o)) || ~isempty(dzknot(dzknot>zmax_sp))
                        is_in_bounds = 0;
                        continue
                    end
                    zsp_i = dzknot; % perturb all knots at once
                otherwise
                    error('m_perturb_method not a valid choice. must be ''single'' or ''all'' ');
            end
            zsp_i = sort(zsp_i);
            Inoh2o = find(vpv~=1500);
            Ih2o = find(vpv==1500);
            [spbasis_i,m_i,spzz]=make_splines(zsp_i(:),[],z_int(Inoh2o),qmu_inv_splinemod_j(Inoh2o));
        end
        Ncoeffs_i = length(m_i);
        model_bounds = nan(length(m_i),2);
        for ic = 1:Ncoeffs_i
            model_bounds(ic,1) = par.min_qinv;
            model_bounds(ic,2) = par.max_qinv;
        end
        is_in_bounds = is_model_in_bounds(m_i,model_bounds);
        if icnt > 1e6
            is_restart = 1;
            break
        end
    end
    if is_restart
        continue
    end
    Inoh2o = find(vpv~=1500);
    Ih2o = find(vpv==1500);
%     [spbasis,spcoeffs,spzz]=make_splines(zsp(:),[],z_int(Inoh2o),qmu_inv_ref(Inoh2o));
    qmu_inv_splinemod_i = spbasis_i * m_i(:);
%     qmu_inv_splinemod_i(qmu_inv_splinemod_i<0) = par.min_qinv;
    qmu_inv_splinemod_i = [qmu_inv_ref(Ih2o); qmu_inv_splinemod_i];
    qinv_i = GG * [qmu_inv_splinemod_i(:); qkap_inv(:)]; % predicted qinv
    if length(qinv_i) ~= length(periods) % check if something is wrong...
        % Skip
        continue
    end
    % Likelihood P(Qinv | Qmu_inv)
    chi_2_unnorm_i = sum((qinv_obs(:)-qinv_i(:)).^2./qinv_std(:).^2);
    L_i = ((2 * pi)^(length(periods)) * prod(qinv_std(:).^2)).^(-0.5) .* exp(-0.5 * chi_2_unnorm_i(:));
%     L_i = exp(-0.5 * S_i); % likelihood
    L_i = tau * L_i;
    
    % Plot
    if mod(ii,nit_plot) == 0
        figure(2); clf;
        subplot(2,2,1); box on; hold on;
        yyaxis left
        plot(1:ii_save,misfit(1:ii_save) / length(periods),'o'); hold on;
        ylabel('Misfit');        
        yyaxis right
        plot(1:ii_save,log10(Likelihood(1:ii_save)),'o'); hold on;
        ylabel('log_{10}(Likelihood)');
        
        subplot(2,2,[2 4]); box on; hold on;
        for kk = 1:ii_save
            plot(qmu_inv_mat(:,kk),z_int,'-r');
        end
        plot(qmu_inv_ref,z_int,'-b','linewidth',2);
        xlabel('Q_{\mu}^{-1}');
        ylabel('Depth (km)');
        set(gca,'FontSize',16,'linewidth',1.5,'ydir','reverse');
%         legend({'start','ensemble'},'Location','southwest')

        subplot(2,2,3); box on; hold on;
        plot(periods,qinv_pre_mat(:,1:ii_save),'-or','linewidth',1);
        errorbar(periods,qinv_obs,2*qinv_std,'sk','markersize',8,'markerfacecolor','k','linewidth',2);
        plot(periods,qinv_ref_mineos,'-ob','linewidth',2);
        xlabel('Period');
        ylabel('Q^{-1}');
        set(gca,'FontSize',16,'linewidth',1.5);
        drawnow;
    end
    
    % Metropolis-Hastings acceptance criterion
    p_accept = min(L_i/L_j, 1);
    if rand <= p_accept % (rand always between [0 1])
        % Accept new model i
        m_j = m_i;
        spbasis_j = spbasis_i;
        zsp_j = zsp_i;
    else
        % Reject new model i
        continue
    end
    
    %%
    
    if 0
        if ii == 1
            figure(1); clf;
        end
        subplot(2,2,[1 3]);
        plot(qmu_inv_ref,z_int,'-k','linewidth',2); hold on;
        plot(qmu_inv,z_int,'-','linewidth',1.5); hold on;
        set(gca,'ydir','reverse');

        subplot(2,2,2);
        errorbar(obs.Rperiods,obs.Rqinv,obs.Rstdqinv,'-ok','linewidth',2); hold on;
        plot(periods,qinv_pre,'-','linewidth',1.5);
        
        subplot(2,2,4);
        plot(ii,chi_2,'o','linewidth',2); hold on;

        pause;
    end
%     profile viewer
end

%% Calculate marginal pdfs
qinv_edges = [0 : par.dqinv_vec : par.max_qinv]; %1/2000:0.00025:0.035;
qinv_vec = 0.5*(qinv_edges(1:end-1)+qinv_edges(2:end));
[qinvgrid,zgrid] = meshgrid(qinv_vec,z_int);
marginal_pdf = zeros(size(z_int,1),length(qinv_vec));
marginal_pdf_sp = zeros(Ncoeffs,length(qinv_vec));

% Marginal for spline coefficients
for idim = 1:Ncoeffs
    ind_bin = discretize(qmu_inv_mat_sp(idim,:),qinv_edges);
    marginal = zeros(size(qinv_vec));
    for ii = 1:length(ind_bin)
        if isnan(ind_bin(ii))
            continue
        end
        marginal(ind_bin(ii)) = marginal(ind_bin(ii)) + sum(posterior_sp(:,ii));
    end
    marginal_pdf_sp(idim,:) = marginal / sum(marginal); % normalize so sums to 1
end

% % Expand with basis function
% for ii = 1:size(marginal_pdf_sp,2)
%     marginal_pdf(2:end,ii) = spbasis * marginal_pdf_sp(:,ii);
% end

% Marginal for depth model
for idim = 1:size(qmu_inv_mat,1)
    ind_bin = discretize(qmu_inv_mat(idim,:),qinv_edges);
    marginal = zeros(size(qinv_vec));
    for ii = 1:length(ind_bin)
        if isnan(ind_bin(ii))
            continue
        end
        marginal(ind_bin(ii)) = marginal(ind_bin(ii)) + sum(posterior(:,ii));
    end
    marginal_pdf(idim,:) = marginal / sum(marginal); % normalize so sums to 1
end

% Sum q_inv pdf
% qinv_v = 0:0.0005:max(qinv_pre_mat(:))+0.0005;
qinv_v = qinv_edges; %linspace(par.min_qinv,par.max_qinv,150);
[periods_v, isrt] = sort(periods);
posterior_full = squeeze(repmat(posterior(1,:),1,1,length(periods)))';
% periods_full_srt = repmat(periods_v(:),1,size(posterior_full,1),size(posterior_full,2));
% periods_full_srt = reshape(periods_full_srt,size(posterior_full));
periods_full_srt = repmat(periods_v(:),1,length(posterior_full));
qinv_pre_mat_srt = qinv_pre_mat(isrt,:);
[qinv_pdf edges mid loc] = histcn([qinv_pre_mat_srt(:) periods_full_srt(:)], sort(qinv_v), sort(periods_v), 'AccumData', posterior_full(:), 'Fun', @sum);
qinv_pdf = qinv_pdf ./ sum(qinv_pdf,1);
% [periods_grid,qinv_grid] = meshgrid(periods_v,qinv_v(2:end));
% [periods_grid,qinv_grid] = meshgrid(periods_v,qinv_v(1:end-1));
[periods_grid,qinv_grid] = meshgrid(periods_v,mid{1});

% Confidence Fields
qmu_inv_conf_mat = nan(size(marginal_pdf));
for ilay = 1:size(marginal_pdf,1)
    qmu_inv_conf_mat(ilay,:) = confidence_field(marginal_pdf(ilay,:));
end

qinv_conf_mat = nan(size(qinv_pdf));
for ip = 1:size(qinv_pdf,2)
    qinv_conf_mat(:,ip) = confidence_field(qinv_pdf(:,ip));
end

% Marginal for depth of spline knots
z_int_edges = [0:10:zmax];
z_int_vec = 0.5*(z_int_edges(1:end-1)+z_int_edges(2:end));
marginal_pdf_zsp = zeros(size(zsp_mat,1),length(z_int_vec));
for idim = 1:size(zsp_mat,1)
    ind_bin = discretize(zsp_mat(idim,:),z_int_edges);
    marginal = zeros(size(z_int_vec));
    for ii = 1:length(ind_bin)
        if isnan(ind_bin(ii))
            continue
        end
        marginal(ind_bin(ii)) = marginal(ind_bin(ii)) + sum(posterior_sp(:,ii));
    end
    marginal_pdf_zsp(idim,:) = marginal / sum(marginal); % normalize so sums to 1
end

%% Gather information

bayesian.PROJ = PROJ;
bayesian.params.N_bestfitting = N_bestfitting;
bayesian.params.zmax = zmax;
bayesian.params.zmax_sp = zmax_sp;
bayesian.params.par = par;
bayesian.params.param = param;
bayesian.zh2o = zh2o;

bayesian.qmu_inv_mat = qmu_inv_mat;
bayesian.qmu_inv_mat_sp = qmu_inv_mat_sp;
bayesian.zsp_mat = zsp_mat;

bayesian.priors = priors;
bayesian.zsp = zsp;

bayesian.post.Post_mat = posterior;
bayesian.post.Post_mat_sp = posterior_sp;
bayesian.post.qmu_inv_pdf = marginal_pdf;
bayesian.post.qmu_inv_pdf_sp = marginal_pdf_sp;
bayesian.post.zsp_pdf = marginal_pdf_zsp;
bayesian.post.qmu_inv_conf_mat = qmu_inv_conf_mat;
bayesian.post.qinv_pdf = qinv_pdf;
bayesian.post.qinv_conf_mat = qinv_conf_mat;
% bayesian.post.disc_pdf = disc_pdf;
bayesian.qinvgrid = qinvgrid;
bayesian.qinv_vec = qinv_vec;
bayesian.z_int_vec = z_int_vec;
bayesian.zgrid = zgrid;
bayesian.z_int = z_int;
bayesian.qinv_pre_mat = qinv_pre_mat;

bayesian.periods = periods;
bayesian.periods_grid = periods_grid;
bayesian.qinv_grid = qinv_grid;
bayesian.obs = obs;
bayesian.data = data;

bayesian.GG = GG;
bayesian.frech_S = frech_S;
bayesian.qkap_inv = qkap_inv;

bayesian.Likelihood = Likelihood;
bayesian.chi2_mat = chi2_mat;
% bayesian.qmu_inv_mat = qmu_inv_mat;
[chi2_mat_srt, isrt] = sort(bayesian.chi2_mat);
igood = sort(isrt(1:bayesian.params.N_bestfitting));
bayesian.qmu_inv_mat_good = qmu_inv_mat(:,igood);
bayesian.qinv_pre_mat_good = bayesian.qinv_pre_mat(:,igood);
[~,imin] = min(bayesian.chi2_mat);
bayesian.qmu_inv_mat_best = qmu_inv_mat(:,imin);
bayesian.qinv_pre_mat_best = bayesian.qinv_pre_mat(:,imin);
bayesian.qkap_inv = qkap_inv;

% Posterior probabilities (histograms)
w = sum(posterior,1);
bayesian.post.qmu_inv_mean = sum(w.*bayesian.qmu_inv_mat,2)./sum(w);
% bayesian.post.qmu_inv_mean = sum(bayesian.post.qmu_inv_pdf.*qinvgrid,2);
bayesian.post.qinv_mean_pre = GG * [bayesian.post.qmu_inv_mean(:); qkap_inv(:)];
bayesian.post.zsp_mean = sum(w.*bayesian.zsp_mat,2)./sum(w);
% Median
bayesian.post.qmu_inv_med = pdf_prctile(bayesian.post.qmu_inv_pdf,bayesian.qinv_vec+par.dqinv_vec/2,50);
bayesian.post.qmu_inv_med(isnan(bayesian.post.qmu_inv_med)) = bayesian.post.qmu_inv_mean(isnan(bayesian.post.qmu_inv_med));
bayesian.post.qmu_inv_l95 = pdf_prctile(bayesian.post.qmu_inv_pdf,bayesian.qinv_vec+par.dqinv_vec/2,2.5);
bayesian.post.qmu_inv_l95(isnan(bayesian.post.qmu_inv_l95)) = bayesian.post.qmu_inv_mean(isnan(bayesian.post.qmu_inv_l95));
bayesian.post.qmu_inv_u95 = pdf_prctile(bayesian.post.qmu_inv_pdf,bayesian.qinv_vec+par.dqinv_vec/2,97.5);
bayesian.post.qmu_inv_u95(isnan(bayesian.post.qmu_inv_u95)) = bayesian.post.qmu_inv_mean(isnan(bayesian.post.qmu_inv_u95));
bayesian.post.qmu_inv_l68 = pdf_prctile(bayesian.post.qmu_inv_pdf,bayesian.qinv_vec+par.dqinv_vec/2,16);
bayesian.post.qmu_inv_l68(isnan(bayesian.post.qmu_inv_l68)) = bayesian.post.qmu_inv_mean(isnan(bayesian.post.qmu_inv_l68));
bayesian.post.qmu_inv_u68 = pdf_prctile(bayesian.post.qmu_inv_pdf,bayesian.qinv_vec+par.dqinv_vec/2,84);
bayesian.post.qmu_inv_u68(isnan(bayesian.post.qmu_inv_u68)) = bayesian.post.qmu_inv_mean(isnan(bayesian.post.qmu_inv_u68));
bayesian.post.qinv_med_pre = GG * [bayesian.post.qmu_inv_med(:); qkap_inv(:)];
% bayesian.post.qinv_l95_pre = GG * [bayesian.post.qmu_inv_l95(:); qkap_inv(:)];
% bayesian.post.qinv_u95_pre = GG * [bayesian.post.qmu_inv_u95(:); qkap_inv(:)];
% bayesian.post.qinv_l68_pre = GG * [bayesian.post.qmu_inv_l68(:); qkap_inv(:)];
% bayesian.post.qinv_u68_pre = GG * [bayesian.post.qmu_inv_u68(:); qkap_inv(:)];
bayesian.post.qinv_l95_pre = flip(pdf_prctile(bayesian.post.qinv_pdf',bayesian.qinv_vec+par.dqinv_vec/2,2.5));
bayesian.post.qinv_u95_pre = flip(pdf_prctile(bayesian.post.qinv_pdf',bayesian.qinv_vec+par.dqinv_vec/2,97.5));
bayesian.post.qinv_l68_pre = flip(pdf_prctile(bayesian.post.qinv_pdf',bayesian.qinv_vec+par.dqinv_vec/2,16));
bayesian.post.qinv_u68_pre = flip(pdf_prctile(bayesian.post.qinv_pdf',bayesian.qinv_vec+par.dqinv_vec/2,84));

bayesian.nit_save = nit_save;

if is_save_mat
    if ~exist('./bayesian_mcmc_Qspline_zknot_112s_smLVZdQdz/')
        mkdir('./bayesian_mcmc_Qspline_zknot_112s_smLVZdQdz/');
    end
    outmat = ['./bayesian_mcmc_Qspline_zknot_112s_smLVZdQdz/',outname,'_Nspline',num2str(Nspline),'.mat'];
    save(outmat,'bayesian');
   
end

%% Plot misfit/likelihood evolution
figure(888); clf;
subplot(2,1,1);
plot([1:Nmodels] * bayesian.nit_save,misfit / length(periods),'o'); hold on;
xlabel('Model #');
ylabel('Misfit');

subplot(2,1,2);
plot([1:Nmodels] * bayesian.nit_save,log10(Likelihood),'o'); hold on;
xlabel('Model #');
ylabel('log_{10}(Likelihood)');

%% Histograms

figure(1001); clf;
for ic = 1:Ncoeffs
    
    subplot(ceil(sqrt(Ncoeffs)),ceil(sqrt(Ncoeffs)),ic);
    plot(priors.qinv_vec,priors.pdf_sp{ic},'-k','linewidth',2); hold on;
    plot(qinv_vec,bayesian.post.qmu_inv_pdf_sp(ic,:),'-r','linewidth',1.5); hold on;
%     ylims = get(gca,'YLim');
%     plot(spcoeffs_true(ic)*[1 1],ylims,'--g','linewidth',1.5);
    title(['Coefficient ',num2str(ic)]);
    xlim([min(qinv_edges) max(qinv_edges)]);
    
end

%%

[~,imin] = min(bayesian.chi2_mat);
i25pct = find(bayesian.chi2_mat <= prctile(bayesian.chi2_mat,1));
% igood = find(chi2_mat < chi_2_thresh);
[chi2_mat_srt, isrt] = sort(bayesian.chi2_mat);
igood = sort(isrt(1:bayesian.params.N_bestfitting));

figure(2); clf;
set(gcf,'Position',[189   507   689   518],'color','w')
sgtitle(bayesian.PROJ,'fontweight','bold','fontsize',20);

subplot(2,2,[1 3]); box on; 
% plot(qmu_inv_mat(:,i25pct),z_int,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
plot(bayesian.qmu_inv_mat_good,bayesian.z_int,'-','color',[0.75 0.75 0.75],'linewidth',3); hold on;
% plot(qmu_inv_ref,z_int,'-k','linewidth',3); hold on;
plot(1./bayesian.frech_S(1).qmu,bayesian.frech_S(1).z,'-k','linewidth',3); hold on;
plot(bayesian.qmu_inv_mat_best,bayesian.z_int,'-r','linewidth',3); hold on;
xlabel('Q_{\mu}^{-1}');
ylabel('Depth (km)');
set(gca,'ydir','reverse');
set(gca,'fontsize',15,'linewidth',1.5);

subplot(2,2,2); box on;
% plot(periods,qinv_pre_mat(:,i25pct),'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
plot(bayesian.periods,bayesian.qinv_pre_mat_good,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
errorbar(bayesian.obs.Rperiods,bayesian.obs.Rqinv,bayesian.obs.Rstdqinv,'-ok','linewidth',2); hold on;
plot(bayesian.periods,bayesian.qinv_pre_mat_best,'-r','linewidth',3);
xlabel('Period (s)');
ylabel('Q^{-1}');
set(gca,'fontsize',15,'linewidth',1.5);

subplot(2,2,4); box on;
% histogram(chi2_mat(i25pct),'linewidth',2); hold on;
histogram(bayesian.chi2_mat(igood),'linewidth',2); hold on;
xlabel('\chi^2')
set(gca,'fontsize',15,'linewidth',1.5);

%% Confidence intervals

alph = 0.25;
clr = [0 0 1];
figure(3); clf;
set(gcf,'Position',[189   507   689   518],'color','w')
sgtitle(bayesian.PROJ,'fontweight','bold','fontsize',20);

subplot(2,2,[1 3]); box on; hold on;
qmu_inv_l95 = prctile(bayesian.qmu_inv_mat_good,5,2);
qmu_inv_u95 = prctile(bayesian.qmu_inv_mat_good,95,2);
qmu_inv_med = prctile(bayesian.qmu_inv_mat_good,50,2);
% plot(qmu_inv_mat(:,i25pct),z_int,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
plot_shaded(qmu_inv_l95,qmu_inv_u95,bayesian.z_int,'x',clr, alph); hold on;
% plot(qmu_inv_mat(:,igood),z_int,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
% plot(qmu_inv_ref,z_int,'-k','linewidth',2); hold on;
plot(1./bayesian.frech_S(1).qmu,bayesian.frech_S(1).z,'-k','linewidth',3); hold on;
plot(qmu_inv_med,bayesian.z_int,'-','color',clr,'linewidth',3); hold on;
plot(bayesian.qmu_inv_mat_best,bayesian.z_int,'-r','linewidth',3); hold on;
xlabel('Q_{\mu}^{-1}');
ylabel('Depth (km)');
set(gca,'ydir','reverse');
set(gca,'fontsize',15,'linewidth',1.5);

subplot(2,2,2); box on;
qinv_pre_l95 = prctile(bayesian.qinv_pre_mat_good,5,2);
qinv_pre_u95 = prctile(bayesian.qinv_pre_mat_good,95,2);
qinv_pre_med = prctile(bayesian.qinv_pre_mat_good,50,2);
% plot(periods,qinv_pre_mat(:,i25pct),'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
plot_shaded(qinv_pre_l95,qinv_pre_u95,bayesian.periods,'y',clr, alph); hold on;
% plot(periods,qinv_pre_mat(:,igood),'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
errorbar(bayesian.obs.Rperiods,bayesian.obs.Rqinv,bayesian.obs.Rstdqinv,'-ok','linewidth',2); hold on;
plot(bayesian.periods,qinv_pre_med,'-','color',clr,'linewidth',3); hold on;
plot(bayesian.periods,bayesian.qinv_pre_mat_best,'-r','linewidth',3);
xlabel('Period (s)');
ylabel('Q^{-1}');
set(gca,'fontsize',15,'linewidth',1.5);
ylims = get(gca,'ylim');

subplot(2,2,4); box on;
% histogram(chi2_mat(i25pct),'linewidth',2); hold on;
histogram(bayesian.chi2_mat(igood),'linewidth',2); hold on;
xlabel('\chi^2')
set(gca,'fontsize',15,'linewidth',1.5);

%% Plot Q_mu^-1 Likihood PDF

qmu_inv_pdf_pl = bayesian.post.qmu_inv_pdf;
% % qmu_inv_pdf_pl(log10(qmu_inv_pdf_pl)<-5) = nan;

figure(5); clf;
set(gcf,'Position',[189   507   689   518],'color','w')


ax1 = subplot(2,2,[1 3]); box on; hold on;
surface(bayesian.qinvgrid,bayesian.zgrid,log10(qmu_inv_pdf_pl)); shading interp;
% plot(qmu_inv_mat(:,i25pct),z_int,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
% plot_shaded(qmu_inv_l95,qmu_inv_u95,z_int,'x',clr, alph); hold on;
% plot(qmu_inv_mat(:,igood),z_int,'-','color',[0.75 0.75 0.75],'linewidth',1.5); hold on;
% plot(qmu_inv_ref,z_int,'-k','linewidth',2); hold on;
plot(1./bayesian.frech_S(1).qmu,bayesian.frech_S(1).z,'-k','linewidth',3); hold on;
plot(qmu_inv_med,bayesian.z_int,'-','color',clr,'linewidth',3); hold on;
plot(bayesian.qmu_inv_mat_best,bayesian.z_int,'-r','linewidth',3); hold on;
plot(bayesian.post.qmu_inv_mean,bayesian.z_int,'-c','linewidth',3);
plot(bayesian.post.qmu_inv_med,bayesian.z_int,'-','color',[1 0.7 0],'linewidth',3);
plot(bayesian.post.qmu_inv_l95,bayesian.z_int,'--','color',[1 0.7 0],'linewidth',3);
plot(bayesian.post.qmu_inv_u95,bayesian.z_int,'--','color',[1 0.7 0],'linewidth',3);
contour(bayesian.qinvgrid,bayesian.zgrid,bayesian.post.qmu_inv_conf_mat,[0.95 0.95],'-m');
caxis([-5 0]);
pos = get(gca,'Position');
cb = colorbar;
ylabel(cb,'log_{10}(Probability)');
set(cb,'linewidth',1.5);
set(gca,'Position',pos);
colormap(viridis);
% colormap(flip(cptcmap('GMT_haxby')));
xlabel('Q_{\mu}^{-1}');
ylabel('Depth (km)');
set(gca,'ydir','reverse','Position',[ax1.Position(1)-0.05 ax1.Position(2) ax1.Position(3) ax1.Position(4)]);
set(gca,'fontsize',15,'linewidth',1.5);
cbpos = get(cb,'position');
set(cb,'position',[cbpos(1)+0.09 cbpos(2) cbpos(3) 0.4]);
title(bayesian.PROJ,'fontweight','bold','fontsize',20);

pos = ax1.Position;
ax2 = axes('Position',[pos(1)+0.35 pos(2) pos(3)*0.25 pos(4)]);
% fill(bayesian.post.disc_pdf,bayesian.z_int,'-k','linewidth',2,'FaceColor',[0.9 0 0]);
ylim(ax1.YLim);
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
yticklabels([]);


% PdF

qinv_pdf_pl = bayesian.post.qinv_pdf;
% % qinv_pdf_pl(log10(qinv_pdf_pl)<-5) = nan;
% qinv_meanpost = sum(qinv_pdf.*qinv_grid,1);

ax3 = subplot(2,2,2); box on; hold on;
surface(bayesian.periods_grid,bayesian.qinv_grid,log10(qinv_pdf_pl)); shading interp;
% scatter(bayesian.periods_grid(:),bayesian.qinv_grid(:),80,log10(qinv_pdf_pl(:)),'filled','markeredgecolor','k');
errorbar(bayesian.obs.Rperiods,bayesian.obs.Rqinv,bayesian.obs.Rstdqinv,'-ok','linewidth',2); hold on;
plot(bayesian.periods,qinv_pre_med,'-','color',clr,'linewidth',3); hold on;
plot(bayesian.periods,bayesian.qinv_pre_mat_best,'-r','linewidth',3);
% plot(periods_v,qinv_meanpost,'-c','linewidth',3);
plot(bayesian.periods,bayesian.post.qinv_mean_pre,'-c','linewidth',3);
plot(bayesian.periods,bayesian.post.qinv_med_pre,'-','color',[1 0.7 0],'linewidth',3);
plot(bayesian.periods,bayesian.post.qinv_l95_pre,'--','color',[1 0.7 0],'linewidth',3);
plot(bayesian.periods,bayesian.post.qinv_u95_pre,'--','color',[1 0.7 0],'linewidth',3);
contour(bayesian.periods_grid,bayesian.qinv_grid,bayesian.post.qinv_conf_mat,[0.95 0.95],'-m');
xlim([min(bayesian.periods) max(bayesian.periods)]);
ylim([0 0.02]);
caxis([-5 0]);
% pos = get(gca,'Position');
% cb = colorbar;
% ylabel(cb,'log_{10}(Probability)');
% set(cb,'linewidth',1.5);
% set(gca,'Position',pos);
% colormap(viridis);
ylabel('Q^{-1}');
xlabel('Period (s)');
set(gca,'fontsize',15,'linewidth',1.5,'Position',[ax3.Position(1)+0.06 ax3.Position(2) ax3.Position(3) ax3.Position(4)]);

%% Plot PdF of knot locations

% PdF
figure(6); clf;
set(gcf,'color','w');
box on; hold on;

zsp_pdf_pl = bayesian.post.zsp_pdf ;

knot_ind = [1:size(bayesian.post.zsp_pdf,1)];
[z_int_mat,knot_ind_mat] = meshgrid(bayesian.z_int_vec,knot_ind);

% w = sum(posteriorsp,1);
% bayesian.post.qmu_inv_mean = sum(w.*bayesian.qmu_inv_mat,2)./sum(w);

% surface(knot_ind_mat-0.5,z_int_mat,log10(zsp_pdf_pl),'EdgeColor','none'); %shading interp;
imagesc(knot_ind,bayesian.z_int_vec,log10(zsp_pdf_pl')); %shading interp;
plot(knot_ind,zsp,'ok','MarkerFaceColor','w','markersize',15);
plot(knot_ind,bayesian.post.zsp_mean,'+','color',[0 0 0],'markersize',12,'linewidth',5);
plot(knot_ind,bayesian.post.zsp_mean,'+c','color',[1 0 0],'markersize',10,'linewidth',3);
% scatter(knot_ind_mat(:),z_int_mat(:),80,log10(zsp_pdf_pl(:)),'filled','markeredgecolor','k');
% plot(bayesian.periods,qinv_pre_med,'-','color',clr,'linewidth',3); hold on;
% plot(bayesian.periods,bayesian.qinv_pre_mat_best,'-r','linewidth',3);
% % plot(periods_v,qinv_meanpost,'-c','linewidth',3);
% plot(bayesian.periods,bayesian.post.qinv_mean_pre,'-c','linewidth',3);
% plot(bayesian.periods,bayesian.post.qinv_med_pre,'-','color',[1 0.7 0],'linewidth',3);
% contour(bayesian.periods_grid,bayesian.qinv_grid,bayesian.post.qinv_conf_mat,[0.95 0.95],'-m');
xlim([0.5 max(knot_ind)+0.5]);
ylim([min(z_int),max(z_int)]);
caxis([-5 0]);
% pos = get(gca,'Position');
cb = colorbar;
ylabel(cb,'log_{10}(Probability)');
set(cb,'linewidth',1.5);
title('Knot Depth');
% set(gca,'Position',pos);
colormap(viridis);
ylabel('Depth (km)');
xlabel('Knot index');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
