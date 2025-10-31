#!/usr/bin/env python3
"""
merge_tractograms.py
--------------------
Merge multiple .tck tractography files into one output file.

Usage:
    python merge_tractograms.py --input track0.tck track1.tck track2.tck --output merged.tck

Requirements:
    pip install nibabel numpy
"""

import argparse
import nibabel as nib
import numpy as np
from pathlib import Path
import sys


def merge_tck_files(input_files, output_file):
    """Load multiple .tck files and concatenate their streamlines."""
    if len(input_files) < 2:
        sys.exit("You must provide at least two input .tck files.")

    print(f"Merging {len(input_files)} .tck files → {output_file}")

    # Load the first file (defines reference space)
    ref_obj = nib.streamlines.load(input_files[0])
    ref_tg = ref_obj.tractogram
    all_streamlines = list(ref_tg.streamlines)

    for path in input_files[1:]:
        print(f"  Adding: {path}")
        tg = nib.streamlines.load(path).tractogram

        # Optional: warn if affine spaces differ
        if (ref_tg.affine_to_rasmm is not None and tg.affine_to_rasmm is not None and
            not np.allclose(ref_tg.affine_to_rasmm, tg.affine_to_rasmm, atol=1e-5)):
            print(f"  [WARN] {path} affine differs; concatenating anyway.", file=sys.stderr)

        all_streamlines.extend(tg.streamlines)

    merged_tg = nib.streamlines.Tractogram(all_streamlines, affine_to_rasmm=ref_tg.affine_to_rasmm)
    nib.streamlines.save(merged_tg, str(output_file))

    print(f"Done. Wrote {output_file}")


def main():
    parser = argparse.ArgumentParser(description="Merge multiple .tck tractography files into one.")
    parser.add_argument("--input", nargs="+", required=True,
                        help="List of input .tck files to merge (space-separated).")
    parser.add_argument("--output", required=True,
                        help="Output .tck filename (e.g., merged.tck or merged.tck.gz)")
    args = parser.parse_args()

    input_files = [Path(f) for f in args.input]
    for f in input_files:
        if not f.exists():
            sys.exit(f"Input file not found: {f}")

    output_file = Path(args.output)
    output_file.parent.mkdir(parents=True, exist_ok=True)

    merge_tck_files(input_files, output_file)


if __name__ == "__main__":
    main()
