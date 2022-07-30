
function outpath = readfile(mainpath,outputType)


dir_main=dir(mainpath);

%disp(mainpath);

% conversion starts
if ~isempty([mainpath,'/*.img'])
    %lsdir=ls([mainpath,'/*.img']);
    dirout = dir(fullfile(mainpath,'*.img'));
    for j=1:size(dirout,1)
        name = dirout(j).name;
        filename=[fullfile(mainpath),'/',name];
        %disp(filename)
        [~,filename_wo_suffix,~] = fileparts(filename);
        %filename_wo_suffix
        %[cd,'/',filename_wo_suffix,'.csv']
        switch outputType
            case 1
                if ~exist([cd,'/',filename_wo_suffix,'.csv'])
                    icv(strtrim(filename));
                end
            case 2
                if ~exist([mainpath,'/icv_',filename_wo_suffix,'.nii'])
                    seg(strtrim(filename));
                    spm12_tiv_extras_invdef([mainpath,'/',filename_wo_suffix,'_seg8.mat']);
                end
        end
    end
end

dir_cell=struct2cell(dir_main)';

if sum(cell2mat(dir_cell(:,4)))>2 % if there is any subfolder in current directory
    for i=3:numel(dir_main)
        
        if dir_main(i).isdir==1 % if item i is a folder
            mainpath= fullfile(mainpath,dir_main(i).name);
            outpath = readfile(mainpath,outputType); % iteration
            mainpath=outpath;
        end
        
    end
    % End search current directory, return to parent directory
    [parentpath,name,ext] = fileparts(mainpath);
    outpath=parentpath;
else
    % No subfolders in current directory, return to parent directory
    [parentpath,name,ext] = fileparts(mainpath);
    outpath=parentpath;
    
end


