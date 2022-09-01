# CURE
A cumulative reciprocity strategy

This repository contains code and data for simulation experiments and economic experiments.

1. The execution of the economic experiment is as follows. First, we recruited 189 participants through the online platform Prolific. Second, we asked participants to conduct prisoner's dilemma games experiment through OTree software (The installation and use instructions of the software are given below). In the experiment, participants made behavioral choices based on page instructions(the economic_experiments/screensshots_game.zip file). The obtained experimental data is stored in the Masterfile_V1.zlsx file. Finally, we analyzed this data by running matlab code and got the results (ExperimentalData.mat and Figure 6 in ./code folder). The DoStatisticalAnalysis.m file in this folder is the execution code, it can been execute on Matlab. 

2. OTree is an open-source software product that runs on the local PC (http://www.otree.org/). In the economic_experiments/OTree5-cure folder, we provide the OTree5-cure Installation package for this experiment, OTree5-cure documentations have all up to date instructions on how to install oTree and run games (https://otree.readthedocs.io/en/latest/). We summarize the installation process as follows:
--Install python in advance in your PC
--download OTree5-cure 
--Execute the command otree devserver in the command-line shell (for windows)
--get web address http://localhost:8000/
--Open this address in the browser to start the experiment

3. In the simulation_experiments folder, including repeated prisoner's dilemma game (RPDG) experiment, repeated public goods game (RPGG) experiment, stochastic prisoner's dilemma game (SPDG) experiment. Under each corresponding folder is the relevant code and the Data obtained through run codes.
