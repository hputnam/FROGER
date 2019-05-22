#!/bin/bash

# Bismark with bowtie2 pipeline with score min function at -0.2 -for EpiMet #

#BISMARK="/share/bioinformatics/bismark"
#BOWTIE2="/share/bioinformatics/bowtie2"
#SAMTOOLS="/share/bioinformatics/samtools"
#METH_COVERAGE="/scratch/mgavery/EpiMet_RRBS"
#TRIM_GALORE="/share/bioinformatics/trim_galore"
#CUTADAPT="/share/bioinformatics/python/bin"

module load bio/bismark
module load bio/trim_galore

# Check for hard drive space
MAX_HDD=877

for sample_id in `ls -1 *.fastq.gz`
do

	# Check if Hard drive full
	CURR_HDD=$(df -h | grep "scratch" | awk '{print $3}' | sed -e 's/G//')
	if [ ${CURR_HDD} -gt ${MAX_HDD} ]
	then
		touch finished_early.txt
		exit
	fi
	
	# Sample_NUM.fastq.gz
    echo $sample_id
    
    NUM=`echo $sample_id | awk -F "." '{print $1}' | awk -F "_" '{print $2}'`
    # echo $NUM
    ID=`echo $sample_id | awk -F "." '{print $1}'`
    
    #Trimming with TrimGalore --rrbs option
    #$TRIM_GALORE/trim_galore \
    trim_galore \
    	--rrbs \
    	${sample_id}
    	
    #output name: sample_id_trimmed.fq.gz
    #		  sample_id.fastq_trimming_report.txt

    # Bisulfite Aligner --bowtie 2 --score_min -0.2
    #$BISMARK/bismark \
    bismark \
	--bowtie2 \
    	-q \
    	-p 4 \
    	--score_min L,0,-0.2 \
    	/scratch/mgavery/Omy_v2_released_filtered10kb \
 	${ID}_trimmed.fq.gz

	# Output Name: sample_id_trimmed_bismark_SE_report.txt
	#              sample_id_trimmed_bismark_bt2.sam.gz
	#######this has changed: output ..trimmed_bismark_bt2.bam

    # Meth Extraction
	ulimit -n 4096
	#/usr/bin/perl $BISMARK/bismark_methylation_extractor \
	bismark_methylation_extractor \
		-s \
		--multicore 8 \
		--comprehensive \
		--bedGraph \
		--counts \
		--buffer_size 10G \
		--scaffolds \
		${ID}_trimmed_bismark_bt2.bam

	# Output Name: sample_id_trimmed_bismark_bt2.bismark.cov.gz

    # Uncompress coverage file
	gunzip ${ID}_trimmed_bismark_bt2.bismark.cov.gz
	
	#Output Name: sample_id_trimmed_bismark_bt2.bismark.cov
	##############This has changed .._trimmed_bismark_bt2.bismark.cov

    #Merge Cov File
	perl formatting_merging_gff.pl ${ID}_trimmed_bismark_bt2.bismark.cov \
	> ${ID}_merge.cov

	#Output Name: sample_id_merge.cov

    # Reformat Table
    	# all coverage
	awk \
		-f meth_coverage.awk \
		${ID}_merge.cov \
		> ${ID}_reformcov.txt
		
	# Remove the context specific .txt files that are waaay big
	
	rm *context* ${sample_id}

done
