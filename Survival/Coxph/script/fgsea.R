#!/usr/bin/env R

library(fgsea)
args <- commandArgs(trailingOnly = T)

data.name <- args[1]

data <- read.table(data.name,header=T)

goa_data.name <- args[2]
goa_data <- read.table(goa_data.name,header=T,sep="\t",stringsAsFactors=F)


goa_data <- goa_data[goa_data$ens_Id %in% data$ens_Id,]
data <- data[data$ens_Id %in% goa_data$ens_Id,]


geneSetList <- as.list(NULL)
for(i in 1:nrow(goa_data)){
  gs_name <- goa_data[i,1]
  ens_Id <- goa_data[i,2]
  if(! gs_name %in% names(geneSetList)){
    geneSetList[[gs_name]] <- as.vector(NULL)
  }
  geneSetList[[gs_name]] <- c(geneSetList[[gs_name]],ens_Id)
}

head(geneSetList)

stat.v <- data$z.score
names(stat.v) <- data$ens_Id

fgseaRes <- fgsea(pathways = geneSetList,
                  stats = stat.v,
                  minSize=20,
                  maxSize=10000,
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



out_f.name <-args[3]

write.table(fgseaRes,out_f.name,row.names=F,quote=F,sep="\t")

