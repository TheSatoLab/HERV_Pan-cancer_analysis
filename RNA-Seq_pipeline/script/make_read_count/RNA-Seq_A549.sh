#!/usr/bin/env R

#variables
<< COMMENTOUT
sample_Id=<sample fastq file Id>
index_dir=<STAR genome index directory path>
gene_HERV_model_f_path=<gene HERV transcript model file (GTF file) path>
COMMENTOUT

#mkdir 
mkdir bam \
      readCounts
      

#trimming
java -jar trimmomatic-0.36.jar \
      PE                     \
      -threads 12             \
      -phred33               \
      -trimlog trimlog.txt       \
      raw_data/${sample_Id}_1.fq.gz             \
      raw_data/${sample_Id}_2.fq.gz             \
      raw_data/${sample_Id}_1.fq.tr             \
      /dev/null \
      raw_data/${sample_Id}_2.fq.tr             \
      /dev/null \
      SLIDINGWINDOW:4:20


#mapping
mkdir bam/${sample_Id}

STAR --runThreadN 15 \
     --genomeDir ${index_dir} \
     --readFilesIn raw_data/${sample_Id}_1.fq.tr raw_data/${sample_Id}_2.fq.tr \
     --outFileNamePrefix bam/${sample_Id}/${sample_Id}_ \
     --outFilterMultimapScoreRange 1 \
     --outFilterMultimapNmax 10 \
     --outFilterMismatchNmax 5 \
     --alignIntronMax 500000 \
     --alignMatesGapMax 1000000 \
     --sjdbScore 2 \
     --alignSJDBoverhangMin 1 \
     --genomeLoad NoSharedMemory \
     --limitBAMsortRAM 0 \
     --outFilterMatchNminOverLread 0.33 \
     --outFilterScoreMinOverLread 0.33 \
     --sjdbOverhang 100 \
     --outSAMstrandField intronMotif \
     --outSAMattributes NH HI NM MD AS XS \
     --outSAMunmapped Within \
     --outSAMtype BAM Unsorted \
     --outSAMheaderHD @HD VN:1.4

#read count
featureCounts -p -t exon -g gene_id -T 8 --fracOverlap 0.25 \
  -a ${gene_HERV_model_f_path} \
  -o readCounts/${sample_Id}.txt \
  bam/${sample_Id}/${sample_Id}_Aligned.out.bam



#removing 
rm -r bam/${sample_Id}

