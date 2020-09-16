#!/usr/bin/env bash

R --vanilla --slave --args \
  ../../test_data/survival_info.txt \
  ../../test_data/res_TCGA-BLCA.gsva.csv \
  KM_plot.BLCA.txt \
  KM_plot.BLCA.pdf \
  < script/KM_plot.R


