#!/usr/bin/env R

args <- commandArgs(trailingOnly = T)

data.name <- args[1]
data <- read.csv(data.name,header=T,row.names=1,check.names=F)

data.HERV <- data[!grepl("ENSG",rownames(data)),]

total.df <- data.frame(sample_Id = colnames(data),
                       count.total = apply(data,2,sum),
                       count.HERV = apply(data.HERV,2,sum))

total.df$prop.HERV <- total.df$count.HERV / total.df$count.total

out.name <- args[2]
write.table(total.df,out.name,row.names=F,col.names=T,sep="\t",quote=F)

