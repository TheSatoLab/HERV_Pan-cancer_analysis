#!/usr/bin/env R

library(survival)

args <- commandArgs(trailingOnly = T)

ens_symbol.df.name <- args[1]
ens_symbol.df <- read.table(ens_symbol.df.name,header=T)
ens_symbol.df <- unique(ens_symbol.df[,2:3])

HERV.df.name <- args[2]
HERV.df <- read.table(HERV.df.name,header=F)
HERV.df <- data.frame(ens_Id = HERV.df$V4, symbol = HERV.df$V4)

ens_symbol.df <- rbind(ens_symbol.df,HERV.df)

clinical.info.name <- args[3]
clinical.info <- read.table(clinical.info.name,header=T)

data.name <- args[4]
data <- read.csv(data.name,header=T,row.names=1,check.names=F)
rownames(data) <- sub("\\.[0-9]+","",rownames(data))

data <- data[,colnames(data) %in% clinical.info$sample_Id]

data.norm <- as.data.frame(t(apply(data, 1, scale)))
colnames(data.norm) <- colnames(data)


col.df <- data.frame(col_Id = 1:ncol(data.norm), sample_Id = colnames(data.norm))
col.df.merged <- merge(col.df,clinical.info,by="sample_Id")
col.df.merged$Race <- factor(col.df.merged$Race,levels=unique(col.df.merged$Race))

ens_Id.v <- c()
pval.v <- c()
z.v <- c()
hr.v <- c()
for(i in 1:nrow(data.norm)){
  ens_Id <- rownames(data.norm)[i]
  df.temp <- col.df.merged[,3:6]
  df.temp$interest <- as.numeric(data.norm[i,])
  fit <- coxph(Surv(time, status) ~ interest + Gender + Race, data=df.temp)
  fit.sum <- summary(fit)
  hr <- fit.sum$coefficients[1,2]
  z <- fit.sum$coefficients[1,4]
  pval <- fit.sum$coefficients[1,5]
  ens_Id.v <- c(ens_Id.v,ens_Id)
  hr.v <- c(hr.v,hr)
  z.v  <- c(z.v,z)
  pval.v <- c(pval.v,pval)
}

res.df <- data.frame(ens_Id = ens_Id.v, hazard.ratio = hr.v, z.score = z.v, pval = pval.v)
res.df <- merge(res.df,ens_symbol.df,ny="ens_Id")
res.df$padj <- p.adjust(res.df$pval,method="BH")
res.df <- res.df[order(res.df$z.score),]

out.name <- args[5]
write.table(res.df,out.name,col.names=T,row.names=F,sep="\t",quote=F)
