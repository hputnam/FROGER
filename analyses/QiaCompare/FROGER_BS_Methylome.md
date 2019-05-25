# Qiagen WGBS MBD-BS and RRBS data

Bismark Bisulfite Mapper VX “ map bisulfite treated sequencing reads to a genome of interest and perform methylation calls in a single step”

Bismark: a flexible aligner and methylation caller for Bisulfite-Seq applications

requires bowtie2, samtools, perl, trimmomatic

* Bowtie 2 version X by Ben Langmead (langmea@cs.jhu.edu, www.cs.jhu.edu/~langmea)
* Program: samtools (Tools for alignments in the SAM format) Version: X
* perl X 
* Bismark Bisulfite Mapper VX 
* Trimmomatic
* multiqc


```mkdir FROGER```  
```cd FROGER```  
```mkdir RAW```  
```cd RAW```  
```wget http://gannet.fish.washington.edu/seashell/snaps/Archive.zip``` 
```cd ..```

## Obtain Genome file
``mkdir GENOME``  
``cd GENOME``  
``wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/022/765/GCF_002022765.2_C_virginica-3.0/GCF_002022765.2_C_virginica-3.0_genomic.fna.gz`` 

``mv GENOME/GCF_002022765.2_C_virginica-3.0_genomic.fna.gz GENOME/GCF_002022765.2_C_virginica-3.0_genomic.fa.gz``  

## Run Bismark Genome preparation
#### C. virginica Genome v3.0
``/home/shared/Bismark-0.19.1/bismark_genome_preparation GENOME``  


## Unzip files
``cd FROGER/RAW``  
``unzip Archive.zip``  


## Count raw reads

```zgrep -c "@M03" *.fastq.gz```

```
10_32_S32_L001_R1_001.fastq.gz:574346  
10_32_S32_L001_R2_001.fastq.gz:574346  
11_37_S37_L001_R1_001.fastq.gz:695562  
11_37_S37_L001_R2_001.fastq.gz:695562  
12_38_S38_L001_R1_001.fastq.gz:865269  
12_38_S38_L001_R2_001.fastq.gz:865269  
1_25_S25_L001_R1_001.fastq.gz:488137  
1_25_S25_L001_R2_001.fastq.gz:488137  
13_33_S33_L001_R1_001.fastq.gz:645468  
13_33_S33_L001_R2_001.fastq.gz:645468  
14_34_S34_L001_R1_001.fastq.gz:691626  
14_34_S34_L001_R2_001.fastq.gz:691626  
15_39_S39_L001_R1_001.fastq.gz:671325  
15_39_S39_L001_R2_001.fastq.gz:671325  
16_40_S40_L001_R1_001.fastq.gz:771805  
16_40_S40_L001_R2_001.fastq.gz:771805  
17_9_S9_L001_R1_001.fastq.gz:403861  
17_9_S9_L001_R2_001.fastq.gz:403861  
18_10_S10_L001_R1_001.fastq.gz:525421  
18_10_S10_L001_R2_001.fastq.gz:525421  
19_7_S7_L001_R1_001.fastq.gz:371667  
19_7_S7_L001_R2_001.fastq.gz:371667    
20_8_S8_L001_R1_001.fastq.gz:314922    
20_8_S8_L001_R2_001.fastq.gz:314922    
2_26_S26_L001_R1_001.fastq.gz:168954  
2_26_S26_L001_R2_001.fastq.gz:168954  
3_27_S27_L001_R1_001.fastq.gz:231652  
3_27_S27_L001_R2_001.fastq.gz:231652  
4_28_S28_L001_R1_001.fastq.gz:279065  
4_28_S28_L001_R2_001.fastq.gz:279065  
5_35_S35_L001_R1_001.fastq.gz:21862  
5_35_S35_L001_R2_001.fastq.gz:21862  
6_36_S36_L001_R1_001.fastq.gz:31352  
6_36_S36_L001_R2_001.fastq.gz:31352  
7_29_S29_L001_R1_001.fastq.gz:612994  
7_29_S29_L001_R2_001.fastq.gz:612994  
8_30_S30_L001_R1_001.fastq.gz:665233  
8_30_S30_L001_R2_001.fastq.gz:665233  
9_31_S31_L001_R1_001.fastq.gz:595446  
9_31_S31_L001_R2_001.fastq.gz:595446  
```

## QC Raw Data 
``cd ..``  
``mkdir QC``  
``cd QC``  
``mkdir RAW_QC``  

``/home/shared/fastqc_0.11.7/fastqc ~/FROGER/RAW/*.fastq.gz -o ~/FROGER/QC/RAW_QC``  

``/home/shared/MultiQC/scripts/multiqc ~/FROGER/QC/RAW_QC``  

## Download and view QC data
``scp srlab@emu.fish.washington.edu:/home/srlab/FROGER/QC/RAW_QC/multiqc_report.html MyProjects/FROGER/``  

* Data are 75bp paired end reads that have already been trimmed

* Qiagen tech indicates we need to trim first 8 bases from all files. We can see this in the QC reports as well


# Trimming
``mkdir hardtrim``  
``cd hardtrim``  

```
for fastq in *R1*.fastq.gz
do
  old_suffix=_L001_R1_001.fastq.gz
  output_suffix=_trimmed.fastq.gz
  # Trim suffix from each file name using parameter substitution
  name=${fastq%$old_suffix}
  java -jar /home/shared/Trimmomatic-0.36/trimmomatic-0.36.jar \
  PE \
  -threads 15 \
  -basein "${fastq}" \
  HEADCROP:8 \
  -baseout "${name}${output_suffix}"
  mv *trimmed* /home/srlab/FROGER/RAW/hardtrim
done
```



## QC Trimmed Data 
``cd ..``  
``mkdir QC``  
``cd QC``  
``mkdir Trim_QC``  

``/home/shared/fastqc_0.11.7/fastqc /home/srlab/FROGER/RAW/hardtrim/*.fastq.gz -o ~/FROGER/QC/Trim_QC``  

``/home/srlab/.local/bin/multiqc .``

## Download and view QC data
``scp srlab@emu.fish.washington.edu:/home/srlab/FROGER/QC/Trim_QC/multiqc_report.html MyProjects/FROGER/``  

* The first 8 bases are gone. The majority of the files end in a T base

## Count trimmed reads
```zgrep -c "@M03" /home/srlab/FROGER/RAW/hardtrim/*.fastq.gz```

```
/home/srlab/FROGER/RAW/hardtrim/10_32_S32_trimmed_1P.fastq.gz:574346
/home/srlab/FROGER/RAW/hardtrim/10_32_S32_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/10_32_S32_trimmed_2P.fastq.gz:574346
/home/srlab/FROGER/RAW/hardtrim/10_32_S32_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/11_37_S37_trimmed_1P.fastq.gz:695562
/home/srlab/FROGER/RAW/hardtrim/11_37_S37_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/11_37_S37_trimmed_2P.fastq.gz:695562
/home/srlab/FROGER/RAW/hardtrim/11_37_S37_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/12_38_S38_trimmed_1P.fastq.gz:865269
/home/srlab/FROGER/RAW/hardtrim/12_38_S38_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/12_38_S38_trimmed_2P.fastq.gz:865269
/home/srlab/FROGER/RAW/hardtrim/12_38_S38_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/1_25_S25_trimmed_1P.fastq.gz:488137
/home/srlab/FROGER/RAW/hardtrim/1_25_S25_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/1_25_S25_trimmed_2P.fastq.gz:488137
/home/srlab/FROGER/RAW/hardtrim/1_25_S25_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/13_33_S33_trimmed_1P.fastq.gz:645468
/home/srlab/FROGER/RAW/hardtrim/13_33_S33_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/13_33_S33_trimmed_2P.fastq.gz:645468
/home/srlab/FROGER/RAW/hardtrim/13_33_S33_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/14_34_S34_trimmed_1P.fastq.gz:691626
/home/srlab/FROGER/RAW/hardtrim/14_34_S34_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/14_34_S34_trimmed_2P.fastq.gz:691626
/home/srlab/FROGER/RAW/hardtrim/14_34_S34_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/15_39_S39_trimmed_1P.fastq.gz:671325
/home/srlab/FROGER/RAW/hardtrim/15_39_S39_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/15_39_S39_trimmed_2P.fastq.gz:671325
/home/srlab/FROGER/RAW/hardtrim/15_39_S39_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/16_40_S40_trimmed_1P.fastq.gz:771805
/home/srlab/FROGER/RAW/hardtrim/16_40_S40_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/16_40_S40_trimmed_2P.fastq.gz:771805
/home/srlab/FROGER/RAW/hardtrim/16_40_S40_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/17_9_S9_trimmed_1P.fastq.gz:403861
/home/srlab/FROGER/RAW/hardtrim/17_9_S9_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/17_9_S9_trimmed_2P.fastq.gz:403861
/home/srlab/FROGER/RAW/hardtrim/17_9_S9_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/18_10_S10_trimmed_1P.fastq.gz:525421
/home/srlab/FROGER/RAW/hardtrim/18_10_S10_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/18_10_S10_trimmed_2P.fastq.gz:525421
/home/srlab/FROGER/RAW/hardtrim/18_10_S10_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/19_7_S7_trimmed_1P.fastq.gz:371667
/home/srlab/FROGER/RAW/hardtrim/19_7_S7_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/19_7_S7_trimmed_2P.fastq.gz:371667
/home/srlab/FROGER/RAW/hardtrim/19_7_S7_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/20_8_S8_trimmed_1P.fastq.gz:314922
/home/srlab/FROGER/RAW/hardtrim/20_8_S8_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/20_8_S8_trimmed_2P.fastq.gz:314922
/home/srlab/FROGER/RAW/hardtrim/20_8_S8_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/2_26_S26_trimmed_1P.fastq.gz:168954
/home/srlab/FROGER/RAW/hardtrim/2_26_S26_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/2_26_S26_trimmed_2P.fastq.gz:168954
/home/srlab/FROGER/RAW/hardtrim/2_26_S26_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/3_27_S27_trimmed_1P.fastq.gz:231652
/home/srlab/FROGER/RAW/hardtrim/3_27_S27_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/3_27_S27_trimmed_2P.fastq.gz:231652
/home/srlab/FROGER/RAW/hardtrim/3_27_S27_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/4_28_S28_trimmed_1P.fastq.gz:279065
/home/srlab/FROGER/RAW/hardtrim/4_28_S28_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/4_28_S28_trimmed_2P.fastq.gz:279065
/home/srlab/FROGER/RAW/hardtrim/4_28_S28_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/5_35_S35_trimmed_1P.fastq.gz:21862
/home/srlab/FROGER/RAW/hardtrim/5_35_S35_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/5_35_S35_trimmed_2P.fastq.gz:21862
/home/srlab/FROGER/RAW/hardtrim/5_35_S35_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/6_36_S36_trimmed_1P.fastq.gz:31352
/home/srlab/FROGER/RAW/hardtrim/6_36_S36_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/6_36_S36_trimmed_2P.fastq.gz:31352
/home/srlab/FROGER/RAW/hardtrim/6_36_S36_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/7_29_S29_trimmed_1P.fastq.gz:612994
/home/srlab/FROGER/RAW/hardtrim/7_29_S29_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/7_29_S29_trimmed_2P.fastq.gz:612994
/home/srlab/FROGER/RAW/hardtrim/7_29_S29_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/8_30_S30_trimmed_1P.fastq.gz:665233
/home/srlab/FROGER/RAW/hardtrim/8_30_S30_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/8_30_S30_trimmed_2P.fastq.gz:665233
/home/srlab/FROGER/RAW/hardtrim/8_30_S30_trimmed_2U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/9_31_S31_trimmed_1P.fastq.gz:595446
/home/srlab/FROGER/RAW/hardtrim/9_31_S31_trimmed_1U.fastq.gz:0
/home/srlab/FROGER/RAW/hardtrim/9_31_S31_trimmed_2P.fastq.gz:595446
/home/srlab/FROGER/RAW/hardtrim/9_31_S31_trimmed_2U.fastq.gz:0
```

## Pool Samples to run combined
* concatenate all Read 1 and all Read 2 for three sample types to determine mapping and coverage

```
cat 1_25_S25_trimmed_1P.fastq.gz 2_26_S26_trimmed_1P.fastq.gz 3_27_S27_trimmed_1P.fastq.gz 4_28_S28_trimmed_1P.fastq.gz 5_35_S35_trimmed_1P.fastq.gz 6_36_S36_trimmed_1P.fastq.gz 17_9_S9_trimmed_1P.fastq.gz 18_10_S10_trimmed_1P.fastq.gz 19_7_S7_trimmed_1P.fastq.gz  > WGBS_R1.trimmed.fastq.gz
cat  1_25_S25_trimmed_2P.fastq.gz 2_26_S26_trimmed_2P.fastq.gz 3_27_S27_trimmed_2P.fastq.gz 4_28_S28_trimmed_2P.fastq.gz 5_35_S35_trimmed_2P.fastq.gz 6_36_S36_trimmed_2P.fastq.gz 17_9_S9_trimmed_2P.fastq.gz 18_10_S10_trimmed_2P.fastq.gz 19_7_S7_trimmed_2P.fastq.gz  > WGBS_R2.trimmed.fastq.gz
```

``zgrep -c "@M03" /home/srlab/FROGER/RAW/hardtrim/WGBS_R*.trimmed.fastq.gz``

```
cat 9_31_S31_trimmed_1P.fastq.gz 10_32_S32_trimmed_1P.fastq.gz 11_37_S37_trimmed_1P.fastq.gz 12_38_S38_trimmed_1P.fastq.gz 13_33_S33_trimmed_1P.fastq.gz 14_34_S34_trimmed_1P.fastq.gz 15_39_S39_trimmed_1P.fastq.gz 16_40_S40_trimmed_1P.fastq.gz 20_8_S8_trimmed_1P.fastq.gz  > MBD_BS_R1.trimmed.fastq.gz
cat 9_31_S31_trimmed_2P.fastq.gz 10_32_S32_trimmed_2P.fastq.gz 11_37_S37_trimmed_2P.fastq.gz 12_38_S38_trimmed_2P.fastq.gz 13_33_S33_trimmed_2P.fastq.gz 14_34_S34_trimmed_2P.fastq.gz 15_39_S39_trimmed_2P.fastq.gz 16_40_S40_trimmed_2P.fastq.gz 20_8_S8_trimmed_2P.fastq.gz  > MBD_BS_R2.trimmed.fastq.gz
```

``zgrep -c "@M03" /home/srlab/FROGER/RAW/hardtrim/MBD_BS_R*.trimmed.fastq.gz``

```
cat  7_29_S29_trimmed_1P.fastq.gz 8_30_S30_trimmed_1P.fastq.gz > RRBS_R1.trimmed.fastq.gz
cat  7_29_S29_trimmed_2P.fastq.gz 8_30_S30_trimmed_2P.fastq.gz  > RRBS_R2.trimmed.fastq.gz
```

``zgrep -c "@M03" /home/srlab/FROGER/RAW/hardtrim/RRBS_R*.trimmed.fastq.gz``


 
## Map data to converted genome

```mkdir Mapped```  
```cd Mapped```

### Optimizing Mapping

#### RRBS
##### parameters for non-directional
* Set for non-directional
* minimum alignment score function L,0,-0.2
``/home/shared/Bismark-0.19.1/bismark --genome /home/srlab/FROGER/GENOME/ --bowtie2 /home/shared/bowtie2-2.3.4.1-linux-x86_64/bowtie2 --non_directional -1 /home/srlab/FROGER/RAW/hardtrim/RRBS_R1.trimmed.fastq.gz -2 /home/srlab/FROGER/RAW/hardtrim/RRBS_R2.trimmed.fastq.gz``
* Mapping = 38% Unique and nonunique

```
Final Alignment report
======================
Sequence pairs analysed in total:	1278227
Number of paired-end alignments with a unique best hit:	271749
Mapping efficiency:	21.3%

Sequence pairs with no alignments under any condition:	793932
Sequence pairs did not map uniquely:	212546
Sequence pairs which were discarded because genomic sequence could not be extracted:	0

Number of sequence pairs with unique best (first) alignment came from the bowtie output:
CT/GA/CT:	55379	((converted) top strand)
GA/CT/CT:	81466	(complementary to (converted) top strand)
GA/CT/GA:	80537	(complementary to (converted) bottom strand)
CT/GA/GA:	54367	((converted) bottom strand)

Final Cytosine Methylation Report
=================================
Total number of C's analysed:	7148861

Total methylated C's in CpG context:	70865
Total methylated C's in CHG context:	2857
Total methylated C's in CHH context:	10298
Total methylated C's in Unknown context:	43

Total unmethylated C's in CpG context:	1134133
Total unmethylated C's in CHG context:	1394961
Total unmethylated C's in CHH context:	4535747
Total unmethylated C's in Unknown context:	3131

C methylated in CpG context:	5.9%
C methylated in CHG context:	0.2%
C methylated in CHH context:	0.2%
C methylated in unknown context (CN or CHN):	1.4%


Bismark completed in 0d 0h 10m 46s

====================
Bismark run complete
====================
```

#### RRBS with looser score min parameters

* Set for non-directional
* minimum alignment score function L,0,-0.6
``/home/shared/Bismark-0.19.1/bismark --genome /home/srlab/FROGER/GENOME/ --bowtie2 /home/shared/bowtie2-2.3.4.1-linux-x86_64/bowtie2 --non_directional --score_min L,0,-0.6 -1 /home/srlab/FROGER/RAW/hardtrim/RRBS_R1.trimmed.fastq.gz -2 /home/srlab/FROGER/RAW/hardtrim/RRBS_R2.trimmed.fastq.gz``
* Mapping = 55% Unique and nonunique

```
Final Alignment report
======================
Sequence pairs analysed in total:	1278227
Number of paired-end alignments with a unique best hit:	432651
Mapping efficiency:	33.8%

Sequence pairs with no alignments under any condition:	569112
Sequence pairs did not map uniquely:	276464
Sequence pairs which were discarded because genomic sequence could not be extracted:	1

Number of sequence pairs with unique best (first) alignment came from the bowtie output:
CT/GA/CT:	87893	((converted) top strand)
GA/CT/CT:	129491	(complementary to (converted) top strand)
GA/CT/GA:	128599	(complementary to (converted) bottom strand)
CT/GA/GA:	86667	((converted) bottom strand)

Final Cytosine Methylation Report
=================================
Total number of C's analysed:	11236128

Total methylated C's in CpG context:	100695
Total methylated C's in CHG context:	5542
Total methylated C's in CHH context:	30527
Total methylated C's in Unknown context:	1148

Total unmethylated C's in CpG context:	1775468
Total unmethylated C's in CHG context:	2189159
Total unmethylated C's in CHH context:	7134737
Total unmethylated C's in Unknown context:	34892

C methylated in CpG context:	5.4%
C methylated in CHG context:	0.3%
C methylated in CHH context:	0.4%
C methylated in unknown context (CN or CHN):	3.2%


Bismark completed in 0d 0h 13m 5s

====================
Bismark run complete
====================
```

#### Use these parameters --non_directional --score_min L,0,-0.6 for all mapping in the project

#### MBD_BS
* Set for non-directional
* minimum alignment score function L,0,-0.6
``/home/shared/Bismark-0.19.1/bismark --genome /home/srlab/FROGER/GENOME/ --bowtie2 /home/shared/bowtie2-2.3.4.1-linux-x86_64/bowtie2 --non_directional --score_min L,0,-0.6 -1 /home/srlab/FROGER/RAW/hardtrim/MBD_BS_R1.trimmed.fastq.gz -2 /home/srlab/FROGER/RAW/hardtrim/MBD_BS_R2.trimmed.fastq.gz``
* Mapping = 51% Unique and nonunique

```
Final Alignment report
======================
Sequence pairs analysed in total:	5825769
Number of paired-end alignments with a unique best hit:	2150765
Mapping efficiency:	36.9%

Sequence pairs with no alignments under any condition:	2842284
Sequence pairs did not map uniquely:	832720
Sequence pairs which were discarded because genomic sequence could not be extracted:	0

Number of sequence pairs with unique best (first) alignment came from the bowtie output:
CT/GA/CT:	378828	((converted) top strand)
GA/CT/CT:	692863	(complementary to (converted) top strand)
GA/CT/GA:	699576	(complementary to (converted) bottom strand)
CT/GA/GA:	379498	((converted) bottom strand)

Final Cytosine Methylation Report
=================================
Total number of C's analysed:	57050785

Total methylated C's in CpG context:	5873524
Total methylated C's in CHG context:	117908
Total methylated C's in CHH context:	348850
Total methylated C's in Unknown context:	15586

Total unmethylated C's in CpG context:	2189825
Total unmethylated C's in CHG context:	12361400
Total unmethylated C's in CHH context:	36159278
Total unmethylated C's in Unknown context:	166066

C methylated in CpG context:	72.8%
C methylated in CHG context:	0.9%
C methylated in CHH context:	1.0%
C methylated in unknown context (CN or CHN):	8.6%


Bismark completed in 0d 1h 8m 52s

====================
Bismark run complete
====================
```


#### WGBS
* Set for non-directional
* minimum alignment score function L,0,-0.6
``/home/shared/Bismark-0.19.1/bismark --genome /home/srlab/FROGER/GENOME/ --bowtie2 /home/shared/bowtie2-2.3.4.1-linux-x86_64/bowtie2 --non_directional --score_min L,0,-0.6 -1 /home/srlab/FROGER/RAW/hardtrim/WGBS_R1.trimmed.fastq.gz -2 /home/srlab/FROGER/RAW/hardtrim/WGBS_R2.trimmed.fastq.gz``
* Mapping = 32% 55% Unique and nonunique

```
Final Alignment report
======================
Sequence pairs analysed in total:	2521971
Number of paired-end alignments with a unique best hit:	556745
Mapping efficiency:	22.1%

Sequence pairs with no alignments under any condition:	1724025
Sequence pairs did not map uniquely:	241201
Sequence pairs which were discarded because genomic sequence could not be extracted:	1

Number of sequence pairs with unique best (first) alignment came from the bowtie output:
CT/GA/CT:	88391	((converted) top strand)
GA/CT/CT:	190716	(complementary to (converted) top strand)
GA/CT/GA:	189817	(complementary to (converted) bottom strand)
CT/GA/GA:	87820	((converted) bottom strand)

Final Cytosine Methylation Report
=================================
Total number of C's analysed:	13373659

Total methylated C's in CpG context:	160803
Total methylated C's in CHG context:	10421
Total methylated C's in CHH context:	138299
Total methylated C's in Unknown context:	4274

Total unmethylated C's in CpG context:	1684015
Total unmethylated C's in CHG context:	2512869
Total unmethylated C's in CHH context:	8867252
Total unmethylated C's in Unknown context:	42657

C methylated in CpG context:	8.7%
C methylated in CHG context:	0.4%
C methylated in CHH context:	1.5%
C methylated in unknown context (CN or CHN):	9.1%


Bismark completed in 0d 0h 21m 16s

====================
Bismark run complete
====================
```

## Deduplicate Data for MBD and WGBS

```mkdir DeDup```
```cd Dedup```

### WGBS Deduplicating
`` /home/shared/Bismark-0.19.1/deduplicate_bismark ~/FROGER/Mapped/WGBS/WGBS_R1.trimmed_bismark_bt2_pe.bam``
 * retained 99.45%

* Output file is: WGBS_R1.trimmed_bismark_bt2_pe.deduplicated.sam
Total number of alignments analysed in /home/srlab/FROGER/Mapped/WGBS/WGBS_R1.trimmed_bismark_bt2_pe.bam:	556744  
Total number duplicated alignments removed:	3039 (0.55%)  
Duplicated alignments were found at:	2848 different position(s)

* Total count of deduplicated leftover sequences: 553705 (99.45% of total)

### MBD_BS Deduplicating
 ``/home/shared/Bismark-0.19.1/deduplicate_bismark /home/srlab/FROGER/Mapped/MBD_BS/MBD_BS_R1.trimmed_bismark_bt2_pe.bam``
 * retained 99.78%
 
* Output file is: MBD_BS_R1.trimmed_bismark_bt2_pe.deduplicated.sam

Total number of alignments analysed in /home/srlab/FROGER/Mapped/MBD_BS/MBD_BS_R1.trimmed_bismark_bt2_pe.bam:	2150765  
Total number duplicated alignments removed:	4669 (0.22%)  
Duplicated alignments were found at:	4562 different position(s)  

* Total count of deduplicated leftover sequences: 2146096 (99.78% of total)

# Extract Methylation

## Genome-Wide Extraction
```mkdir Extracted```
```cd Extracted```
```mkdir GWideExt```
```cd GWideExt```

#### RRBS
``/home/shared/Bismark-0.19.1/bismark_methylation_extractor --gzip -p --ignore_r2 2 --bedGraph --zero_based --no_overlap --multicore 20 --buffer_size 20G --cytosine_report --report --genome_folder /home/srlab/FROGER/GENOME  /home/srlab/FROGER/Mapped/RRBS/RRBS_R1.trimmed_bismark_bt2_pe.bam``  
  
#### Final Cytosine Methylation Report RRBS
```
Parameters used to extract methylation information:
Bismark Extractor Version: v0.19.1
Bismark result file: paired-end (SAM format)
Ignoring first 2 bp of Read 2
Output specified: strand-specific (default)
No overlapping methylation calls specified


Processed 432650 lines in total
Total number of methylation call strings processed: 865300

Final Cytosine Methylation Report
=================================
Total number of C's analysed:   9630322

Total methylated C's in CpG context:    82924
Total methylated C's in CHG context:    4473
Total methylated C's in CHH context:    22759

Total C to T conversions in CpG context:        1508725
Total C to T conversions in CHG context:        1858481
Total C to T conversions in CHH context:        6152960

C methylated in CpG context:    5.2%
C methylated in CHG context:    0.2%
C methylated in CHH context:    0.4%
```

#### Final Cytosine Methylation Report WGBS
``/home/shared/Bismark-0.19.1/bismark_methylation_extractor --gzip -p --ignore_r2 2 --bedGraph --zero_based --no_overlap --multicore 20 --buffer_size 20G --cytosine_report --report --genome_folder /home/srlab/FROGER/GENOME  /home/srlab/FROGER/DeDup/WGBS_R1.trimmed_bismark_bt2_pe.deduplicated.sam``  

```
### Final Cytosine Methylation Report WGBS
Parameters used to extract methylation information:
Bismark Extractor Version: v0.19.1
Bismark result file: paired-end (SAM format)
Ignoring first 2 bp of Read 2
Output specified: strand-specific (default)
No overlapping methylation calls specified


Processed 553705 lines in total
Total number of methylation call strings processed: 1107410

Final Cytosine Methylation Report
=================================
Total number of C's analysed:   11044874

Total methylated C's in CpG context:    129557
Total methylated C's in CHG context:    7557
Total methylated C's in CHH context:    93332

Total C to T conversions in CpG context:        1378239
Total C to T conversions in CHG context:        2056342
Total C to T conversions in CHH context:        7379847

C methylated in CpG context:    8.6%
C methylated in CHG context:    0.4%
C methylated in CHH context:    1.2%
```

#### Final Cytosine Methylation Report MBD_BS
``/home/shared/Bismark-0.19.1/bismark_methylation_extractor --gzip -p --ignore_r2 2 --bedGraph --zero_based --no_overlap --multicore 20 --buffer_size 20G --cytosine_report --report --genome_folder /home/srlab/FROGER/GENOME  /home/srlab/FROGER/DeDup/MBD_BS_R1.trimmed_bismark_bt2_pe.deduplicated.sam``

```
### Final Cytosine Methylation Report MBD_BS
Parameters used to extract methylation information:
Bismark Extractor Version: v0.19.1
Bismark result file: paired-end (SAM format)
Ignoring first 2 bp of Read 2
Output specified: strand-specific (default)
No overlapping methylation calls specified


Processed 2146096 lines in total
Total number of methylation call strings processed: 4292192

Final Cytosine Methylation Report
=================================
Total number of C's analysed:   50300415

Total methylated C's in CpG context:    5128909
Total methylated C's in CHG context:    100854
Total methylated C's in CHH context:    287545

Total C to T conversions in CpG context:        1913810
Total C to T conversions in CHG context:        10832664
Total C to T conversions in CHH context:        32036633

C methylated in CpG context:    72.8%
C methylated in CHG context:    0.9%
C methylated in CHH context:    0.9%
```

# Prep for MethylKit
Running perl and awk scripts on .cov files generated from Bismark methylation extractor.  Perl script combines reads from both strands while awk script reformats for easy read into methylKit. 

Running perl and awk scripts on cov file from **RRBS extracted**

perl - combine strands and get zero based
```
gunzip RRBS_R1.trimmed_bismark_bt2_pe.bismark.cov.gz 
```

```
 perl formatting_merging_gff.pl RRBS_R1.trimmed_bismark_bt2_pe.bismark.cov > RRBS_R1.trimmed_bismark_bt2_pe.bismark_merge.cov
```

awk - make it methylKit friendly
```
 awk -f meth_coverage.awk RRBS_R1.trimmed_bismark_bt2_pe.bismark_merge.cov > RRBS_R1.trimmed_bismark_bt2_pe.bismark_reformcov.txt
```

Running perl and awk scripts on cov file from **WGBS extracted**

perl - combine strands and get zero based
```
 gunzip WGBS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark.cov.gz 
```

```
perl formatting_merging_gff.pl WGBS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark.cov > WGBS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_merge.cov 
```

awk - make it methylKit friendly
```
awk -f meth_coverage.awk WGBS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_merge.cov > WGBS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_reformcov.txt
```

Running perl and awk scripts on cov file from **MBD extracted**

perl - combine strands and get zero based
```
gunzip MBD_BS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark.cov.gz 
```

```
perl formatting_merging_gff.pl MBD_BS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark.cov > MBD_BS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_merge.cov
```

awk - make it methylKit friendly
```
awk -f meth_coverage.awk MBD_BS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_merge.cov > MBD_BS_R1.trimmed_bismark_bt2_pe.deduplicated.bismark_reformcov.txt
```



## Mapping each library separately to see if mapping efficiency differs with input amounts

```
find *.gz | xargs basename -s _trimmed_1P.fastq.gz | xargs -I{} /home/shared/Bismark-0.19.1/bismark --genome /home/srlab/FROGER/GENOME/ --bowtie2 /home/shared/bowtie2-2.3.4.1-linux-x86_64/bowtie2 --non_directional --score_min L,0,-0.6 -1 {}_trimmed_1P.fastq.gz -2 {}_trimmed_2P.fastq.gz -o bismarkout_individual/'
```

Multiqc of Bismarck mapping for individual and combined libraries

```
srlab@emu:~/FROGER/RAW/hardtrim/bismarkout_individual$ /home/srlab/.local/bin/multiqc .
```


```
srlab@emu:~/FROGER/Mapped$ /home/srlab/.local/bin/multiqc .
```

These multiQC files can be found in 'analyses'

## Process RRBS data again after hard trimming 2bp from 3' end

The reads have already been adapter trimmed by the sequencing facility, so TrimGalore can't be used in -rrbs mode to remove gap filled cytosine positions.  Going to hard trim 2bp off the end off the 3' ends of the reads to see if it explains some of the discordance between the MBD and RRBS data

remove 2 bases off 3' end of both reads

```
srlab@emu:~/FROGER/RAW/RRBS_trim2$ cutadapt -u -2 -U -2 -o RRBS.trim2.R1.fastq -p RRBS.trim2.R2.out.2.fastq RRBS_R1.trimmed.fastq.gz RRBS_R2.trimmed.fastq.gz 
```


bismark map

```
srlab@emu:~/FROGER/RAW/RRBS_trim2/bismarkmapped$ /home/shared/Bismark-0.19.1/bismark --genome /home/srlab/FROGER/GENOME/ --bowtie2 /home/shared/bowtie2-2.3.4.1-linux-x86_64/bowtie2 --non_directional --score_min L,0,-0.6 -1 RRBS.trim2.R1.fastq -2 RRBS.trim2.R2.out.2.fastq 
```


methextract
```
/home/shared/Bismark-0.19.1/bismark_methylation_extractor --gzip -p --ignore_r2 2 --bedGraph --zero_based --no_overlap --multicore 20 --buffer_size 20G --cytosine_report --report --genome_folder /home/srlab/FROGER/GENOME /home/srlab/FROGER/Mapped/RRBS/RRBS.trim2.R1_bismark_bt2_pe.bam 
```

perl and awk

```
gunzip RRBS_R1.trimmed_bismark_bt2_pe.bismark.cov.gz 
```


```
perl /home/srlab/FROGER/Extracted/MBD_BS_extr/formatting_merging_gff.pl RRBS.trim2.R1_bismark_bt2_pe.bismark.cov > RRBS.trim2.R1_bismark_bt2_pe.bismark_merge.cov
```

 
```
awk -f /home/srlab/FROGER/Extracted/MBD_BS_extr/meth_coverage.awk RRBS.trim2.R1_bismark_bt2_pe.bismark_merge.cov > RRBS.trim2.R1_bismark_bt2_pe.bismark_reformcov.txt
```


# STOP HERE

## Calculate number of CpG in the genome


zgrep -v '>' /home/srlab/FROGER/GENOME/GCF_002022765.2_C_virginica-3.0_genomic.fa.gz | grep -o -i 'CG' | wc -l

* number of CG's in the assembled genome = 14,277,725






