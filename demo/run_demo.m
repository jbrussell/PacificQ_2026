% run_demo.m
%
% Minimal, dependency-light demonstration of the PacificQ_2026 pipeline
% outputs for the Old ORCA site (Russell et al., 2026).
%
% This script does NOT re-run the full inversions -- stages 1-3 of the
% pipeline require MINEOS and Perple_X, which are external dependencies
% not bundled in this repository (see the top-level README). Instead,
% this script loads the small, pre-computed intermediate results that
% DO ship with this repository (a few KB each, under Git LFS) and
% reproduces the two core depth profiles that stages 1 and 2 produce:
%
%   (1) shear velocity      Vs(z)        from the Rayleigh-wave lsqr
%                                         inversion (stage 1, 1_Vs_Inversion)
%   (2) shear attenuation   Q_mu^-1(z)   from the MCMC inversion
%                                         (stage 2, 2_Q_inversion)
%
% Requires only base MATLAB (or GNU Octave) -- no toolboxes, no compiled
% binaries/mex files, no external software.
%
% Expected run time on a normal desktop: a few seconds.
% Expected output:
%   - a figure with two panels (Vs(z) and Q_mu^-1(z), 0-300 km depth)
%     saved to demo/demo_OldORCA_Vs_Qinv.png
%   - printed summary statistics (see below) to the console
%
% jbrussell

clear; close all;

fprintf('Running PacificQ_2026 demo (Old ORCA)...\n');

demo_dir = fileparts(mfilename('fullpath'));
repo_root = fileparts(demo_dir);

addpath(fullfile(repo_root,'3_VBRc_Bayesian_Inversion','functions'));

%% Load pre-computed Vs bootstrap inversion result (stage 1 output)
path2Vs = fullfile(repo_root,'3_VBRc_Bayesian_Inversion', ...
    'lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap_BSsmLVZdQdz', ...
    'OldORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat');
assert(exist(path2Vs,'file')==2, ...
    ['Could not find demo Vs data file:\n  ',path2Vs, ...
     '\nDid you run "git lfs pull" after cloning the repository?']);
temp = load(path2Vs);
lsqrinv = temp.lsqrinv; clear temp;

% Convert lsqr bootstrap structure into the same "bayesian" format used
% throughout the pipeline (median profile + 68% confidence interval)
bootstrap_Vs = lsqr2bayesian_2(lsqrinv,'disc');

%% Load pre-computed Q MCMC inversion result (stage 2 output)
path2Q = fullfile(repo_root,'3_VBRc_Bayesian_Inversion', ...
    'bayesian_mcmc_Qspline_zknot_112s', ...
    'OldORCA_uniform_Qmu_bayesian_Nspline12.mat');
assert(exist(path2Q,'file')==2, ...
    ['Could not find demo Q data file:\n  ',path2Q, ...
     '\nDid you run "git lfs pull" after cloning the repository?']);
temp = load(path2Q);
bayesian_Q = temp.bayesian; clear temp;

%% Plot
figure('color','w','position',[200 200 900 450]);

subplot(1,2,1); box on; hold on;
plot_shaded(bootstrap_Vs.bayesian.post.vs_l68, bootstrap_Vs.bayesian.post.vs_u68, ...
    bootstrap_Vs.bayesian.z_int, 'x', [0.85 0.1 0.1], 0.25);
plot(bootstrap_Vs.bayesian.post.vs_med, bootstrap_Vs.bayesian.z_int, ...
    '-r', 'linewidth', 2.5);
set(gca,'YDir','reverse','FontSize',12,'LineWidth',1.2);
xlabel('V_S (km/s)'); ylabel('Depth (km)');
title('Stage 1: Vs inversion');
ylim([0 300]);

subplot(1,2,2); box on; hold on;
plot_shaded(bayesian_Q.post.qmu_inv_l68, bayesian_Q.post.qmu_inv_u68, ...
    bayesian_Q.z_int, 'x', [0.1 0.3 0.85], 0.25);
plot(bayesian_Q.post.qmu_inv_med, bayesian_Q.z_int, '-b', 'linewidth', 2.5);
set(gca,'YDir','reverse','FontSize',12,'LineWidth',1.2);
xlabel('Q_\mu^{-1}'); ylabel('Depth (km)');
title('Stage 2: Q inversion');
ylim([0 300]);

try
    sgtitle('PacificQ 2026 demo -- Old ORCA','FontSize',14,'FontWeight','bold');
catch
    % sgtitle unavailable (older MATLAB / some Octave versions) -- skip
end

outpng = fullfile(demo_dir,'demo_OldORCA_Vs_Qinv.png');
try
    exportgraphics(gcf,outpng,'Resolution',150); % MATLAB >= R2020a
catch
    print(gcf,outpng,'-dpng','-r150'); % fallback; also works in Octave
end
fprintf('Saved figure to: %s\n', outpng);

%% Print summary (also serves as a quick correctness check)
[~,i50] = min(abs(bootstrap_Vs.bayesian.z_int-50));
[~,i100] = min(abs(bayesian_Q.z_int-100));
fprintf('\nSummary (Old ORCA):\n');
fprintf('  Vs        at ~50 km depth  : %.3f km/s (68%% CI: %.3f - %.3f)\n', ...
    bootstrap_Vs.bayesian.post.vs_med(i50), ...
    bootstrap_Vs.bayesian.post.vs_l68(i50), bootstrap_Vs.bayesian.post.vs_u68(i50));
fprintf('  Q_mu^-1   at ~100 km depth : %.4f (68%% CI: %.4f - %.4f)\n', ...
    bayesian_Q.post.qmu_inv_med(i100), ...
    bayesian_Q.post.qmu_inv_l68(i100), bayesian_Q.post.qmu_inv_u68(i100));
fprintf('\nDemo complete.\n');
