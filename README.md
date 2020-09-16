# HERV_Pan-cancer_analysis

This is a repository of the programs used in the paper [Ito and Kimura et al., Science Advances, 2020].
The related data are available via the Mendeley data repository (http://dx.doi.org/10.17632/c7r7dw9p42.1).

Gene expression aberration is a hallmark of cancers, but the mechanisms underlying such aberrations remain unclear. Human endogenous retroviruses (HERVs) are genomic repetitive elements that potentially function as enhancers. Since numerous HERVs are epigenetically activated in tumors, their activation could cause global gene expression aberrations in tumors. To understand the roles of HERV-derived enhancers in cancers, we performed a pan-cancer analysis focusing on the gene regulatory activity of HERVs using The Cancer Genome Atlas (TCGA) and Cancer Cell Line Encyclopedia (CCLE) datasets.

## Contents: 
* RNA-Seq_pipeline: generates the expression matrix of genes and HERVs and performs quality control, filtering, and normalization of the elements in the matrix.
* Expressional_correlation_with_HERVs: calculates expression correlation between respective genes and the sum of HERVs and performs GSEA based on the correlation scores.
* Survival: performs Cox proportional hazard regression and generates Kaplan Meier plot.
* ATAC-Seq: calculates the fold enrichment of the overlaps between HERVs and ATAC-Seq peaks.
* test_data: test data used for running programs in this repository
