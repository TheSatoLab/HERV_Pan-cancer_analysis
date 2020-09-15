#!/usr/bin/env R

args <- commandArgs(trailingOnly = T)

#total HERV expression
data.total_HERV.name <- args[1]
data.total_HERV <- read.table(data.total_HERV.name,row.names=1,header=T)

data.name <- args[2]
data <- read.csv(data.name,header=T,row.names=1,check.names=F)

data.goa.name <- args[3]
data.goa <- read.table(data.goa.name,header=T,sep="\t")
gene_with_goa <- unique(data.goa[,2:3])

rownames(data) <- sub("\\.[0-9]+","",rownames(data))

data.gene <- data[rownames(data) %in% gene_with_goa$ens_Id,]
data.gene <- t(data.gene)

data.total_HERV <- data.total_HERV[rownames(data.gene),]

data.corr <- cor(data.gene,data.total_HERV$prop.HERV,method="spearman")
data.corr <- as.data.frame(data.corr)
data.corr$ens_Id <- rownames(data.corr)
colnames(data.corr)[1] <- "corr.spearman"

data.corr <- merge(data.corr,gene_with_goa,by="ens_Id")
data.corr <- data.corr[order(data.corr$corr.spearman),]
data.corr <- data.corr[!duplicated(data.corr$ens_Id),]

out.name <- args[4]
write.table(data.corr,out.name,quote=F,row.names=F,col.names=T,sep="\t")

