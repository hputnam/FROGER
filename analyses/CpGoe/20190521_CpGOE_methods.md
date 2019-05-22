# Obtain Genome file
ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/022/765/GCF_002022765.2_C_virginica-3.0/GCF_002022765.2_C_virginica-3.0_genomic.fna.gz

# Obtain GFF file
ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/022/765/GCF_002022765.2_C_virginica-3.0/GCF_002022765.2_C_virginica-3.0_genomic.gff.gz


# Generating bed files for genomic features - Completed in R

library(GenomicFeatures)
library(rtracklayer)

#Cvirginica_txDB <- makeTxDbFromGFF(“~/CVirginica_genome/GCF_002022765.2_C_virginica-3.0_genomic.gff”, format=“gff3")
#saveDb(Cvirginica_txDB, file=“Cvirginica_txDB.sqlite”)

setwd(“~/FROGER/“)
Cvirginica_txDB <- loadDb(“Cvirginica_txDB.sqlite”)

Exons <- exons(Cvirginica_txDB,use.names=T)
CDS <- cds(Cvirginica_txDB,use.names=T)
gene <- genes(Cvirginica_txDB)

export(Exons, “GCF_002022765.2_C_virginica-3.0_genomic.exons.gff3", format = “GFF3”)
export(CDS, “GCF_002022765.2_C_virginica-3.0_genomic.CDS.gff3", format = “GFF3”)
export(gene, “GCF_002022765.2_C_virginica-3.0_genomic.genes.gff3", format = “GFF3”)

# Upload bed files to UW server
gannet.fish.washington.edu/spartina/2019-05-21-FROGER/

# Obtain feature level fasta files for all samples

## GENE

```
find ../*.fa \
| xargs basename -s .fa | xargs -I{} bedtools getfasta \
-fi ../{}.fa \
-bed GCF_002022765.2_C_virginica-3.0_genomic.genes.gff3 \
-fo {}_GENE.fa
```

## CDS

```
find ../*.fa \
| xargs basename -s .fa | xargs -I{} bedtools getfasta \
-fi ../{}.fa \
-bed GCF_002022765.2_C_virginica-3.0_genomic.CDS.gff3 \
-fo {}_CDS.fa
```

## EXONS

```
find ../*.fa \
| xargs basename -s .fa | xargs -I{} bedtools getfasta \
-fi ../{}.fa \
-bed GCF_002022765.2_C_virginica-3.0_genomic.exons.gff3 \
-fo {}_EXONS.fa
```

## CAP

```
find ../*.fa \
| xargs basename -s .fa | xargs -I{} bedtools getfasta \
-fi ../{}.fa \
-bed CAP_sorted.bed \
-fo {}_CAP.fa
```

## WINDOWS

```
find ../*.fa \
| xargs basename -s .fa | xargs -I{} bedtools getfasta \
-fi ../{}.fa \
-bed GCF_002022765.2_C_virginica.3.0_genomic.1kb_window_500bp_step.gff3 \
-fo {}_1kb_window_500bp_step.fa
```

GENE files hosted here: http://gannet.fish.washington.edu/spartina/2019-05-21-FROGER/GENE_CpGoe

CDS files hosted here: http://gannet.fish.washington.edu/spartina/2019-05-21-FROGER/CDS_CpGoe

EXONS files hosted here: http://gannet.fish.washington.edu/spartina/2019-05-21-FROGER/EXONS_CpGoe

CAP files hosted here: http://gannet.fish.washington.edu/spartina/2019-05-21-FROGER/CAP_CpGoe/

WINDOWS files hosted here: http://gannet.fish.washington.edu/spartina/2019-05-21-FROGER/WINDOWS_CpGoe/

# Calculate CpG Observed / Expected Ratio 

```
mkdir ${analyses_dir}
```

# Create arrays of all FastA files

```
fa_array=(${data_dir}/*{TYPE}.fa)

less
time \
for fa in "${fa_array[@]}"
do
  # Change to proper directory
  cd ${analyses_dir}
  # Remove file path and extension from the FastA and save as variable
  fn=$(basename ${fa} .fa)
  
  # Make subdirectory using filename
  mkdir ${fn}_analysis
  cd ${fn}_analysis
  
  # Use seqkit to convert FastA to tab-delimited and print sequence length 
  ${seqkit} fx2tab \
  --length \
  ${fa} \
  > ${fn}_tab
  
  # Print only sequences to new file
  gawk '{ print $2 }' ${fn}_tab > ${fn}_tab2
  
  # Delimit sequences on CGs and print the number of fields minus 1 to get the number of CGs present.
  gawk -F\[Cc][Gg] '{print NF-1}' ${fn}_tab2 > CG
  
  # Delimit sequences on CGs and print the number of fields minus 1 to get the number of Cs present.
  gawk -F\[Cc] '{print NF-1}' ${fn}_tab2 > C
  
  # Delimit sequences on CGs and print the number of fields minus 1 to get the number of Gs present.
  gawk -F\[Gg] '{print NF-1}' ${fn}_tab2 > G
  
  # Paste these together to have file with the following fields:
    # - FastA header
    # - Sequence
    # - Sequence length
    # - Number of CGs
    # - Number of Cs
    # - Number of Gs
  paste ${fn}_tab \
  CG \
  C \
  G \
  > comb
  
  # Do some math to calculate CpG O/E ratio (observed vs expected)
  gawk '{print $1, "\t", (($4)/($5*$6))*(($3^2)/($3-1))}' comb \
  > ID_CpG
done
```

GENE executable script: http://gannet.fish.washington.edu/spartina/2019-05-21-FROGER/GENE_CpGoe/

CDS executable script: http://gannet.fish.washington.edu/spartina/2019-05-21-FROGER/CDS_CpGoe/

EXONS executable script: http://gannet.fish.washington.edu/spartina/2019-05-21-FROGER/EXONS_CpGoe/

CAP executable script: http://gannet.fish.washington.edu/spartina/2019-05-21-FROGER/CAP_CpGoe/2019-05-22-CAP-Array-Script.sh

WINDOWS executable script: http://gannet.fish.washington.edu/spartina/2019-05-21-FROGER/WINDOWS_CpGoe/2019-05-22-WINDOWS-Array-Script.sh

## Append CpG oe to sample specific headers

#!/bin/bash

## Script to append sample-specific headers to each ID_CpG
## file and join all ID_CpG files.

## Run file from within this directory.

# Temp file placeholder
tmp=$(mktemp)

# Create array of subdirectories.
array=(*/)

# Create column headers for ID_CpG files using sample name from directory name.
for file in ${array[@]}
do
  gene=$(echo ${file} | awk -F\[._] '{print $6"_"$7}')
  sed "1iID\t${gene}" ${file}ID_CpG > ${file}ID_CpG_labelled
done

# Create initial file for joining
cp ${array[0]}ID_CpG_labelled ID_CpG_labelled_all

# Loop through array and performs joins.
for file in ${array[@]:1}
do
  join \
  --nocheck-order \
  ID_CpG_labelled_all ${file}ID_CpG_labelled \
  | column -t \
  > ${tmp} \
  && mv ${tmp} ID_CpG_labelled_all
done


