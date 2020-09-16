#!/usr/bin/env bash

python2 script/calc_enrichment_randomized.py \
        transcribed_HERVs_TCGA-BLCA_LTR.bed \
        ATAC-Seq.upper_quantile_peaks.BLCA.bed \
        chromSize_hg38.txt \
        1000
