%-----------------------------------------------------------------------
% Chenfei Ye updated:11/30/2016
% This script is designed for intracranial volume (ICV) calculation
% Usage:
% Just run this script, and select the folder in GUI
% Output:
% Generate a csv file refecting GM/WM/CSF absolute volume for each subject 

% ------cye7@jhu.edu
% Feature:
% Support convert dcm files in subfolders using iterative search. 
%-----------------------------------------------------------------------
clc
clear
outputType=1; % 1 for icv value, 2 for icv mask

mainpath= uigetdir(cd, 'Choose the main directory of MR images'); 
if isequal(mainpath,0)
    disp('User selected Cancel')
else
    disp(['User selected the main directory',':  ', fullfile(mainpath)])
    readfile(mainpath,outputType)
end

