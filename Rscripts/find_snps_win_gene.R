options(warn=-1)
rm(list = ls(all = TRUE))
library(data.table)
library(optparse)

input_args <- commandArgs()

arg_list <- list(
  make_option("--start",type="integer"),
  make_option("--stop",type="integer")
)

parsed_args <- parse_args(OptionParser(option_list=arg_list),args = input_args)

ld <- fread('temptempld', header = F, colClasses=c('integer','integer', 'character', 'integer', 'integer', 'character', 'numeric'))
colnames(ld) <- c('CHR_A','BP_A','SNP_A','CHR_B','BP_B','SNP_B','R')
ld <- ld[which(ld[,2]>=parsed_args$start & ld[,2]<=parsed_args$stop),]
ld <- ld[which(ld[,5]>=parsed_args$start & ld[,5]<=parsed_args$stop),]

if (nrow(ld) >=1) {
	snps <- unique(c(ld[,3], ld[,6]))
	temppvals <- fread('temppvals', header = F, colClasses = c('character', 'numeric'))
	snpps <- temppvals[which(temppvals[,1] %in% snps),]

	if (nrow(snpps)==1) {
		fwrite(snpps, 'tempgene.pvalue', row.names=F,col.names=F, quote = F)
		system('echo 1 > ld.ld')
	}
	if (nrow(snpps) > 1) {
		fwrite(snpps, 'tempgene.pvalue', row.names=F,col.names=F, quote = F)
		ld = ld[,c(3,6,7)]
		dummy = as.data.frame(cbind(snps, snps, rep(1.0, length(snps))))
		colnames(dummy)<- names(ld)
		ld = rbind(ld, dummy)
		ldmat = reshape(ld, direction='wide', timevar = 'SNP_B', idvar = 'SNP_A')
		ldmat = ldmat[order(match(ldmat[,1], snpps[,1])),] #change row order
		rownames(ldmat) = ldmat[,1]
		ldmat = ldmat[,-1]
		ldmat = ldmat[,order(match(names(ldmat), paste('R.', snpps[,1], sep = '')))]# change column order to make (upper) triangular matrix
		ldmat[is.na(ldmat)] <- 0.0
		ldmat[ldmat == 'NaN'] <- 0.0
		ldmat = apply(ldmat, 1, as.numeric)

		if (isSymmetric(unname(as.matrix(ldmat))) == FALSE) {
  			ldmat = ldmat+ t(ldmat)
  			diag(ldmat) <- 1.0
		}
		fwrite(ldmat, 'ld.ld', row.names=F,col.names=F, quote = F)
	}
}
