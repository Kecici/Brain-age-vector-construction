%-----------------------------------------------------------------------
% Chenfei Ye updated:11/30/2016
% This script is designed for intracranial volume (ICV) integration
% Usage:
% Just run this script, and select the folder containing all seperate csv files in GUI
% Output:
% Generate a single csv file refecting GM/WM/CSF/ICV absolute volume for all subjects 

% ------cye7@jhu.edu
% Note that use main.m first to obtain ICV file for each subject
%-----------------------------------------------------------------------
clc
clear


mainpath= uigetdir(cd, 'Choose the main directory of CSV'); 
if isequal(mainpath,0)
    disp('User selected Cancel')
else
    disp(['User selected the main directory',':  ', fullfile(mainpath)])
    %ls_csv=ls([mainpath,'/*.csv']);
    dirout = dir(fullfile(mainpath,'*.csv'));
    cell_summury={};
    cell_summury(1,1)=cellstr('File');
     cell_summury(1,2)=cellstr('GM_Volume');
      cell_summury(1,3)=cellstr('WM_Volume');
       cell_summury(1,4)=cellstr('CSF_Volume');
       cell_summury(1,5)=cellstr('ICV');
    for i = 1:size(dirout,1)
        name = dirout(i).name;
        fullname=[mainpath,'/',name];
        [parentpath,filename_wo_suffix,~] = fileparts(fullname);
        %xlswrite(fullname, 'ICV', filename_wo_suffix,'E1');
        %data = xlsread(fullname,filename_wo_suffix, 'B2:D2');
        data = csvread(fullname,1,1);
        cell_summury(i+1,1)=cellstr(filename_wo_suffix);
        cell_summury(i+1,2)=num2cell(data(1));
        cell_summury(i+1,3)=num2cell(data(2));
        cell_summury(i+1,4)=num2cell(data(3));
        cell_summury(i+1,5)=num2cell(data(1)+data(2)+data(3));
        
    
    
    end
    %xlswrite([mainpath,'/ICV_summury.csv'],cell_summury,1);
    cell2csv([mainpath,'/ICV_summury.csv'],cell_summury);
end

