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
jpeg("~/GitHub/FROGER_methylKit/analyses/QiaCompare/RvMvW_correlationplot.jpg", width = 1000, height = 600)
getCorrelation(meth,plot=TRUE)
dev.off()

#########RRBS v WGBS
RvW_file.list <- list("/home/srlab/FROGER/Extracted/RRBS_extr/RRBS_R1.trimmed_bismark_bt2_pe.bismark_reformcov.txt", 
                      "/home/srlab/FROGER/Extracted/WGBS_extr/WGBS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_reformcov.txt") 
RvW_myobj<-read( RvW_file.list,pipeline=list(fraction=TRUE,chr.col=2,start.col=3,end.col=3,
                                             coverage.col=5,strand.col=4,freqC.col=6 ),
                 sample.id=list("RRBS", "WGBS"),assembly="French",
                 treatment=c(0,1))

#################FILTERING###########################
RvW_filtered.myobj=filterByCoverage(RvW_myobj,lo.count=5)

#################UNITE##############################
RvW_meth<-unite(RvW_filtered.myobj)
nrow(RvW_meth)
head(RvW_meth)
jpeg("~/GitHub/FROGER_methylKit/analyses/QiaCompare/RvWcorrelationplot.jpg", width = 1000, height = 600)
getCorrelation(RvW_meth,plot=TRUE)
dev.off()

#########RRBS v MBD
RvM_file.list <- list("/home/srlab/FROGER/Extracted/RRBS_extr/RRBS_R1.trimmed_bismark_bt2_pe.bismark_reformcov.txt", 
                  "/home/srlab/FROGER/Extracted/MBD_BS_extr/MBD_BS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_reformcov.txt") 
RvM_myobj<-read( RvM_file.list,pipeline=list(fraction=TRUE,chr.col=2,start.col=3,end.col=3,
                                     coverage.col=5,strand.col=4,freqC.col=6 ),
             sample.id=list("RRBS", "MBD"),assembly="French",
             treatment=c(0,1))

#################FILTERING###########################
RvM_filtered.myobj=filterByCoverage(RvM_myobj,lo.count=5)

#################UNITE##############################
RvM_meth<-unite(RvM_filtered.myobj)
nrow(RvM_meth)
head(RvM_meth)
jpeg("~/GitHub/FROGER_methylKit/analyses/QiaCompare/RvMcorrelationplot.jpg", width = 1000, height = 600)
getCorrelation(RvM_meth,plot=TRUE)
dev.off()

#########WGBS v MBD
WvM_file.list <- list("/home/srlab/FROGER/Extracted/WGBS_extr/WGBS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_reformcov.txt",
                  "/home/srlab/FROGER/Extracted/MBD_BS_extr/MBD_BS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_reformcov.txt") 
WvM_myobj<-read( WvM_file.list,pipeline=list(fraction=TRUE,chr.col=2,start.col=3,end.col=3,
                                     coverage.col=5,strand.col=4,freqC.col=6 ),
             sample.id=list("WGBS", "MBD"),assembly="French",
             treatment=c(0,1))

#################FILTERING###########################
WvM_filtered.myobj=filterByCoverage(WvM_myobj,lo.count=5)

#################UNITE##############################
WvM_meth<-unite(WvM_filtered.myobj)
nrow(WvM_meth)
head(WvM_meth)
jpeg("~/GitHub/FROGER_methylKit/analyses/QiaCompare/WvM_correlationplot.jpg", width = 1000, height = 600)
getCorrelation(WvM_meth,plot=TRUE)
dev.off()

