function icv(filename)
spmpath=which('spm');
spmpath(end-5:end)=[];

[parentpath,filename_wo_suffix,~] = fileparts(filename);

jobs{1}.spm.spatial.preproc.channel.vols = {[filename,',1']};
jobs{1}.spm.spatial.preproc.channel.biasreg = 0.001;
jobs{1}.spm.spatial.preproc.channel.biasfwhm = 60;
jobs{1}.spm.spatial.preproc.channel.write = [0 0];
jobs{1}.spm.spatial.preproc.tissue(1).tpm = {[spmpath,'/tpm/TPM.nii,1']};
jobs{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
jobs{1}.spm.spatial.preproc.tissue(1).native = [1 0];
jobs{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(2).tpm = {[spmpath,'/tpm/TPM.nii,2']};
jobs{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
jobs{1}.spm.spatial.preproc.tissue(2).native = [1 0];
jobs{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(3).tpm = {[spmpath,'/tpm/TPM.nii,3']};
jobs{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
jobs{1}.spm.spatial.preproc.tissue(3).native = [1 0];
jobs{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(4).tpm = {[spmpath,'/tpm/TPM.nii,4']};
jobs{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
jobs{1}.spm.spatial.preproc.tissue(4).native = [1 0];
jobs{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(5).tpm = {[spmpath,'/tpm/TPM.nii,5']};
jobs{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
jobs{1}.spm.spatial.preproc.tissue(5).native = [1 0];
jobs{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(6).tpm = {[spmpath,'/tpm/TPM.nii,6']};
jobs{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
jobs{1}.spm.spatial.preproc.tissue(6).native = [0 0];
jobs{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
jobs{1}.spm.spatial.preproc.warp.mrf = 1;
jobs{1}.spm.spatial.preproc.warp.cleanup = 1;
jobs{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
jobs{1}.spm.spatial.preproc.warp.affreg = 'mni';
jobs{1}.spm.spatial.preproc.warp.fwhm = 0;
jobs{1}.spm.spatial.preproc.warp.samp = 3;
jobs{1}.spm.spatial.preproc.warp.write = [0 0];
jobs{2}.spm.util.tvol.matfiles = {[parentpath,'/',filename_wo_suffix,'_seg8.mat']};
jobs{2}.spm.util.tvol.tmax = 3;
jobs{2}.spm.util.tvol.mask = {[spmpath,'/tpm/mask_ICV.nii,1']};
jobs{2}.spm.util.tvol.outf = filename_wo_suffix;
%jobs{3}.cfg_basicio.var_ops.cfg_assignin.name = [filename_wo_suffix,'_ICV]';
%jobs{3}.cfg_basicio.var_ops.cfg_assignin.output(1)=cfg_dep('Tissue Volumes: Sum', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','vol_sum'));

spm_jobman('run',jobs);
disp('ICV calculation completed')
clear jobs