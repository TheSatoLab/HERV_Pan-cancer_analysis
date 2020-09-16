#!/usr/bin/env R

args <- commandArgs(trailingOnly = T)
options(width=10000)

SG <- function(x)
{
        confidence.interval = 0.05
        dell.value <- NULL
	while(TRUE)
	{
        branch.length <- range(x)
        x <- x[!is.na(x)]
        n <- length(x)
        t <- abs(range(x)-mean(x))/sd(x)
        p <- n*pt(sqrt((n-2)/((n-1)^2/t^2/n-1)), n-2, lower.tail=FALSE)
        result <- list(parameter=c(df=n-2))
        result1 <- structure(c(result,  list(branch.length=branch.length[1], statistic=c(t=t[1]), p.value=p[1])), class="htest")
        result2 <- structure(c(result,  list(branch.length=branch.length[2], statistic=c(t=t[2]), p.value=p[2])), class="htest")
        

        ### Maximum 
        if(result2$p.value < confidence.interval)
        {
          dell.value <- c(dell.value, result2$branch.length)
          x <- x[x!= result2$branch.length]
          next
        }
        ### Minimum 
        if(result1$p.value < confidence.interval)
        {
          dell.value <- c(dell.value, result1$branch.length)
          x <- x[x!= result1$branch.length]
          next
        }
        else{
          thresh <- min(dell.value)
          return(thresh)
          break	
        }
      }
}

f <- function(x) {x[4]/sum(x)}

featureCounts.info.name <- args[1]
featureCounts.info <- read.table(featureCounts.info.name,header=T,stringsAsFactors=F)
featureCounts.info$prop.noAssign <- apply(featureCounts.info[2:7],1,f)
thresh <- SG(featureCounts.info$prop.noAssign)
featureCounts.info.filtered <- featureCounts.info[featureCounts.info$prop.noAssign < thresh,]
featureCounts.info.filtered <- featureCounts.info.filtered[order(featureCounts.info.filtered$prop.noAssign,decreasing=T),]

data.exp.name <- args[2]
data.exp <- read.csv(data.exp.name,header=T,row.names=1,check.names=F)
data.exp <- data.exp[,colnames(data.exp) %in% featureCounts.info.filtered$file_Id]

featureCounts.info.out.name <- args[3]
write.table(featureCounts.info.filtered, featureCounts.info.out.name, col.names = T, row.names=F, sep = "\t", quote=F)

data.exp.out.name <- args[4]
write.csv(data.exp, data.exp.out.name, row.names=T, quote=F)



