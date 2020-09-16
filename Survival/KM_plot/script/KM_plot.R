#!/usr/bin/env R

library(survival)
library(survminer)

args <- commandArgs(trailingOnly = T)

####reading data####
survival.info.name <- args[1]
survival.info <- read.table(survival.info.name,header=T)

data.gsva.name <- args[2]
data.gsva <- read.csv(data.gsva.name,header=T,row.names=1,check.names=F)


####merging data####
gsva.interest.df <- data.frame(sample_Id = colnames(data.gsva),
                               KRAB = as.numeric(scale(as.numeric(data.gsva[rownames(data.gsva) == "KRAB__interPro",]))),
                               HERV = as.numeric(scale(as.numeric(data.gsva[rownames(data.gsva) == "HERV",])))
                               )

gsva.interest.df.merged <- merge(gsva.interest.df,survival.info,by="sample_Id")
gsva.interest.df.merged$mean <- apply(gsva.interest.df.merged[,2:3],1,mean)


#####categorization by expresssion####
q.upper.krab <- as.numeric(quantile(gsva.interest.df.merged$mean,0.66))
q.lower.krab <- as.numeric(quantile(gsva.interest.df.merged$mean,0.33))


gsva.interest.df.merged$class.expression <- ifelse(gsva.interest.df.merged$mean > q.upper.krab,'High',
                                 ifelse(gsva.interest.df.merged$mean < q.lower.krab,'Low',
                                 "Medium"
                                 ))


out.name <- args[3]
write.table(gsva.interest.df.merged,out.name,col.names=T,row.names=F,sep="\t",quote=F)

gsva.interest.df.merged <- gsva.interest.df.merged[gsva.interest.df.merged$class.expression != "Medium",]
gsva.interest.df.merged$class.expression <- factor(gsva.interest.df.merged$class.expression,levels=c('Low','High'))


#####doing survfit####

fit.km <- do.call(survfit,
                  list(
                      formula = Surv(time, status == 1) ~ class.expression,
                      data = gsva.interest.df.merged
                      )
                  )


print(summary(summary(fit.km)))



#####drawing KM plot####

pdf.name <- args[4]

pdf(pdf.name,width=2.75,height=4)

ggsurvplot(fit.km,
           pval=T,
           pval.method=T,
           risk.table=F,
           legend.title = "Expression",
           legend.labs= c("Low","High"),
           palette=c("#0068b7","#f39800"),
           xlim=c(0,4000)
           )

dev.off()


