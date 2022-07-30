07/26/2017: Chenfei Ye
ICV paper:https://www.ncbi.nlm.nih.gov/pubmed/25255942

Dependency: SPM12
ICV toolbox is already included in SPM12.
 
If user just needs to calculate value of ICV volume, run using GUI, as shown in 'how to launch ICV toolbox in SPM12.png'
if user needs batch processing or validate the results by checking ICV mask, run using scripts.

scripts in ICV-code folder£»

main.m: choose T1 image folder
readfile.m: process T1 images of each subject in a recursive way
seg.m: tissue segmentaion of T1 image. seg8.mat in the output is important for generating individual ICV mask
icv.m: automatic calculate ICV value for each subject
spm12_tiv_extras_invdef.m: warp standard ICV mask to individual space, generate individual ICV mask
writeICV.m: write WM/GM/CSF/ICV to a csv file
