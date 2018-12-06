options(warn=-1)
library(data.table)
isnumeric <- function(s) !is.na(as.numeric(s))
pvals <- fread('temppvals',header=F,colClasses=c('character','numeric'))
isnumber <- ifelse(isnumeric(pvals[,2]),0,1)

if(sum(isnumber) > 0){
	fwrite(pvals[which(isnumber==1),],'temp',row.names=F,col.names=F,quote=F)
}
notpvalue<- ifelse(pvals[,2]<0 | pvals[,2] > 1,1,0)
if(sum(notpvalue) > 0 | is.na(sum(notpvalue))){
	fwrite(pvals[which(notpvalue==1),],'invalid-pvalues',row.names=F,col.names=F,quote=F)
}
