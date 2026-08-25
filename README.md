# PacificQ_2026

Code accompanying Russell et al. (2026, *Nature*) for imaging upper-mantle
shear velocity and attenuation beneath the Pacific plate from surface-wave
observations. The pipeline has three stages, run in sequence, each of which
is a complete, runnable component on the small seismic datasets (Old ORCA,
Young ORCA, NoMelt) already bundled in this repository:

1. **`1_Vs_Inversion/`** -- bootstrap least-squares inversion of Rayleigh-wave
   phase velocities for a shear-velocity (Vs) profile, using
   [Computer Programs in Seismology (CPS) / `surf96`](https://www.eas.slu.edu/eqc/eqccps.html)
   kernels and a Perple_X-derived Vp/Vs-Rho parameterization.
2. **`2_Q_inversion/`** -- Markov chain Monte Carlo (MCMC) inversion of
   phase-velocity dispersion (informed by the Vs model from stage 1) for a
   shear-attenuation (Q<sub>&mu;</sub><sup>-1</sup>) profile, using
   [MINEOS](https://geodynamics.org/resources/mineos) normal-mode kernels,
   bundled in this repository under `MINEOS/`.
3. **`3_VBRc_Bayesian_Inversion/`** -- Bayesian MCMC inversion of the Vs and
   Q<sub>&mu;</sub><sup>-1</sup> profiles from stages 1-2 for physical state
   variables (temperature, melt fraction, water content, grain size) using
   the [Very Broadband Rheology Calculator (VBRc)](https://vbr-calc.github.io/vbr/),
   bundled in this repository under `VBRc/vbr_YT24/`.

Each stage directory contains the driving script(s) (prefixed `a1_`/`d2_`),
supporting `functions/`, and its own small input `data/`. Plotting scripts
used to generate the paper's final figures are prefixed `Z1_`/`Z2_`.
Shared third-party MATLAB utilities (`brewermap`, `save2pdf`) live in the
top-level `functions/`.

> **Note on scope:** all third-party software this pipeline depends on --
> CPS/`surf96`, MINEOS, Perple_X, and VBRc -- is fully bundled in this
> repository (source and, where applicable, precompiled binaries; see
> [System requirements](#1-system-requirements)). No separate installs
> are required on macOS Intel.

## Contents
1. [System requirements](#1-system-requirements)
2. [Installation guide](#2-installation-guide)
3. [Instructions for use](#3-instructions-for-use)
4. [License and citation](#4-license-and-citation)

---

## 1. System requirements

### Operating system
Developed and tested on **macOS (Intel/x86\_64)**. The compiled CPS
binaries in `bin_v3.30/`, the MEX files in `1_Vs_Inversion/functions/`
and `2_Q_inversion/functions/` (`*.mexmaci64`), the MINEOS binaries at
`MINEOS/FORTRAN/bin/`, and the Perple_X binaries at
`Perple_X/Simple_X/bin/` are all built for macOS on Intel silicon. None
of these will run as-is on Apple Silicon (M-series) without Rosetta, or
on Linux/Windows.
* To recompile CPS for another platform, get
  [Herrmann's CPS source distribution](https://www.eas.slu.edu/eqc/eqccps.html)
  and place the resulting executables in a directory you point
  `path2BIN`/`param.BINPATH` at (see the top of each stage's driver
  script), and recompile the MEX files with `functions/CompileMexFiles.m`
  (requires a MEX-compatible C compiler; run `mex -setup` in MATLAB first).
* MINEOS source is bundled at `MINEOS/FORTRAN/`, including build scripts
  and platform notes for both Intel Macs (`MINEOS/FORTRAN/README`) and
  Apple Silicon via Rosetta (`MINEOS/FORTRAN/README_apple_silicon.md`); a
  gfortran-based Linux build should work with the same makefiles but has
  not been tested here.
* Perple_X source and thermodynamic data files are bundled at
  `Perple_X/Simple_X/`; see `Perple_X/Simple_X/README.md` for
  recompilation notes (tested on macOS 10.15.7 with Perple_X 7.0.7).
* Stage 3 (VBRc) is pure MATLAB/Octave and is platform-independent.

### Software dependencies
| Dependency | Used by | Version tested | Notes |
|---|---|---|---|
| MATLAB | all stages | R2023a | Also works in [GNU Octave](https://www.gnu.org/software/octave/) for stage 3 (VBRc); stages 1-2 rely on macOS-Intel MEX/Fortran binaries and are not Octave-tested. |
| MATLAB Statistics and Machine Learning Toolbox | all stages | ships with R2023a | Uses e.g. `unifrnd`, `normrnd`. |
| MATLAB Signal Processing Toolbox | stages 1, 3 | ships with R2023a | Uses `findpeaks`. |
| [Computer Programs in Seismology (CPS)](https://www.eas.slu.edu/eqc/eqccps.html), `v3.30` | stage 1 | v3.30 | **Bundled**: precompiled binaries in `bin_v3.30/` (macOS Intel). Source available from the CPS website if recompilation is needed. |
| [MINEOS](https://geodynamics.org/resources/mineos) (`MINEOS_synthetics`) | stage 2 | -- | **Bundled** at `MINEOS/` (Fortran source, precompiled macOS-Intel binaries, and MATLAB wrappers). See `MINEOS/README.md`. Requires `gfortran` only if you need to rebuild the binaries. |
| [Perple_X](https://www.perplex.ethz.ch/), `7.0.7` | stages 1, 3 | 7.0.7 | **Bundled** at `Perple_X/Simple_X/` (source, precompiled macOS-Intel binaries in `bin/`, thermodynamic data files, and the Vp/Vs/Rho lookup tables already computed for this paper's geotherms under `RESULTS/Hacker08_noky_400km_stx21/*.tabs`). See `Perple_X/Simple_X/README.md`. |
| VBRc | stage 3 | bundled `vbr_YT24` snapshot | Included in this repository at `VBRc/vbr_YT24/`; no separate install needed. See `VBRc/vbr_YT24/README.md` for details. |
| [Git LFS](https://git-lfs.com/) | all | -- | Required to fetch the `.mat` data files (see [Installation guide](#2-installation-guide)). |

### Non-standard hardware
None required. All stages run on a standard desktop/laptop CPU; no GPU is
needed. Full-scale MCMC runs (stage 2: up to ~2,000,000 iterations; stage
3: ~10,000-1,000,000 iterations) are CPU/time-intensive (see
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
   unresolved LFS pointer file, not the real data).
2. **Install MATLAB** (R2023a or later recommended) with the Statistics and
   Machine Learning and Signal Processing toolboxes, or install
   [GNU Octave](https://www.gnu.org/software/octave/) if you only need
   stage 3 (VBRc).
3. **Make the bundled binaries executable** (macOS Intel). CPS is made
   executable automatically by the stage-1 driver script via `!chmod ++x
   ../bin_v3.30/*`, and the Perple_X binaries already carry the executable
   bit in Git, but the MINEOS binaries do not -- run this manually:
   ```bash
   chmod +x MINEOS/FORTRAN/bin/*
   ```
4. **(Optional, only needed to re-run stage 1/2 from scratch on new data)**
   Compile the MEX helper functions:
   ```matlab
   cd 1_Vs_Inversion/functions   % and separately: 2_Q_inversion/functions
   CompileMexFiles
   ```
5. **(Optional, only needed on non-macOS-Intel platforms)** Recompile CPS,
   MINEOS, and/or Perple_X from source -- see
   [System requirements](#1-system-requirements).

**Typical install time on a normal desktop:** under 5 minutes on macOS
Intel (dominated by the `git lfs pull` download, on the order of a few
hundred MB, plus the one `chmod` command). Step 4 (MEX compilation) is
under a minute once a C compiler is configured; skip it entirely if you're
only running the pipeline on the bundled data as shipped. Step 5
(recompiling for another platform) depends on that platform's build
toolchain and is not required on macOS Intel.

---

## 3. Instructions for use

The three numbered stage directories are themselves the demonstration:
each ships with the small (Old ORCA, Young ORCA, NoMelt) seismic datasets
used in the paper, and running a stage's driver script on that bundled
data is both a correctness check and a worked example.

### Running a stage on the bundled data
Each stage's driver script contains one commented-out parameter block per
site (`%% JdF`, `%% Young ORCA`, `%% NoMelt`, `%% Old ORCA`); the active
(uncommented) block is the one that will run, currently **Old ORCA** in
each script. From MATLAB (or Octave, for stage 3), `cd` into a stage
directory and run its driver script directly, e.g.:

```matlab
cd 1_Vs_Inversion
a1_run_surf96_Vs_lsqr_discFromQ_vpvsPplx_bs_Qcorr_BSsmLVZdQdz
```

Expected behavior per stage, on a normal desktop, using the bundled Old
ORCA data and the parameters as shipped:

| Stage | Script | What it produces | Approx. runtime |
|---|---|---|---|
| 1. Vs inversion | `a1_run_surf96_Vs_lsqr_discFromQ_vpvsPplx_bs_Qcorr_BSsmLVZdQdz.m` | Diagnostic figures plus `lsqr_kernel_Vs_..._bootstrap_BSsmLVZdQdz/OldORCA_Vs_Vp_Rho_lsqr_kernel_bs1000.mat` (bootstrap Vs(z) profile, ~4.1-4.8 km/s in the upper ~300 km, consistent with old, cold Pacific lithosphere and a low-velocity zone) | Depends on `Nbs` (bootstraps), default 1000: ~tens of minutes; set `Nbs = 10` for a ~1-2 minute smoke test |
| 2. Q inversion | `a1_run_Q_MCMC_spline_zknot_24_112s.m` | Diagnostic figures plus `bayesian_mcmc_Qspline_zknot_112s/OldORCA_uniform_Qmu_bayesian_Nspline12.mat` (MCMC Q<sub>&mu;</sub><sup>-1</sup>(z) profile, showing elevated attenuation in the asthenospheric low-velocity zone) | Depends on `nit_mcmc`, default 2,000,000: several hours; set `nit_mcmc = 2000` for a ~1-2 minute smoke test |
| 3. VBRc inversion | `d2_ViscHK_fref_YT24_QLVZ_Qstdthresh_dVs_dryEta_sig_VsNF_oo.m` | Diagnostic figures plus posterior state-variable distributions (T, melt fraction, water content, grain size) under `bayesian_mcmc_vbr_YT24/` | Depends on `param.nit_mcmc`, default 10,000 (paper figures also use runs up to 1,000,000): ~tens of minutes at 10,000; many hours at 1,000,000; set `param.nit_mcmc = 200` for a ~1-2 minute smoke test |

Each stage's outputs for Old ORCA, Young ORCA, and NoMelt are also already
checked into the repo -- including the full paper-scale stage 2/3 MCMC
runs (e.g. `3_VBRc_Bayesian_Inversion/bayesian_mcmc_vbr_YT24/*_nit1000000_*.mat`)
-- so the corresponding `Z1_`/`Z2_` plotting scripts for each stage can be
run immediately to inspect the paper's actual results without re-running
any of the (multi-hour) inversions.

> **Known minor gap:** the stage-1 driver script's diagnostic plotting
> section reads a reference model card, `./CARDS/pa5_5km.card`, that
> currently only exists at
> `3_VBRc_Bayesian_Inversion/S362ANI_plotting/CARDS/pa5_5km.card` -- copy
> it into `1_Vs_Inversion/CARDS/` (or point the `read_model_card` call at
> the existing copy) before running stage 1 end to end.

### Running the pipeline on your own data
1. **Prepare your input.** Build a `.mat` file matching the structure read
   by `2_Q_inversion/functions/load_data.m`: a struct with a `rayl` field
   (and optionally `love`) containing per-period vectors such as
   `periods_iso`, phase velocities, and errors (see
   `1_Vs_Inversion/data/*.mat` / `2_Q_inversion/data/*.mat` for the
   expected field names, once fetched via `git lfs pull`). Place it in the
   relevant stage's `data/` folder.
2. **Stage 1 -- Vs inversion**: copy one of the `%%`-delimited site blocks
   in the driver script, point `param.data` at your `.mat` file, and set
   `PROJ`/`age_myr`. `path2perlextab_vs/vp/rho` already point at the
   bundled Perple_X tables for this paper's geotherms -- generate your own
   with `Perple_X/Simple_X/a1_run_Perple_X.m` if you need a different
   composition/pressure-temperature range. Results are saved under
   `lsqr_kernel_Vs_..._bootstrap_BSsmLVZdQdz/<PROJ>_Vs_Vp_Rho_lsqr_kernel_bs<Nbs>.mat`.
3. **Stage 2 -- Q inversion**: point `param.lsqr_in` at the stage-1 output
   and `param.data` at your data file. MINEOS paths
   (`param.Path2runMineos`, `param.BINPATH` in `setup_parameters.m`)
   already point at the bundled `MINEOS/` directory -- no changes needed
   unless you relocate it. Results are saved under
   `bayesian_mcmc_Qspline_zknot_112s/<PROJ>_uniform_Qmu_bayesian_Nspline12.mat`.
4. **Stage 3 -- VBRc Bayesian inversion**: point
   `param.bootstraps_Vs`/`param.bootstraps_Q` at the stage 1/2 outputs;
   `path2perlextab_vs/vp/rho` already point at the bundled Perple_X tables
   (as in stage 1). Results are saved under `bayesian_mcmc_vbr_YT24/`.
5. **Plot final results** with the corresponding `Z1_`/`Z2_` script for
   each stage, editing the `matnames`/`mcmcfiles` lists to point at your
   output(s).

### Reproduction (full-scale runs)
The paper's published results (site: Old ORCA, 90 Ma) can be reproduced
end-to-end from the bundled input data (`*/data/OldORCA_meas.mat`) using
the active (uncommented) parameter blocks already in each driver script.
See the runtime table above for approximate wall-clock time at both the
paper-scale and quick smoke-test settings (single core, no
parallelization; machine-dependent).

---

## 4. License and citation

This repository's original code is released under the [MIT License](LICENSE).

If you use this code, please cite:

> Russell, J.B. et al. (2026). [Title]. *Nature*. [DOI]

Bundled third-party components retain their own licenses:
* **VBRc** (`VBRc/vbr_YT24/`): MIT License -- see `VBRc/vbr_YT24/README.md`.
* **CPS `surf96` binaries** (`bin_v3.30/`): see Herrmann's CPS license
  terms at [https://www.eas.slu.edu/eqc/eqccps.html](https://www.eas.slu.edu/eqc/eqccps.html).
* **Perple_X** (`Perple_X/Simple_X/`): the `Simple_X` MATLAB wrapper is the
  author's own code (covered by the MIT License above); the vendored
  Perple_X binaries/data files themselves are distributed under
  Perple_X's own terms -- see [perplex.ethz.ch](https://www.perplex.ethz.ch/).
  A nested third-party utility, `export_fig`, carries its own license at
  `Perple_X/Simple_X/functions/export_fig/LICENSE`.
* **brewermap** (`functions/brewermap/`): Apache License 2.0 -- see
  `functions/brewermap/LICENSE.TXT`.
* **save2pdf** (`functions/save2pdf.m`): third-party MATLAB File Exchange
  utility, author-attributed in the file header.
