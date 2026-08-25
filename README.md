# PacificQ_2026

Code accompanying Russell et al. (2026, *Nature*) for imaging upper-mantle
shear velocity and attenuation beneath the Pacific plate from surface-wave
observations. The pipeline has three stages, run in sequence:

1. **`1_Vs_Inversion/`** -- bootstrap least-squares inversion of Rayleigh-wave
   phase velocities for a shear-velocity (Vs) profile, using
   [Computer Programs in Seismology (CPS) / `surf96`](https://www.eas.slu.edu/eqc/eqccps.html)
   kernels and a Perple_X-derived Vp/Vs-Rho parameterization.
2. **`2_Q_inversion/`** -- Markov chain Monte Carlo (MCMC) inversion of
   phase-velocity dispersion (informed by the Vs model from stage 1) for a
   shear-attenuation (Q<sub>&mu;</sub><sup>-1</sup>) profile, using
   [MINEOS](https://geodynamics.org/resources/mineos) normal-mode kernels.
3. **`3_VBRc_Bayesian_Inversion/`** -- Bayesian MCMC inversion of the Vs and
   Q<sub>&mu;</sub><sup>-1</sup> profiles from stages 1-2 for physical state
   variables (temperature, melt fraction, water content, grain size) using
   the [Very Broadband Rheology Calculator (VBRc)](https://vbr-calc.github.io/vbr/),
   bundled in this repository under `VBRc/vbr_YT24/`.

Each stage directory contains the driving script(s) (prefixed `a1_`/`d2_`),
supporting `functions/`, and its own small demo/input `data/`. Plotting
scripts used to generate the paper's final figures are prefixed `Z1_`/`Z2_`.

> **Note on scope:** this repository documents and ships the code and a
> small demonstration dataset for all three stages. Two pieces of
> third-party scientific software that stages 1-3 call out to --
> **MINEOS** and **Perple_X** -- are external dependencies that are *not*
> redistributed here (see [System requirements](#1-system-requirements)
> and [Instructions for use](#4-instructions-for-use)). The quick
> [Demo](#3-demo) below does **not** require either of them.

## Contents
1. [System requirements](#1-system-requirements)
2. [Installation guide](#2-installation-guide)
3. [Demo](#3-demo)
4. [Instructions for use](#4-instructions-for-use)
5. [License and citation](#5-license-and-citation)

---

## 1. System requirements

### Operating system
Developed and tested on **macOS (Intel/x86\_64)**. The compiled CPS
binaries in `bin_v3.30/` and the MEX files in `1_Vs_Inversion/functions/`
and `2_Q_inversion/functions/` (`*.mexmaci64`) are built for macOS on
Intel silicon and will **not** run as-is on Apple Silicon (M-series),
Linux, or Windows.
* On other platforms, recompile the CPS binaries from
  [Herrmann's CPS source distribution](https://www.eas.slu.edu/eqc/eqccps.html)
  and place the resulting executables in a directory you point
  `path2BIN`/`param.BINPATH` at (see the top of each stage's driver
  script), and recompile the MEX files with `functions/CompileMexFiles.m`
  (requires a MEX-compatible C compiler; run `mex -setup` in MATLAB first).
* Stage 3 (VBRc) is pure MATLAB/Octave and is platform-independent.

### Software dependencies
| Dependency | Used by | Version tested | Notes |
|---|---|---|---|
| MATLAB | all stages | R2023a | Also works in [GNU Octave](https://www.gnu.org/software/octave/) for stage 3 (VBRc); stages 1-2 rely on macOS MEX binaries and are not Octave-tested. |
| MATLAB Statistics and Machine Learning Toolbox | all stages | ships with R2023a | Uses e.g. `unifrnd`, `normrnd`. |
| MATLAB Signal Processing Toolbox | stages 1, 3 | ships with R2023a | Uses `findpeaks`. |
| [Computer Programs in Seismology (CPS)](https://www.eas.slu.edu/eqc/eqccps.html), `v3.30` | stage 1 | v3.30 | Compiled binaries bundled in `bin_v3.30/` (macOS Intel). Source available from the CPS website if recompilation is needed. |
| [MINEOS](https://geodynamics.org/resources/mineos) | stage 2 | -- | **External dependency, not bundled.** Compile/install separately and point `param.Path2runMineos` / `param.BINPATH` in `2_Q_inversion/setup_parameters.m` at your installation. |
| [Perple_X](https://www.perplex.ethz.ch/) | stages 1, 3 | -- | **External dependency, not bundled.** Used to generate Vp/Vs/Rho lookup tables as a function of pressure/temperature. Scripts expect `.tabs` output tables at a path you set (`path2perlextab_vs/vp/rho`); see [Instructions for use](#4-instructions-for-use). |
| VBRc | stage 3 | bundled `vbr_YT24` snapshot | Included in this repository at `VBRc/vbr_YT24/`; no separate install needed. See `VBRc/vbr_YT24/README.md` for details. |
| [Git LFS](https://git-lfs.com/) | all | -- | Required to fetch the `.mat` data files (see [Installation guide](#2-installation-guide)). |

### Non-standard hardware
None required. All stages run on a standard desktop/laptop CPU; no GPU is
needed. Full-scale MCMC runs (stage 2: ~2,000,000 iterations; stage 3:
~10,000-1,000,000 iterations) are CPU/time-intensive (see
[Reproduction](#reproduction-full-scale-runs) below) but do not require
specialized hardware -- just patience or a multi-core workstation.

---

## 2. Installation guide

1. **Clone the repository with Git LFS.** The `.mat` data files under
   `*/data/`, `3_VBRc_Bayesian_Inversion/lsqr_kernel_.../`, and
   `3_VBRc_Bayesian_Inversion/bayesian_mcmc_.../` are tracked with
   [Git LFS](https://git-lfs.com/) (see `.gitattributes`).
   ```bash
   git lfs install
   git clone https://github.com/jbrussell/PacificQ_2026.git
   cd PacificQ_2026
   git lfs pull
   ```
   Confirm the pull worked -- e.g. `3_VBRc_Bayesian_Inversion/lsqr_kernel_Vs_vpvsPerplex_Qcorr65s_bootstrap_BSsmLVZdQdz/OldORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat`
   should be tens of KB, not ~130 bytes (130 bytes means you have an
   unresolved LFS pointer file, not the real data -- re-run `git lfs pull`,
   and if it still fails, verify Git LFS is enabled/reachable for this
   repository, since some hosting/proxy or review configurations block LFS
   downloads).
2. **Install MATLAB** (R2023a or later recommended) with the Statistics and
   Machine Learning and Signal Processing toolboxes, or install
   [GNU Octave](https://www.gnu.org/software/octave/) if you only need
   stage 3 (VBRc).
3. **Make the bundled CPS binaries executable** (macOS Intel only; done
   automatically by the stage-1 driver script via `!chmod ++x
   ./bin_v3.30/*`, but you can also run it manually):
   ```bash
   chmod +x bin_v3.30/*
   ```
4. **(Optional, only needed to re-run stage 1/2 from scratch on new data)**
   Compile the MEX helper functions:
   ```matlab
   cd 1_Vs_Inversion/functions   % and separately: 2_Q_inversion/functions
   CompileMexFiles
   ```
5. **(Optional, only needed for the full pipeline)** Install MINEOS and
   Perple_X and note their paths -- see
   [System requirements](#1-system-requirements) and
   [Instructions for use](#4-instructions-for-use).

**Typical install time on a normal desktop:** under 5 minutes for steps 1-3
(dominated by the `git lfs pull` download, a few hundred MB). Step 4 (MEX
compilation) is under a minute once a C compiler is configured. Step 5
(MINEOS/Perple_X) is not required for the demo and depends on those
packages' own build systems (typically 10-30 minutes each).

---

## 3. Demo

A small, self-contained demo lives in [`demo/run_demo.m`](demo/run_demo.m).
It loads pre-computed, small (tens-of-KB) intermediate outputs already
bundled in this repository for the "Old ORCA" site -- the bootstrap Vs
profile from stage 1 and the MCMC Q<sub>&mu;</sub><sup>-1</sup> profile from
stage 2 -- and plots them. It requires only base MATLAB/Octave: **no
MINEOS, Perple_X, or MEX compilation needed.**

### Instructions to run
```matlab
cd demo
run_demo
```

### Expected output
* Console output ending with:
  ```
  Running PacificQ_2026 demo (Old ORCA)...
  Saved figure to: .../demo/demo_OldORCA_Vs_Qinv.png

  Summary (Old ORCA):
    Vs        at ~50 km depth  : <value> km/s (68% CI: <lo> - <hi>)
    Q_mu^-1   at ~100 km depth : <value> (68% CI: <lo> - <hi>)

  Demo complete.
  ```
* A figure (also saved as `demo/demo_OldORCA_Vs_Qinv.png`) with two panels,
  depth (0-300 km) on the y-axis (inverted):
  * left: Vs(z) median profile with 68% confidence shading (~4.1-4.8 km/s
    in the upper ~300 km, consistent with old, cold Pacific lithosphere and
    a low-velocity zone).
  * right: Q<sub>&mu;</sub><sup>-1</sup>(z) median profile with 68%
    confidence shading, showing elevated attenuation in the
    asthenospheric low-velocity zone.

### Expected run time
A few seconds on a normal desktop computer.

---

## 4. Instructions for use

### Running the pipeline on your own data
Each stage's driver script contains one commented-out parameter block per
site (`%% JdF`, `%% Young ORCA`, `%% NoMelt`, `%% Old ORCA`); the active
(uncommented) block is the one that will run. To use your own data:

1. **Prepare your input.** Build a `.mat` file matching the structure read
   by `2_Q_inversion/functions/load_data.m`: a struct with a `rayl` field
   (and optionally `love`) containing per-period vectors such as
   `periods_iso`, phase velocities, and errors (see
   `1_Vs_Inversion/data/*.mat` / `2_Q_inversion/data/*.mat` for the
   expected field names, once fetched via `git lfs pull`). Place it in the
   relevant stage's `data/` folder.
2. **Stage 1 -- Vs inversion**
   (`1_Vs_Inversion/a1_run_surf96_Vs_lsqr_discFromQ_vpvsPplx_bs_Qcorr_BSsmLVZdQdz.m`):
   copy one of the `%%`-delimited site blocks, point `param.data` at your
   `.mat` file, set `PROJ`/`age_myr`, and point `path2perlextab_vs/vp/rho`
   at your own Perple_X output tables (generate these with a local
   Perple_X install -- e.g. Hacker & Abers-style pyrolite/mantle tables of
   Vs/Vp/Rho vs. pressure-temperature; format matches `readtable`-style
   `.tabs` files). Run the script; results are saved under
   `lsqr_kernel_Vs_..._bootstrap_BSsmLVZdQdz/<PROJ>_Vs_Vp_Rho_lsqr_kernel_bs<Nbs>.mat`.
3. **Stage 2 -- Q inversion**
   (`2_Q_inversion/a1_run_Q_MCMC_spline_zknot_24_112s.m`): point
   `param.lsqr_in` at the stage-1 output, `param.data` at your data file,
   and `param.Path2runMineos`/`param.BINPATH` (in `setup_parameters.m`) at
   your local MINEOS installation. Run the script; results are saved
   under `bayesian_mcmc_Qspline_zknot_112s/<PROJ>_uniform_Qmu_bayesian_Nspline12.mat`.
4. **Stage 3 -- VBRc Bayesian inversion**
   (`3_VBRc_Bayesian_Inversion/d2_ViscHK_fref_YT24_QLVZ_Qstdthresh_dVs_dryEta_sig_VsNF_oo.m`):
   point `param.bootstraps_Vs`/`param.bootstraps_Q` at the stage 1/2
   outputs and `path2perlextab_vs/vp/rho` at your Perple_X tables (as in
   stage 1). Run the script; results are saved under
   `bayesian_mcmc_vbr_YT24/`.
5. **Plot final results** with the corresponding `Z1_`/`Z2_` script for
   each stage, editing the `matnames`/`mcmcfiles` lists to point at your
   output(s).

Full runs are compute-intensive relative to the demo -- see
[Reproduction](#reproduction-full-scale-runs) below for realistic runtimes
and how to shrink them for a quick smoke test.

### Reproduction (full-scale runs)
The paper's published results (site: Old ORCA, 90 Ma) can be reproduced
end-to-end from the bundled input data (`*/data/OldORCA_meas.mat`) using
the active (uncommented) parameter blocks already in each driver script,
**provided you have MINEOS and Perple_X installed and their paths set**
(see above). Approximate wall-clock time on a normal desktop (single core,
no parallelization):

| Stage | Key parameter | Default (paper-scale) | Approx. runtime | Quick smoke-test setting |
|---|---|---|---|---|
| 1. Vs inversion | `Nbs` (bootstraps), `a1_run_surf96_Vs_lsqr_discFromQ_vpvsPplx_bs_Qcorr_BSsmLVZdQdz.m` | 1000 | ~tens of minutes | `Nbs = 10` -> ~seconds-minutes |
| 2. Q inversion | `nit_mcmc`, `a1_run_Q_MCMC_spline_zknot_24_112s.m` | 2,000,000 | several hours | `nit_mcmc = 2000` -> ~1-2 minutes |
| 3. VBRc inversion | `param.nit_mcmc`, `d2_ViscHK_..._oo.m` | 10,000 (as shipped; paper figures also use runs up to 1,000,000) | 10,000 iters: ~tens of minutes; 1,000,000 iters: many hours | `param.nit_mcmc = 200` -> ~1-2 minutes |

These are approximate and machine-dependent; reduce the listed parameters
for a fast correctness check before committing to a full-scale run.

**Note:** the `Z1_`/`Z2_` `*_PAPER25` plotting scripts that generate the
exact camera-ready paper figures additionally reference a few
supplementary/comparison files and the third-party `brewermap`/`save2pdf`
utilities that are not yet bundled in this repository. The `run_demo.m`
script and the stage-level driver scripts above are fully self-contained
and do not have this limitation; if reviewers need the exact paper-figure
scripts to run out of the box, those extra files/utilities should be added
before submission.

---

## 5. License and citation

If you use this code, please cite:

> Russell, J.B. et al. (2026). [Title]. *Nature*. [DOI]

The VBR Calculator bundled in `VBRc/vbr_YT24/` is distributed under the
MIT License (see `VBRc/vbr_YT24/README.md`). CPS (`bin_v3.30/`) is
distributed under Robert Herrmann's CPS license terms (see
[https://www.eas.slu.edu/eqc/eqccps.html](https://www.eas.slu.edu/eqc/eqccps.html)).
A license for the original code in this repository (`1_Vs_Inversion/`,
`2_Q_inversion/`, `3_VBRc_Bayesian_Inversion/`) has not yet been added --
add a `LICENSE` file specifying reuse terms before publication.
