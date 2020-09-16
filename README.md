# HERV_Pan-cancer_analysis

This is a repository of the programs used in the paper [Ito and Kimura et al., Science Advances, 2020].
Related data are available via the Mendeley data repository (http://dx.doi.org/10.17632/c7r7dw9p42.1).

Gene expression aberration is a hallmark of cancers, but the mechanisms underlying such aberrations remain unclear. Human endogenous retroviruses (HERVs) are genomic repetitive elements that potentially function as enhancers. Since numerous HERVs are epigenetically activated in tumors, their activation could cause global gene expression aberrations in tumors. To understand the roles of HERV-derived enhancers in cancers, we performed a pan-cancer analysis focusing on the gene regulatory activity of HERVs using The Cancer Genome Atlas (TCGA) and Cancer Cell Line Encyclopedia (CCLE) datasets.

## Contents: 
* RNA-Seq_pipeline: generate the expression matrix of genes and HERVs, perform quality control, filtering, and normalization
* Expressional_correlation_with_HERVs: calculate expression correlation between respective genes and the sum of HERVs and perform GSEA based on the correlation scores
* Survival: perform Cox proportional hazard regression and generate Kaplan Meier plot
* ATAC-Seq: calculate the fold enrichment of the overlaps between HERVs and ATAC-Seq peaks
* test_data: test data used for running programs in this repository
