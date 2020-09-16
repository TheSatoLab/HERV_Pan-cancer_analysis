# Survival

* Coxph (directory): Cox proportional hazard regression analysis
  * script/batch_pipeline.sh: a shell script to run the following programs.
  * script/survival.gene.R: performs Cox proportional hazard regression analysis for all genes and HERVs. The R package of survival (v3.2.3) is used.
  * script/fgsea.R: performs GSEA based on the z scores of genes or HERVs calculated by the above Cox proportional hazard regression analysis.


* KM_plot (directory): Kaplan Meier plot analysis
  * batch_pipeline.sh: a shell script to run the following programs.
  * KM_plot.R: draws Kaplan Meier plot. The R packages of survival (v3.2.3) and survminer (v0.4.8) are used.
    
