library(methylKit)

file.list <- list("/home/srlab/FROGER/Extracted/RRBS_extr/RRBS_R1.trimmed_bismark_bt2_pe.bismark_reformcov.txt", 
                  "/home/srlab/FROGER/Extracted/WGBS_extr/WGBS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_reformcov.txt",
                  "/home/srlab/FROGER/Extracted/MBD_BS_extr/MBD_BS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_reformcov.txt") 
myobj<-read( file.list,pipeline=list(fraction=TRUE,chr.col=2,start.col=3,end.col=3,
                                     coverage.col=5,strand.col=4,freqC.col=6 ),
             sample.id=list("RRBS", "WGBS", "MBD"),assembly="French",
             treatment=c(0,1,1))

############QC##############
#can run these on individual samples by changing the sample # in the brackets --looking for PCR bias at right hand of plot, also get mean coverage for each sample (prior to normalization)
getCoverageStats(myobj[[1]], plot=T,both.strands=F)
getCoverageStats(myobj[[2]], plot=T,both.strands=F)
getCoverageStats(myobj[[3]], plot=T,both.strands=F)

getMethylationStats(myobj[[1]],plot=TRUE,both.strands=FALSE)
getMethylationStats(myobj[[2]],plot=TRUE,both.strands=FALSE)
getMethylationStats(myobj[[3]],plot=TRUE,both.strands=FALSE)

#################FILTERING###########################
filtered.myobj=filterByCoverage(myobj,lo.count=5)

#################UNITE##############################
meth<-unite(filtered.myobj)
nrow(meth)
head(meth)
getCorrelation(meth,plot=TRUE)
