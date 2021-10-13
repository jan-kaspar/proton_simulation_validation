# Introduction

This repository contains code for systematic testing and validation of the PPS direct simulation. It produces a set of standard plots (cf. the configs in `templates` directory) which can be compared across versions, settings etc. The tests are done in parallel for different PPS eras, cf. the `settings` directory.

Besides others, the standard plots include those quantifying the uncertainties related to the proton reconstruction: bias, resolution and systematics.



# User's guide

 * Log on a computer of convenience (tested on CERN's LXPLUS).
 * Download this repository (e.g. with git clone).
 * Edit `environment` file: enter the path to your CMSSW installation (tested with `CMSSW_12_1_0_pre3`).
 * Initialise the environment: `bash --rcfile environment`.
 * Optionally: edit `submit` file and (un)comment the PPS eras for which you wish to run tests.
 * Produce execution scripts: `./submit <my_version>`, where `<my_version>` stands for an output directory name.
 * If you wish to execute the on CERN's HTCondor, use the command printed on screen. If you wish to run (some of) them locally, use the `run_multiple` script - edit the file to select the version and the list of PPS eras. The local execution proceeds in background can take several minutes.
 * The results can be found in `data/<my_version>` directory.



# Maintainer's guide

 * The scripts for evaluating reconstruction bias and resolution are in `templates/proton_reco_resolution`. Those for alignment and optics related systematics are in `templates/proton_reco_misalignment` and `templates/proton_reco_optics`, respectively.
 * The mis-alignment scenarios considered are listed in file `templates/proton_reco_misalignment/run_multiple`, around line 56, where additional details are given. Currently, 4 scenarios are considered, 2 in horizontal and 2 in vertical plane. For each projection, symmetric (near and far RPs are displaced in the same direction) and antisymmetric (opposite directions) are included. Should a new scenario be needed, another line can simply be added to the bash script.
 * The mis-alignment is simulated by using different geometries for simulation ("misaligned" geometry) and reconstruction ("real" geometry).
 * The list of optics-related systematic scenarios is give in file `templates/proton_reco_optics/run_multiple` around line 41, where further details are given.
 * The optics-related systematics are simulated by using different optics for simulation (default) and reconstruction (modified/biased). The modification/biasing of the optics is performed by the CMSSW module `CTPPSModifiedOpticalFunctionsESSource`. If new optics scenarios are added, or the existing ones are updated, the module must be updated first, then the list of scenarios shall be updated in the `run_multiple` script.
 * Whenever the list of systematics scenarios is changed, one needs to modify the file `collect_systematics.cc` (around line 136) and recompile it (run `make`).
