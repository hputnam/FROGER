
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
  dtemp <- dtemp[1,] #removes duplicate CAP genes that show the same mapping length to CpGoe genes
  df <- rbind(df,dtemp)
}


df$CpGoe_ID <- paste0(df$V5,":",df$V6,"-", df$V7)

#count the number of CAP_IDs in df
length(df$CAP_ID)
#count the number of unique CAP_IDs in df
length(unique(df$CAP_ID))

#merge with CpGoe
CpGoe <- read.table("~/Documents/GitHub/FROGER/analyses/CAP_CpGoe/ID_CpG_labelled_all", header = TRUE)
colnames(CpGoe)[1] <- "CpGoe_ID"

CAP_CpGoe <- merge(df, CpGoe, by = "CpGoe_ID")
STACKED_CAP_CpGoe <- CAP_CpGoe[,c(1,5,12:ncol(CAP_CpGoe))]
STACKED_CAP_CpGoe <- tidyr::gather(STACKED_CAP_CpGoe,"sample", "CpGoe", 3:92)
STACKED_CAP_CpGoe$population <- gsub("_.*","",STACKED_CAP_CpGoe$sample)


#make boxplot of CpGoe distributions in CAP genes by population
library(ggplot2)
g <- ggplot(STACKED_CAP_CpGoe, aes(population, CpGoe)) + geom_boxplot(aes(fill = population)) +theme_bw()
ggsave("~/Documents/GitHub/FROGER/analyses/CAP_CpGoe/CAP_CpGoe_genes_by_pop_boxplot.jpg",g)


#plot heatmap of CpGoe for CAP genes by population
library(heatmap3)
hm_df <- CAP_CpGoe[,c(12:ncol(CAP_CpGoe))]
rownames(hm_df) <- CAP_CpGoe$CAP_ID
heatmap3(hm_df)

#got error message because some genes have SD = 0 across all samples

#need to find which genes these are 
CAP_CpGoe_SD <- CAP_CpGoe[,c(11:ncol(CAP_CpGoe))]
CAP_CpGoe_SD$SD <- apply(CAP_CpGoe_SD[,-1],1,sd)

CAP_CpGoe_SD_not_zero <- CAP_CpGoe_SD[which(CAP_CpGoe_SD$SD != 0),-c(1,92)]
rownames(CAP_CpGoe_SD_not_zero) <- CAP_CpGoe_SD[which(CAP_CpGoe_SD$SD != 0),"CAP_ID"]

heatmap3(CAP_CpGoe_SD_not_zero, scale = "none")

#try log transforming CpGoe ratios
CAP_CpGoe_SD_not_zero_log <- log(CAP_CpGoe_SD_not_zero,2)
heatmap3(CAP_CpGoe_SD_not_zero_log)

# look at distributions of CpGoe ratios
STACKED_CAP_CpGoe_SD_not_zero <- CAP_CpGoe_SD_not_zero
STACKED_CAP_CpGoe_SD_not_zero$CAP_ID <- rownames(CAP_CpGoe_SD_not_zero)
STACKED_CAP_CpGoe_SD_not_zero <- tidyr::gather(STACKED_CAP_CpGoe_SD_not_zero, "sample", "CpGoe", 1:90)
STACKED_CAP_CpGoe_SD_not_zero$population <- gsub("_.*","",STACKED_CAP_CpGoe_SD_not_zero$sample)

ggplot(STACKED_CAP_CpGoe_SD_not_zero) + geom_density(aes(CpGoe,group = sample)) + facet_wrap(~population) 

#
exclude
