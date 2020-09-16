#!/usr/bin/env R

library(fgsea)
args <- commandArgs(trailingOnly = T)

data.corr.name <- args[1]
data.corr <- read.table(data.corr.name,header=T)

data.goa.name <- args[2]
data.goa <- read.table(data.goa.name,header=T,sep="\t",stringsAsFactors=F)

data.goa <- data.goa[data.goa$ens_Id %in% data.corr$ens_Id, ]

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

head(geneSetList)

stat.v <- data.corr$corr.spearman
names(stat.v) <- data.corr$ens_Id

fgseaRes <- fgsea(pathways = geneSetList,
                  stats = stat.v,
                  minSize=50,
                  maxSize=1000,
                  nperm=10000)

collapsed_v <- c()
for(i in 1:nrow(fgseaRes)){
  v <- as.vector(fgseaRes$leadingEdge[[i]])
  collapsed <- paste(v,collapse=", ")
  collapsed_v <- c(collapsed_v,collapsed)
}

fgseaRes <- as.data.frame(fgseaRes[,1:7])
fgseaRes$leadingEdge <- collapsed_v
fgseaRes <- fgseaRes[order(fgseaRes$NES),]
out.name <- args[3]
write.table(fgseaRes,out.name,row.names=F,quote=F,sep="\t")
