#!/usr/bin/env R

library("DESeq2")

args <- commandArgs(trailingOnly = T)

data.name <- args[1]
data <- read.csv(data.name,header=T,row.names=1,check.names=F)

#data <- data[,2:ncol(data)]
rownames(data) <- sub("\\.[0-9]+","",rownames(data))

percentile_90 <- function(x) {quantile(x,0.90)}

total_reads <- as.vector(apply(data,2,sum))
calc_rpm <- function(x) {
  rpms <- x / total_reads * 1E+6
  return(rpms)
}

data.rpm <- as.data.frame(t(apply(data,1,calc_rpm)))
data <- data[as.vector(apply(data.rpm,1,percentile_90))>0.2,]

data.vst <- varianceStabilizingTransformation(as.matrix(data), blind = TRUE, fitType = "parametric")
data.vst <- round(data.vst,digit=3)

out.name <- args[2]
write.csv(data.vst,out.name,row.names=T,quote=F)

