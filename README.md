# CURE
A cumulative reciprocity strategy

This repository contains code and data for simulation experiments and economic experiments.

4. The execution of the economic experiment is as follows. First, we recruited 189 participants through the online platform Prolific. Second, we asked participants to conduct prisoner's dilemma games experiment through OTree software (The installation and use instructions of the software are given below). In the experiment, participants made behavioral choices based on page instructions(the code/economic_experiments/screensshots_game folder). The obtained experimental data is stored in the code/economic_experiments/figure6/Masterfile_V1.zlsx file. Finally, we analyzed this data by running matlab code and got the results (ExperimentalData.mat and Figure 6 in ./figure6 folder). The DoStatisticalAnalysis.m file in this folder is the execution code, and the execution script is in the "code/run" file. 

5. OTree is an open-source software product that runs on the local PC (http://www.otree.org/). In the code/economic_experiments/OTree folder, we provide the OTree Installation package for this experiment, OTree documentations have all up to date instructions on how to install oTree and run games (https://otree.readthedocs.io/en/latest/). We summarize the installation process as follows:
--Install python in advance in your PC
--download OTree 
--Execute the command otree devserver in the command-line shell (for windows)
--get web address http://localhost:8000/
--Open this address in the browser to start the experiment
