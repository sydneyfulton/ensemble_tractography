#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Either hardcode these:
BL_ROOT="/home/sfulton/data/set_sample/100206/neuro"   # Brainlife subject root you showed (has mask_5tt.anat.5tt_masks, tensor_mrtrix3_tensor, csd_preprocessed)
INPUT_ROOT="./data/brainlife_SET_input/100206"                 # Destination for SET
set_nf=${SCRIPT_DIR}/../set-nf/
set_img=${set_nf}/set_1v1.img
mkdir -p ${INPUT_ROOT}

tt_dir=${BL_ROOT}/mask_5tt.anat.5tt_masks/ #tt_dir=$1
transf_dir=${BL_ROOT}/sample4set/nifti_reg2mni/ #trasnf_dir=$2
dti_dir=${BL_ROOT}/tensor_mrtrix3_tensor #dti_dir=$3
fodf_dir=${BL_ROOT}/neuro/csd_preprocessed #fodf_dir=$4


mask_input=${tt_dir}/mask.nii.gz
for i in {0..4}; do
  mrconvert  "$mask_input" -coord 3 $i mask_vol${i}.nii.gz
done

# MAIN #################################################################################################

## create brainlife data folders for SET input
mkdir -p "${INPUT_ROOT}/Register_T1"
mkdir -p "${INPUT_ROOT}/DTI_Metrics"
mkdir -p "${INPUT_ROOT}/FODF_Metrics"
mkdir -p "${INPUT_ROOT}/PFT_Seeding_Mask"
mkdir -p "${INPUT_ROOT}/freesurfer"

## copy files from brainlife to SET compatible folders and file names 


### PFT_Seeding_Mask
cp "${tt_dir}/mask_vol3.nii.gz" "${INPUT_ROOT}/PFT_Seeding_Mask/map_exclude.nii.gz"
cp "${tt_dir}mask_vol0.nii.gz" "${INPUT_ROOT}/PFT_Seeding_Mask/map_include.nii.gz"

### Register_T1

### output0GenericAffine.mat 
cp "${transf_dir}/affine.mat" "${INPUT_ROOT}/Register_T1/output0GenericAffine.mat"

### output1InverseWarp.nii.gz 
cp "${transf_dir}/inverse-warp.nii" "${INPUT_ROOT}/Register_T1/output1InverseWarp.nii"


### DTI_Metrics
cp "${ti_dir}/fa.nii" "${INPUT_ROOT}/DTI_Metrics/fa.nii"


### FODF_Metrics
cp "${fodf_dir}/lmax8.nii" "${INPUT_ROOT}/FODF_Metrics/fodf.nii"


### Freesurfer 
FS_set_dir="${INPUT_ROOT}/freesurfer/100206"
cp -r  "${BL_ROOT}/neuro/freesurfer_acpc_aligned/output"  "${FS_set_dir}"

### run SET

nextflow run ${set_nf}/main.nf -with-singularity ${set_img} -profile freesurfer_a2009s_proper  --surfaces ${FS_set_dir}   --tractoflow ${INPUT_ROOT}

