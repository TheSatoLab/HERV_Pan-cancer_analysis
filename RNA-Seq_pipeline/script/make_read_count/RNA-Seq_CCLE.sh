#!/usr/bin/env bash

#variables
<< COMMENTOUT
cancer_Id=<CCLE cancer Id (e.g., CCLE-BRCA)>
bam_file_name=<CCLE bam file name (e.g., G41726.MCF7.5.bam)>
sample_Id=<CCLE file UUID (e.g., 33fe59e7-3e3d-4275-b8a7-5affae8ecc8d)>
dbGap_token_f_path=<dbGap token file path>
gene_HERV_model_f_path=<gene HERV transcript model file (GTF file) path, liftovered to hg19>
COMMENTOUT

#mkdir
mkdir -p download/${sample_Id} \
         temp_bam \
         bam \
         readCounts/${cancer_Id}


#download
gdc-client download ${sample_Id} -d download

#sort
sambamba_v0.6.6 sort --sort-by-name -t 8 -m 10G -u --tmpdir=temp_bam -o bam/${sample_Id}.sorted.bam download/${sample_Id}/${bam_file_name}

#unique, HERV_genes
featureCounts -p -t exon -g gene_id -T 8 --fracOverlap 0.25 \
  -a ${gene_HERV_model_f_path} \
  -o readCounts/${cancer_Id}/${sample_Id}.txt \
  bam/${sample_Id}.sorted.bam

#removing 
rm bam/${sample_Id}.sorted.bam
rm -r download/${sample_Id}

