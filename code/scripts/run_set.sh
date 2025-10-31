#!/bin/bash
# run_set_nf.sh
# Usage:
#   bash run_set_nf.sh --surfaces_dir <path> --data_dir <path> --output_dir <path>

# Default Nextflow version and pipeline paths
NXF_VER=21.10.6
PIPELINE_PATH="/home/sfulton/local/set-nf/main.nf"
SINGULARITY_IMG="/home/sfulton/local/set-nf/set_1v1.img"
PROFILE="freesurfer_a2009s_proper"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --surfaces_dir) SURFACES="$2"; shift ;;
        --data_dir) DATA="$2"; shift ;;
        --output_dir) OUTPUT="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check that all required args are provided
if [[ -z "$SURFACES" || -z "$DATA" || -z "$OUTPUT" ]]; then
    echo "Usage: bash run_set_nf.sh --surfaces_dir <path> --data_dir <path> --output_dir <path>"
    exit 1
fi

# Run the pipeline
echo "Running Nextflow pipeline..."
NXF_VER=$NXF_VER nextflow run "$PIPELINE_PATH" \
    -with-singularity "$SINGULARITY_IMG" \
    -profile "$PROFILE" \
    --surfaces "$SURFACES" \
    --tractoflow "$DATA" \
    --output_dir "$OUTPUT"
