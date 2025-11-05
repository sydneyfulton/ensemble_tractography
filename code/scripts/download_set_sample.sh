#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"

local_dir=$( dirname $SCRIPT_DIR )
bl_data_hand=${local_dir}/bl_data_hand
bl_data_download=${bl_data_hand}/bl_data_download.sh


if [ ! -f ${bl_data_download}  ]; then

    cd ${local_dir}
    git clone https://github.com/gamorosino/bl_data_hand.git

    cd ${SCRIPT_DIR}

fi


output_dir=$1

if [[ -z "$output_dir" ]]; then
    echo "Usage: $0 <output_dir> "
    exit 1
fi

bash ${bl_data_download}   5ffc884d2ba0fba7a7e89132 \
                            neuro/freesurfer  \
                            ${output_dir} \
                            1 \
                            --output-prefix datatype,datatype_tag \
                            --subject 100206

bash ${bl_data_download}   5ffc884d2ba0fba7a7e89132 \
                            neuro/csd \
                            ${output_dir} \
                            1 \
                            --output-prefix datatype,datatype_tag \
                            --subject 100206

bash ${bl_data_download}   5ffc884d2ba0fba7a7e89132 \
                            neuro/tensor  \
                            ${output_dir} \
                            1 \
                            --output-prefix datatype,tag \
                            --subject 100206 mrtrix3_tensor

bash ${bl_data_download}   5ffc884d2ba0fba7a7e89132 \
                            neuro/mask \
                            ${output_dir} \
                            1 \
                            --output-prefix datatype,datatype_tag \
                            --subject 100206 \
                            '+5tt' '+anat' '+5tt_masks'


bash ${bl_data_download}   5941a225f876b000210c11e5 \
                            neuro/dwi \
                            ${output_dir} \
                            1 \
                            --output-prefix datatype,datatype_tag \
                            --subject 100206 \
                            'preprocessed'