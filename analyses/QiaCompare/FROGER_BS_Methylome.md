# Qiagen WGBS MBD-BS and RRBS data

Bismark Bisulfite Mapper V0.18.2 “ map bisulfite treated sequencing reads to a genome of interest and perform methylation calls in a single step”

Bismark: a flexible aligner and methylation caller for Bisulfite-Seq applications

requires bowtie2, samtools, perl

* Bowtie 2 version 2.27.1 by Ben Langmead (langmea@cs.jhu.edu, www.cs.jhu.edu/~langmea)
* Program: samtools (Tools for alignments in the SAM format)
Version: 0.1.19-44428cd
* perl v5.14.2 
* Bismark Bisulfite Mapper V0.18.2 2016-03-01 


mkdir FROGER
cd FROGER
mkdir RAW
cd RAW
wget http://gannet.fish.washington.edu/seashell/snaps/Archive.zip
cd ..

## Obtain Genome file
mkdir GENOME
cd GENOME
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/022/765/GCF_002022765.2_C_virginica-3.0/GCF_002022765.2_C_virginica-3.0_genomic.fna.gz

mv GENOME/GCF_002022765.2_C_virginica-3.0_genomic.fna.gz GENOME/GCF_002022765.2_C_virginica-3.0_genomic.fa.gz

## Run Bismark Genome preparation
#### C. virginica Genome v3.0
/home/shared/Bismark-0.19.1/bismark_genome_preparation GENOME





## Count raw reads
```cd ~/Mcap_WGBS/Genome_Compare```

```zgrep -c "@D00796" W*.fastq.gz```

* W5_S1_L001_R1_001.fastq.gz:93825967
* W5_S1_L001_R2_001.fastq.gz:93825967
* W19_S2_L001_R1_001.fastq.gz:83342363
* W19_S2_L001_R2_001.fastq.gz:83342363

## QC Raw Data 
```mkdir ~/Mcap_WGBS/Genome_Compare/Raw_QC_Files```

```nohup ~/programs/FastQC/fastqc /home/hputnam/Mcap_WGBS/Samples/*.fastq.gz -o ~/Mcap_WGBS/Genome_Compare/Raw_QC_Files```

```cd ~/Mcap_WGBS/Genome_Compare```

## Trim Adapters
* cutadapt 1.11 with Python 2.7.0

``mkdir Trimmed``
``cd Trimmed``

Command line parameters: -q 30 -m 21 -a AGATCGGAAGAGC -A AGATCGGAAGAGC -o W5_R1.trimmed.fq.gz -p W5_R2.trimmed.fq.gz W5_R1_PF.fastq.gz W5_R2_PF.fastq.gz

```nohup ~/programs/cutadapt-1.8.3/bin/cutadapt -a AGATCGGAAGAGC -q 30 -o ~/Mcap_WGBS/Genome_Compare/Trimmed/W5_R1.trimmed.fastq.gz ~/Mcap_WGBS/Samples/W5_S1_L001_R1_001.fastq.gz```

```nohup ~/programs/cutadapt-1.8.3/bin/cutadapt -a AGATCGGAAGAGC -q 30 -o ~/Mcap_WGBS/Genome_Compare/Trimmed/W5_R2.trimmed.fastq.gz ~/Mcap_WGBS/Samples/W5_S1_L001_R2_001.fastq.gz >> nohup2.out&```

```nohup ~/programs/cutadapt-1.8.3/bin/cutadapt -a AGATCGGAAGAGC -q 30 -o ~/Mcap_WGBS/Genome_Compare/Trimmed/W19_R1.trimmed.fastq.gz ~/Mcap_WGBS/Samples/W19_S2_L001_R1_001.fastq.gz >> nohup3.out&```

```nohup ~/programs/cutadapt-1.8.3/bin/cutadapt -a AGATCGGAAGAGC -q 30 -o ~/Mcap_WGBS/Genome_Compare/Trimmed/W19_R2.trimmed.fastq.gz ~/Mcap_WGBS/Samples/W19_S2_L001_R2_001.fastq.gz >> nohup4.out&```

## Count Trimmed reads

```zgrep -c "@D00796" ~/Mcap_WGBS/Genome_Compare/Trimmed/W*.fastq.gz```

* W5_R1.trimmed.fastq.gz:93825967
* W5_R2.trimmed.fastq.gz:93825967
* W19_R1.trimmed.fastq.gz:83342363
* W19_R2.trimmed.fastq.gz:83342363 

```cd ~/Mcap_WGBS/Genome_Compare```

## QC Trimmed and Quality Filtered Data

```mkdir Trimmed_QC_Files```
```cd Trimmed_QC_Files```

```nohup ~/programs/FastQC/fastqc ~/Mcap_WGBS/Genome_Compare/Trimmed/W*.fastq.gz -o ~/Mcap_WGBS/Genome_Compare/Trimmed_QC_Files```

```cd ~/Mcap_WGBS/Genome_Compare```

## Pool Samples to run combined
concatenate all Read 1 and all Read 2 for a generic methylome of both samples to determine mapping and coverage

```cat ~/Mcap_WGBS/Genome_Compare/Trimmed/W5_R1.trimmed.fastq.gz ~/Mcap_WGBS/Genome_Compare/Trimmed/W19_R1.trimmed.fastq.gz > R1.trimmed.fastq.gz```

```cat ~/Mcap_WGBS/Genome_Compare/Trimmed/W5_R2.trimmed.fastq.gz ~/Mcap_WGBS/Genome_Compare/Trimmed/W19_R2.trimmed.fastq.gz > R2.trimmed.fastq.gz```
 
## Map data to converted genome

```mkdir Mapped```
```cd Mapped```

### Optimizing Mapping
Option 0
```nohup ~/programs/Bismark-0.18.2/bismark --genome ~/Mcap_WGBS/Mcap_Genome/ -1 ~/Mcap_WGBS/Genome_Compare/Trimmed/W5_R1.trimmed.fastq.gz -2 ~/Mcap_WGBS/Genome_Compare/Trimmed/W5_R2.trimmed.fastq.gz``` 

W5 = 27.4%

###### Option 1
```nohup ~/programs/Bismark-0.18.2/bismark --genome ~/Mcap_WGBS/Mcap_Genome/ --bowtie2 --score_min L,0,-0.6 -1 ~/Mcap_WGBS/Genome_Compare/Trimmed/W5_R1.trimmed.fastq.gz -2 ~/Mcap_WGBS/Genome_Compare/Trimmed/W5_R2.trimmed.fastq.gz -p 12 --bam```

* W5 = 62.8% mapping

```nohup ~/programs/Bismark-0.18.2/bismark --genome ~/Mcap_WGBS/Mcap_Genome/ --bowtie2 --score_min L,0,-0.6 -1 ~/Mcap_WGBS/Genome_Compare/Trimmed/W19_R1.trimmed.fastq.gz -2 ~/Mcap_WGBS/Genome_Compare/Trimmed/W19_R2.trimmed.fastq.gz -p 12 --bam >> nohup2.out&```

Option 2
```nohup ~/programs/Bismark-0.18.2/bismark --genome ~/Mcap_WGBS/Mcap_Genome/ --bowtie2 --score_min L,0,-0.9 -1 ~/Mcap_WGBS/Genome_Compare/Trimmed/W5_R1.trimmed.fastq.gz -2 ~/Mcap_WGBS/Genome_Compare/Trimmed/W5_R2.trimmed.fastq.gz -p 12 --bam```

65.9 % mapping

#### moved forward with mapping option 1

#### Concatenated Sample Mapping
```nohup ~/programs/Bismark-0.18.2/bismark --genome ~/Mcap_WGBS/Mcap_Genome/ --bowtie2 --score_min L,0,-0.6 -1 ~/Mcap_WGBS/Genome_Compare/Trimmed/R1.trimmed.fastq.gz -2 ~/Mcap_WGBS/Genome_Compare/Trimmed/R2.trimmed.fastq.gz -p 12 --bam```

* mapping = 63.2%

***Bismark report for: /home/hputnam/Mcap_WGBS/Genome_Compare/Trimmed/R1.trimmed.fastq.gz and /home/hputnam/Mcap_WGBS/Genome_Compare/Trimmed/R2.trimmed.fastq.gz (version: v0.18.2)
Bismark was run with Bowtie 2 against the bisulfite genome of /home/hputnam/Mcap_WGBS/Mcap_Genome/ with the specified options: -q --score-min L,0,-0.6 -p 12 --reorder --ignore-quals --no-mixed --no-discordant --dovetail --maxins 500
Option '--directional' specified (default mode): alignments to complementary strands (CTOT, CTOB) were ignored (i.e. not performed)***


```cd ~/Mcap_WGBS/Genome_Compare```

## Deduplicate Data

```mkdir DeDup```
```cd Dedup```

```nohup ~/programs/Bismark-0.18.2/deduplicate_bismark ~/Mcap_WGBS/Genome_Compare/Mapped/R1.trimmed_bismark_bt2_pe.bam >> nohup2.out&```

* retained 98.76%

```cd ~/Mcap_WGBS/Genome_Compare```

## Calculate number of CpG in the genome

```grep -v '>' ~/Mcap_WGBS/Mcap_Genome/20170313.mcap.falcon.errd.fasta | grep -o -i 'CG' | wc -l```

* number of CG's in the assembled genome
28,197,926

## Genome-Wide Extraction
```mkdir Extracted```
```cd Extracted```
```mkdir GWideExt```
```cd GWideExt```

```nohup ~/programs/Bismark-0.18.2/bismark_methylation_extractor --gzip -p --ignore_r2 2 --scaffolds --bedGraph --zero_based --no_overlap --multicore 20 --buffer_size 20G --cytosine_report --report --genome_folder ~/Mcap_WGBS/Mcap_Genome/ ~/Mcap_WGBS/Genome_Compare/DeDup/R1.trimmed_bismark_bt2_pe.deduplicated.sam >> nohup2.out&```


###Final Cytosine Methylation Report
Item | Concatenated Sample | 
--- | --- | --- |
Total number of C's analysed: |3,837,580,169 | 
Total methylated C's in CpG context:  |91937387 |  
Total methylated C's in CHG context:  | 9702693|  
Total methylated C's in CHH context:  | 57764776|  
Total C to T conversions in CpG context:      |538395499 |  
Total C to T conversions in CHG context:      | 652173321| 
Total C to T conversions in CHH context:      | 2487606493|  
C methylated in CpG context:  | 14.6% |
C methylated in CHG context:  | 1.5% |  
C methylated in CHH context:  | 2.3% | 

### Genome wide C methylation
R1.trimmed_bismark_bt2_pe.deduplicated.CpG_report.txt.gz

```zcat R1.trimmed_bismark_bt2_pe.deduplicated.CpG_report.txt.gz > All.CpG_report.txt```

```wc -l All.CpG_report.txt```
57,350,516

* get + strand only
 
```cat   All.CpG_report.txt | awk '$3 == "+"' > All.1x.CpG_report.txt```

* using the number of CpG from the Bismark report at total CpG number

Number of CpG sequenced at least 1x
```cat All.1x.CpG_report.txt | awk '($5 > 0)' > All.1x.cov.CpG_report.txt```
```wc -l All.1x.cov.CpG_report.txt```
28,675,303

###### what % of the genome do we have 1x CpG data for?
* Percent of CpGs examined with 1x coverage relative to CpG in the genome 
* 23,005,578 /28,675,303 = 80%

### Filter by read counts

###### What % of the CpGs genome do we have 10x coverage data for?
* add methylated and unmethylated reads and print to column 
* place start and stop of methylation call location on single C base, not CG
* filter by total read counts >10

```awk -F"\t" '{print $1"\t"$2"\t"$2"\t"$4"\t"$5"\t"$5+$6}' All.1x.CpG_report.txt | awk '($6 >= 10)' > All.10x.cov.CpG.report.txt```

```wc -l All.10x.cov.CpG.report.txt```

* Percent of CpGs examined with 10x coverage relative to CpG in the genome 
* 12,202,854 /28,675,303 = 42.6% in Concatenated Samples

###### What % of the CpGs genome do we have 5x coverage data for?

```awk -F"\t" '{print $1"\t"$2"\t"$2"\t"$4"\t"$5"\t"$5+$6}' All.1x.CpG_report.txt | awk '($6 >= 5)' > All.5x.cov.CpG.report.txt```

```wc -l All.5x.cov.CpG.report.txt```
* Percent of CpGs examined with 5x coverage relative to CpG in the genome 
* 16895894 /28,675,303 = 58.9% in Concatenated Samples


###### Count CpGs that were methylated (column4 =1)

```cat All.5x.cov.CpG.report.txt | awk '($4 >= 1)' > All.Meth5x.cov.CpG.report.txt```

```wc -l All.Meth5x.cov.CpG.report.txt```

* CpG methylyated with 5 or more reads
* 5414350

* Percent of methylated CpGs  with 5x coverage relative to CpG in the genome 
* 5414350 /28,675,303 = 18.8%

* Percent of methylated CpGs  with 5x coverage relative to all bases in the genome 
* number of bases in genome
* 885,704,498
* number of methylated C in CpG context with 5 read count 
* 5414350/885,704,498
* Total Genome % methylation determined with 5x filter = 0.06% of total genome

```cd ~/Mcap_WGBS/Genome_Compare```

## Compare to genome tracks

```mkdir Intersection```
```cd Intersection```

#### Intersection with genes

###### whats is the total number of genic bases?

```grep -P "\tgene\t" ~/Mcap_WGBS/Genome_Compare/Tracks/mcap.all.removed.final.bed |  perl -lane '$s += $F[2]-$F[1]; END{print $s}'```

* total genic bases
* 411455789

###### what proportion of methylated bases are found in genes (relative to total CpG in the genome)?

* Generate a gene track
```awk '($8 == "gene")' ~/Mcap_WGBS/Genome_Compare/Tracks/mcap.all.removed.final.bed > genes.bed```

* Intersect the gene track with the 5x methylation track
```~/programs/bedtools2/bin/intersectBed -a ~/Mcap_WGBS/Genome_Compare/Tracks/genes.bed  -b ~/Mcap_WGBS/Genome_Compare/Extracted/GWideExt/All.Meth5x.cov.CpG.report.txt > meth.genes.intersect```

```wc -l meth.genes.intersect```
2,441,048 meth.genes.intersect

* %CpG methylation with 5x coverage in genic region relative to total CpG in the genome
* 2441048/5414350 = 45.1%
* ~45% of methylated CpGs are found within gene regions

#### Intersection with introns

###### whats is the total number intron bases?

```grep -P "\tintron\t" ~/Mcap_WGBS/Genome_Compare/Tracks/mcap.all.removed.final.bed |  perl -lane '$s += $F[2]-$F[1]; END{print $s}'```

337982460

* Generate an intron track
```awk '($8 == "intron")' ~/Mcap_WGBS/Genome_Compare/Tracks/mcap.all.removed.final.bed > introns.bed```

* Intersect the intron track with the 5x methylation track
```~/programs/bedtools2/bin/intersectBed -a ~/Mcap_WGBS/Genome_Compare/Tracks/introns.bed  -b ~/Mcap_WGBS/Genome_Compare/Extracted/GWideExt/All.Meth5x.cov.CpG.report.txt > meth.intron.intersect```

```wc -l meth.intron.intersect```
 1959806 meth.intron.intersect

* %CpG methylation with 5x coverage in intron regions relative to total CpG in genes
* intron/genic bases
* 1959806/2441048 = 80.3%
* ~80% of the methylated CpGs found in genes are in introns

#### Intersection with exons

* total number of exon bases

```grep -P "\tCDS\t" mcap.all.removed.final.bed |  perl -lane '$s += $F[2]-$F[1]; END{print $s}'```

73464001

* Generate an exon track
```awk '($8 == "CDS")' ~/Mcap_WGBS/Genome_Compare/Tracks/mcap.all.removed.final.bed > exons.bed```

* Intersect the exon track with the 5x methylation track
```~/programs/bedtools2/bin/intersectBed -a ~/Mcap_WGBS/Genome_Compare/Tracks/exons.bed -b ~/Mcap_WGBS/Genome_Compare/Extracted/GWideExt/All.Meth5x.cov.CpG.report.txt > meth.exon.intersect```

```wc -l meth.exon.intersect```

* %CpG methylation with 5x coverage in exon regions relative to total CpG in genes
* intron/genic bases
* 482673/2441048 = 19.7%
* ~20% of the methylated CpGs found in genes are in introns 


#### Intersection with Intergenic

###### whats is the total number of intergenic bases?

```grep -P "\tintergenic\t" ~/Mcap_WGBS/Genome_Compare/Tracks/mcap.all.removed.final.bed |  perl -lane '$s += $F[2]-$F[1]; END{print $s}'```

471925422

* Generate an intergenic track
```awk '($8 == "intergenic")' ~/Mcap_WGBS/Genome_Compare/Tracks/mcap.all.removed.final.bed > intergenic.bed```

* Intersect the intergenic track with the 5x methylation track
```~/programs/bedtools2/bin/intersectBed -a ~/Mcap_WGBS/Genome_Compare/Tracks/intergenic.bed -b ~/Mcap_WGBS/Genome_Compare/Extracted/GWideExt/All.Meth5x.cov.CpG.report.txt  > meth.intergenic.intersect```

```wc -l meth.intergenic.intersect```
2968765 meth.intergenic.intersect

* %CpG methylation with 5x coverage in intergenic region
* 2968765/5414350 = 54.8%

* %CpG methylation with 5x coverage in intergenic region relative to total CpG in the genome
* 2968765/5414350 = 54.8%
* ~55% of methylated CpGs are found within intergenic regions


#### Intersection with SCORs
```awk < ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed '{print $10}' | sort | uniq -c | wc -l```

cat ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed | perl -lane '$s += $F[2]-$F[1]; END{print $s}'

* count all the bases within scors
417,811,841 

* Intersect the scors track with the 5x methylation track
```~/programs/bedtools2/bin/intersectBed -a ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed -b ~/Mcap_WGBS/Genome_Compare/Extracted/GWideExt/All.Meth5x.cov.CpG.report.txt  > meth.SCORS.intersect```

```wc -l meth.SCORS.intersect```


* % methylated CpGs in scors
2830135/417,811,841 = 0.6%



##### Intersection of SCORs with Features
How are the SCORS distributed wrt features?

InterGenic
* Intersect the intergenic track with the scors track
```~/programs/bedtools2/bin/intersectBed -a ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed -b ~/Mcap_WGBS/Genome_Compare/Tracks/intergenic.bed > intergenic.SCORS.intersect```

intergenic.SCORS.intersect

cat ~/Mcap_WGBS/Genome_Compare/Intersection/intergenic.SCORS.intersect | perl -lane '$s += $F[2]-$F[1]; END{print $s}'

* % SCORs intersect with intergenic regions
* 253843222/471925422 = 53.8%
* ~54% of the bases in the intergenic region are scors

Genic
```~/programs/bedtools2/bin/intersectBed -a ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed -b ~/Mcap_WGBS/Genome_Compare/Tracks/genes.bed > genes.SCORS.intersect```

cat ~/Mcap_WGBS/Genome_Compare/Intersection/genes.SCORS.intersect | perl -lane '$s += $F[2]-$F[1]; END{print $s}'

* % SCORs intersect with gene regions
* 162506973/411455789 = 39.5%
* ~39.5% of the bases in the genic region are scors


Intron
```~/programs/bedtools2/bin/intersectBed -a ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed -b ~/Mcap_WGBS/Genome_Compare/Tracks/introns.bed > introns.SCORS.intersect```

cat ~/Mcap_WGBS/Genome_Compare/Intersection/introns.SCORS.intersect | perl -lane '$s += $F[2]-$F[1]; END{print $s}'

* % SCORs intersect with intron regions
*  160406516/337982460 = 47.5%
* ~47% of the bases in the intron region are scors

Exons
```~/programs/bedtools2/bin/intersectBed -a ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed -b ~/Mcap_WGBS/Genome_Compare/Tracks/exons.bed > exons.SCORS.intersect```

cat ~/Mcap_WGBS/Genome_Compare/Intersection/exons.SCORS.intersect | perl -lane '$s += $F[2]-$F[1]; END{print $s}'

* % SCORs intersect with exon regions
*  2100201/73464001 = 2.9%
* ~3% of the bases in the exon region are scors



#### Are SCORs in Genic regions more methylated than intergenic?

##### Genic 
```~/programs/bedtools2/bin/multiIntersectBed -i ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed ~/Mcap_WGBS/Genome_Compare/Extracted/GWideExt/All.Meth5x.cov.CpG.report.txt ~/Mcap_WGBS/Genome_Compare/Tracks/genes.bed > SCOR.Meth.Gene.intersect```

find lines with 1,2,3 



```awk '($4 == 3)' SCOR.Meth.Gene.intersect > SCOR.Meth.Gene.intersect```

| perl -lane '$s += $F[2]-$F[1]; END{print $s}' ```

methylated scors in genes/scors in genes

* count the number of times SCORs intersect with methylation in genes
* normalize to the number of scor bases in genes
* 100325/162506973 = x%


##### InterGenic 
```~/programs/bedtools2/bin/multiIntersectBed -i ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed ~/Mcap_WGBS/Genome_Compare/Extracted/GWideExt/All.Meth5x.cov.CpG.report.txt ~/Mcap_WGBS/Genome_Compare/Tracks/intergenic.bed > SCOR.MethIntergenic.intersect``` 


```awk '($4 == 3)' SCOR.MethIntergenic.intersect | wc -l ```

* count the number of times SCORs intersect with methylation in intergenic
* normalize to the number of scors in intergenic
*63305/799056 = 7.9%

There appears to be no substantial differences in methylation in repetative DNA SCORs between genic and intergenic regions



#### Are SCORs in intron regions more methylated than exons?

##### Introns
```~/programs/bedtools2/bin/multiIntersectBed -i ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed ~/Mcap_WGBS/Genome_Compare/Extracted/GWideExt/All.Meth5x.cov.CpG.report.txt ~/Mcap_WGBS/Genome_Compare/Tracks/introns.bed > SCOR.Meth.Intron.intersect```

find lines with 1,2,3 
```awk '($4 == 3)' SCOR.Meth.Intron.intersect | wc -l ```

methylated scors in genes/scors in genes

* count the number of times SCORs intersect with methylation in introns
* normalize to the number of scors in introns
* 48612/637407 = 7.63%


##### InterGenic 
```~/programs/bedtools2/bin/multiIntersectBed -i ~/Mcap_WGBS/Genome_Compare/Tracks/20170313.mcap.falcon.errd.fasta.back.out.format.gff.bed ~/Mcap_WGBS/Genome_Compare/Extracted/GWideExt/All.Meth5x.cov.CpG.report.txt ~/Mcap_WGBS/Genome_Compare/Tracks/intergenic.bed > SCOR.MethIntergenic.intersect``` 


```awk '($4 == 3)' SCOR.MethIntergenic.intersect | wc -l ```

* count the number of times SCORs intersect with methylation in intergenic
* normalize to the number of scors in intergenic
*63305/799056 = 7.9%

There appears to be no substantial differences in methylation in repetative DNA SCORs between genic and intergenic regions