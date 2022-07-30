# Brain volumes extraction based on FastSurfer

import pandas as pd
import numpy as np
import os
import copy
import nibabel as nib
import glob
import SimpleITK as sitk
from skimage import morphology

'''
T1_img: Path of input T1 image /*.nii.gz
fastsrufer_path：Path of fastsurfer_master
fastsurfer_analysis_folder：output folder of FastSurfer segmentation results.
nii_folder：FastSufer segmentation results /*.nii.gz
csv_folder：Volumes of 95 brain regions based on DKT atlas /*.csv
'''

# T1_img = "/media/hitlab/HD4/rc/test_retest/pMCI/nii/I11112.nii.gz"
# name = I11112
# fastsurfer_path = "/media/hitlab/HD1/rc/rc/FastSurfer-master/FastSurfer-master"
# fastsurfer_analysis_folder = "/media/hitlab/HD4/rc/test_retest/pMCI/fastsurfer_analysis/mgz/"
# nii_folder = "/media/hitlab/HD4/rc/test_retest/pMCI/fastsurfer_analysis/nii/"
# csv_folder = "/media/hitlab/HD4/rc/test_retest/pMCI/fastsurfer_analysis/csv/"

def fastsuffer_run(fastsurfer_path, T1_img, fastsurfer_analysis_folder, name):
    os.system("bash %s/run_fastsurfer.sh --t1 %s --sid %s --sd %s --seg_only --batch 8" % (fastsurfer_path, T1_img, name, fastsurfer_analysis_folder))
    mgz_img = fastsurfer_analysis_folder + name + "/mri/aparc.DKTatlas+aseg.deep.mgz"
    return mgz_img

def mgz2nii(mgz_img, name):
    nii_img = nii_folder + name + ".nii.gz"
    os.system("mri_convert %s %s" % (mgz_img, nii_img))
    return nii_img

def volume_get(nii_img, name, csv_folder):
    df_volume = pd.DataFrame()
    img = sitk.ReadImage(nii_img)
    spacing_list = img.GetSpacing()
    spacing = 1
    for sp in spacing_list:
        spacing *= sp
    img_org = nib.load(nii_img)
    img = img_org.get_data()
    all_labels = np.unique(img)

    label = []
    volume = np.zeros(shape=(1,len(all_labels)))
    j = 0
    sum_vol = 0

    for lbl in all_labels:
        if lbl == 0 :
            continue
        check_img = copy.copy(img)
        check_img[img == lbl] = 1
        check_img[img != lbl] = 0
        vol_old = np.sum(check_img)

        labels = morphology.label(check_img)
        labels_num = [len(labels[labels == each]) for each in np.unique(labels)]
        rank = np.argsort(np.argsort(labels_num))
        index = list(rank).index(len(rank) - 2)
        check_img[labels != index] = 0
        vol = np.sum(check_img)
        if abs(vol - vol_old) / vol > 0.1:
            use_vol = vol_old
        else:
            use_vol = vol
        label.append("label %s" % (lbl))
        volume[0,j] = use_vol
        sum_vol = sum_vol + use_vol  
        j = j+1

    label.append("sum_vol")
    volume[0,j] = sum_vol
    df_volume = pd.DataFrame(volume, index = ['%s' % (name)], columns = label)
    df_volume.index.name = 'name'
    volume_data = csv_folder + name + ".csv"
    df_volume.to_csv(volume_data)
    return volume_data

def volume_extraction_main(fastsurfer_path, T1_img, fastsurfer_analysis_folder, name, csv_folder):
    mgz_img = fastsuffer_run(fastsurfer_path, T1_img, fastsurfer_analysis_folder, name)
    nii_img = mgz2nii(mgz_img, name)
    volume_data = volume_get(nii_img, name, csv_folder)
