#!/usr/bin/env bash

<<COMMENTOUT
featureCounts_dir_path=<path to the directory containing featureCounts output files>
COMMENTOUT


#make count matrix
python2 script/sum_table.py \
       ${featureCounts_dir_path}/*.txt \
       > test.txt


#summarize featureCounts information
python2 script/sum_featureCount_info.py \
       ${featureCounts_dir_path}/*.txt.summary \
       > test.featureCounts.info.txt


#quality control and filtering
R --vanilla --slave --args \
   test.featureCounts.info.txt \
   test.txt \
   test.featureCounts.info.filtered.txt \
   test.filtered.txt \
   < script/QC_filtering_RNA-Seq_libary.R


#calculate the total HERV expression level in each sample
R --vanilla --slave --args \
  test.filtered.txt \
  test.filtered.total_HERV.txt \
  < script/calc_total_HERV_expression.R


#calculate the expression level of HERV subfamilies 
python script/calc_subfamily_level_expression.py \
       test.filtered.txt \
       > test.filtered.subfamily.txt


#VST transformation (HERV locus level)
R --vanilla --slave --args \
  test.filtered.txt \
  test.filtered.vst.txt \
  < script/vst.R


#VST transformation (HERV subfamily level)
R --vanilla --slave --args \
  test.filtered.subfamily.txt \
  test.filtered.subfamily.vst.txt \
  < script/vst.R


#calculate GSVA score
R --vanilla --slave --args \
  test.filtered.vst.txt \
  ../test_data/association_BP_CC_canPath_InterPro.txt \
  test.filtered.vst.gsva.txt \
  < script/gsva.R

