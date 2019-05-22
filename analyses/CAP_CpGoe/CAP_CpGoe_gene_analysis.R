
#read in data
CAP_bed_out <- read.csv("~/Documents/GitHub/FROGER/analyses/CAP_CpGoe/CAP_CpGoe_bed_intersect.out", header = FALSE,sep = "\t")

#create CAP ID column
CAP_bed_out$CAP_ID <- paste0(CAP_bed_out$V1,":",CAP_bed_out$V2,"-",CAP_bed_out$V3)

#remove the CAP coordinates with no overlap
CAP_bed_out <- CAP_bed_out[which(CAP_bed_out$V9 != 0),]

#make a  list of unique CAP_IDs
CAPids <- unique(CAP_bed_out$CAP_ID)

#count how many unique cap IDs there are
length(CAPids)

#create empty data frame
df <- data.frame()
#loop through positions and pick the best mapped
for(i in (1:length(CAPids))){
  d <- CAP_bed_out[grep(CAPids[i], CAP_bed_out$CAP_ID),]
  max <- max(d$V9)
  dtemp <- d[which(d$V9 == max),]
  df <- rbind(df,dtemp)
}


df$CpGoe_ID <- paste0(df$V5,":",df$V6,"-", df$V7)

#merge with CpGoe
CpGoe <- read.table("~/Documents/GitHub/FROGER/analyses/CAP_CpGoe/ID_CpG_labelled_all", header = TRUE)
colnames(CpGoe)[1] <- "CpGoe_ID"

CAP_CpGoe <- merge(df, CpGoe, by = "CpGoe_ID")
STACKED_CAP_CpGoe <- CAP_CpGoe[,c(1,5,12:ncol(CAP_CpGoe))]
STACKED_CAP_CpGoe <- tidyr::gather(STACKED_CAP_CpGoe,"sample", "CpGoe", 3:92)
STACKED_CAP_CpGoe$population <- gsub("_.*","",STACKED_CAP_CpGoe$sample)


library(ggplot2)
g <- ggplot(STACKED_CAP_CpGoe, aes(population, CpGoe)) + geom_boxplot(aes(fill = population)) +theme_bw()
ggsave("~/Documents/GitHub/FROGER/analyses/CAP_CpGoe/CAP_CpGoe_genes_by_pop_boxplot.jpg",g)
