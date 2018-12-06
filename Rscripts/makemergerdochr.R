options(warn=-1)
library(data.table)
#read in GWAS results
pvals <- fread('temppvals',header=F,colClasses=c('character','numeric'))
colnames(pvals) <- c('SNP','PVALUE')

#read in start/stop positions for each gene
startstop <- read.table('$chip/glist-hg19',colClasses=c('character',rep('integer',2),'character'))
colnames(startstop) <- c('chr','start','stop','gene')

#read in which SNPs map to which gene
wp <- fread('$chip/geneset/snpgene$dochr',colClasses=c('character','character'))
colnames(wp) <- c('gene','rs')

wp <- merge(startstop,wp,by='gene',all.y=T)

#convert p-values to chi2-df1 stats
chi2<- qchisq(pvals[,2],1,lower.tail=F)
chi2withrs <- data.table('SNP'=pvals[,1],'chisq'=chi2)

mer <- merge(wp,chi2withrs,by.x='rs',by.y='SNP')

fwrite(mer,file='merged$dochr',row.names=F,quote=F)
