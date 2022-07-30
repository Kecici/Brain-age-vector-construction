%% Get TIV from SPM12 mwc images without mask, and Jac Integ using ICV mask

%% Setup
%seg8mats = spm_select(inf, 'seg8\.mat$', 'Select SPM12''s seg8.mat files');
function spm12_tiv_extras_invdef(seg8mats)
N = size(seg8mats, 1);
%tc = false(6,4); tc(1:3, 4) = true; % for mwc[123]
tc = false(6,4); % Don't save mwc.
bf = false(1,2);
% df = [false true]; % to get (forward) deformation
df = [true false]; % and false for all tc

mask = fullfile(spm('dir'), 'tpm', 'mask_ICV.nii');

TIV_mwc = nan(N, 1);
TIV_Jac = nan(N, 1);
TIV_Jacback = nan(N, 1);


fid = fopen('spm12_tiv_jackbak.csv', 'wt');
assert(fid > 0, 'failed to open file for writing results')
fprintf(fid, 'Image,TIV_Jac_back\n');

%% Loop over subjects
wb = waitbar(0, 'Looping over subjects...');
for n = 1:N
    seg8 = load(seg8mats(n, :));
    spm_preproc_write8(seg8, tc, bf, df);

    direc = spm_file(seg8.image.fname, 'path');
    name  = spm_file(seg8.image.fname, 'basename');

    %matlabbatch{1}.spm.util.defs.comp{1}.def = {[ direc '/iy_' name(1:5) '-003-1.nii']};
    matlabbatch{1}.spm.util.defs.comp{1}.def = {[ direc '/iy_' name '.nii']};
    matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {mask};
    matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savepwd = 1;
    matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 4;
    matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
    matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('Deformations: Warped Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','warped'));
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.moveto = {direc};
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.patrep.pattern = 'wmask_ICV';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.patrep.repl = ['icv_' name]
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.unique = false;

    spm('defaults', 'PET');
    spm_jobman('run',matlabbatch)


    %% TIV from mwc (without mask)
    direc = spm_file(seg8.image.fname, 'path');
    name  = spm_file(seg8.image.fname, 'basename');
    outmask = spm_select('FPList', direc, ['^icv_' name]);
outmask
    assert(size(outmask, 1) == 1, 'Problem with outmask for: %s\n', name);
    TIV_Jackbak(n) = sum(spm_summarise(outmask, 'all', 'litres'));
    %% Delete files created by this script to save space
    %mwc = cellstr(mwc);
    %spm_unlink(jac, def, mwc{:});
        
    %% Write results
    fprintf(fid, '%s,%g\n', name, TIV_Jackbak(n));
    
    waitbar(n/N, wb);
end
close(wb);
fclose(fid);

%% Save matlab file for completeness
save('spm12_tiv_jackbak.mat');
