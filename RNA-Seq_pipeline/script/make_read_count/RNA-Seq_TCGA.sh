#!/usr/bin/env R

#variables
<< COMMENTOUT
cancer_Id=<TCGA cancer Id (e.g., TCGA-BLCA)>
bam_file_name=<TCGA bam file name (e.g., b0f90c87-b382-4d18-9b20-ee6786c8ecb3_gdc_realn_rehead.bam)>
sample_Id=<TCGA file UUID (e.g., 01b17e79-a2c5-44a7-a7b7-c56a9698629e)>
dbGap_token_f_path=<dbGap token file path>
gene_HERV_model_f_path=<gene HERV transcript model file (GTF file) path>
COMMENTOUT

#mkdir
mkdir -p download \
         temp_bam \
         bam \
         readCounts/${cancer_Id}

#download
mkdir download/${sample_Id}
gdc-client download ${sample_Id} -t ${dbGap_token_f_path} -d download

#sort
sambamba_v0.6.6 sort --sort-by-name -t 8 -m 10G -u --tmpdir=temp_bam -o bam/${sample_Id}.sorted.bam download/${sample_Id}/${bam_file_name}

#read count
featureCounts -p -t exon -g gene_id -T 8 --fracOverlap 0.25 \
  -a ${gene_HERV_model_f_path} \
  -o readCounts/${cancer_Id}/${sample_Id}.txt \
  bam/${sample_Id}.sorted.bam

#removing 
rm bam/${sample_Id}.sorted.bam
rm -r download/${sample_Id}

