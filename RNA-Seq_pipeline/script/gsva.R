#!/usr/bin/env R

args <- commandArgs(trailingOnly = T)

library(parallel)
library(GSVA)

data.vst.name <- args[1]
data <- read.csv(data.vst.name,header=T,row.names=1,check.names=FALSE)

data.goa.name <- args[2]
data.goa <- read.table(data.goa.name,header=T,sep="\t",stringsAsFactors=F)

rownames(data) <- sub("\\.[0-9]+","",rownames(data))

data.gene <- data[rownames(data) %in% data.goa$ens_Id,]
data.goa <- data.goa[data.goa$ens_Id %in% rownames(data.gene), ]
dim(data.gene)
rm(data);gc();gc()


#make gene set
geneSetList <- as.list(NULL)
for(i in 1:nrow(data.goa)){
  gs_name <- data.goa[i,1]
  ens_Id <- data.goa[i,2]
  if(! gs_name %in% names(geneSetList)){
    geneSetList[[gs_name]] <- as.vector(NULL)
  }
  geneSetList[[gs_name]] <- c(geneSetList[[gs_name]],ens_Id)
}

print("start analysis")

data.gsva <- gsva(as.matrix(data.gene), geneSetList, mx.diff=TRUE, verbose=FALSE, parallel.sz=6,min.sz=20,max.sz=10000) #$es.obs

data.gsva <- round(data.gsva,digits=3)

out_f.name <- args[3]
write.csv(data.gsva,out_f.name,row.names=T,quote=T)
