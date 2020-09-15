#!/usr/bin/env R

#calculate the correlation of each gene expression with the total HERV expression
R --vanilla --slave --args \
  ../RNA-Seq_pipeline/test.filtered.total_HERV.txt \
  ../RNA-Seq_pipeline/test.filtered.vst.txt \
  ../test_data/association_BP_CC_canPath_InterPro.txt \
  corr_test.txt \
  < script/genes_correlated_with_HERVs.R


#do GSEA analysis
R --vanilla --slave --args \
  corr_test.txt \
  ../test_data/association_BP_CC_canPath_InterPro.txt \
  GSEA_corr_test.txt \
  < script/fgsea.R


#exclude redundant gene sets
python script/rmRedundantGS_median.py \
   --gs_f ../test_data/association_BP_CC_canPath_InterPro.txt \
   --gsea_f ../res_sum_table.test.txt \
   --corr_f corr_sum_table_without_NA.test.txt \
   --gs_category BP_CC_canPath_InterPro \
   --res_num 100 \
   --thresh 0.7 > sum_res_BP_CC_canPath_InterPro_median_100.test.txt

