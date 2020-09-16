# Expressional_correlation_with_HERVs

* script/batch_pipeline.sh: a shell script to run the following programs.
* script/genes_correlated_with_HERVs.R: calculates the correlation of each gene expression with the total HERV expression.
* script/fgsea.R: runs GSEA analysis based on the above correlation scores. The R package of fgsea (1.12.0) is used.
* script/rmRedundantGS_median.py: excludes redundant gene sets from the GSEA results. If the gene members of a certain gene set highly overlapped with those of the upper-ranked gene sets, the gene set was removed from the result. As a statistic of the overlap, the Szymkiewicz–Simpson coefficient was used.

* corr_sum_table_without_NA.test.txt.gz: A table of Spearman correlation of each gene expression and the total HERV expression in 12 TCGA cancer projects. 
A test input for "script/rmRedundantGS_median.py".
* res_sum_table.test.txt.gz: A table of normalized enrichment score (NES) calculated by GSEA in 12 TCGA cancer projects. A test input for "script/rmRedundantGS_median.py".
