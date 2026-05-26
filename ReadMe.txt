Replication Files – Transfer-Induced Debt Dynamics in Sovereign Default

This folder contains the data and MATLAB code required to replicate all quantitative results in the paper.

The code was tested in MATLAB R2023b.
Parallel Computing Toolbox and a supported C compiler are required to compile the MEX file.
Expected total runtime: approximately 60 minutes on a standard desktop (Intel i7, 16GB RAM).


Folder Structure


1. Data Folder (Replication of Figure 1)

This folder contains the fiscal data and scripts used to construct Figure 1.

    GIIPS_fiscal.xlsx
    Fiscal data downloaded from Eurostat.

    fiscal_euro_illustration.m
    Generates the upper-panel subplots of Figure 1.

    fiscal_ratio_illustration.m
    Generates the lower-panel subplots of Figure 1.



2. Model Folder (Sovereign Default Model)

This folder contains MATLAB files to solve the model, simulate the economy, and reproduce all tables and figures.


2.1 Solving the Model

Run: fiscal_zf2.m

This script:

    Calls tauchen.m to discretize the shock processes.

    Calls solver_fiscal_zf_parfor.m to solve the model.

    For computational speed, solver_fiscal_zf_parfor.m is compiled into MEX C code (solver_fiscal_zf_parfor_mex).

The solution is saved as:

    fiscal_zf2.mat

If grid sizes or state-space dimensions are modified, the MEX file must be recompiled.
This requires a compatible C compiler configured in MATLAB.



2.2 Replicating Tables 1 and 2

After generating fiscal_zf2.mat, run:

    simu_zf2.m

This script computes the simulated moments reported in Tables 1 and 2.



2.3 Replicating Figure 2 (Typical Default Episodes)

After generating fiscal_zf2.mat, run:

    typdef_simu.m

This produces simulated mean paths around default events.

Then run:

    typdef_illustration.m

to generate Figure 2.



2.4 Replicating Figures 3 and 4 (Policy Functions)

Run: policy_functions.m



2.5 Replicating Figures 5 and 6 (Impulse Responses)

Run: irf_simu_Frise.m

This computes conditional and unconditional generalized impulse response functions and saves them to:

    irf_Frise.mat

Note: This simulation step may take a significant amount of time.

Afterwards, run:

    irfs_illustration.m

to generate Figures 5 and 6.



2.6 Replicating Figure 7 (Transfer-Side Austerity Experiment)

Run:  analyze_event.m

Adjust the relevant parameter settings to generate:

    analyze_event_ife9.mat
    analyze_event_ife10.mat
    analyze_event_ife13.mat

Then run the illustration script to generate Figure 7.


    
    

