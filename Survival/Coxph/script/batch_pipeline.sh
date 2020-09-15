#!/usr/bin/env bash

R --vanilla --slave --args \
  ../../test_data/association_BP_CC_canPath_InterPro.txt \
  ../../test_data/transcribed_HERVs_catted.bed \
  ../../test_data/survival_info.txt \
  ../../test_data/TCGA-BLCA_unique_HERV_genes_tumor_vst.txt \
  res_coxph.TCGA-BLCA.txt \
  < script/survival.gene.R


R --vanilla --slave --args \
  res_coxph.TCGA-BLCA.txt \
  ../../test_data/association_BP_CC_canPath_InterPro_HERVs_around_HERVs.txt \
  res_gsea.based_on_coxph.TCGA-BLCA.txt \
  < script/fgsea.R
