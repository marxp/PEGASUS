options(warn=-1)
library(data.table)
pvals <- fread('tempgene.pvalue',header=F, colClasses = c('character', 'numeric'))
pvals = pvals[order(pvals[,1]),]
positions <- fread('gene.position',header=F)
tempgene <- data.table(pvals[,1],rep(positions[,4],length(pvals[,1])),rep(positions[,1],length(pvals[,1])),rep(positions[,2],length(pvals[,1])),rep(positions[,3],length(pvals[,1])),qchisq(pvals[,2],1,lower.tail=F))
fwrite(tempgene,'tempgene',row.names=F,col.names=F,quote=F)
