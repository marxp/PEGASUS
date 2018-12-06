options(warn=-1)

packs2install<-c()
if(!require("CompQuadForm")){
  packs2install<-c(packs2install,"CompQuadForm")
}

if(!require("corpcor")){
  packs2install<-c(packs2install,"corpcor")
}

if(!require("data.table")){
  packs2install<-c(packs2install,"data.table")
}

if(!require("optparse")){
  packs2install<-c(packs2install,"optparse")
}

if(length(packs2install)>0){
  install.packages(packs2install)
}
