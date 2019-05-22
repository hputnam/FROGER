## Progress so far


### non-coding RNA annotations using infernal and the Rfam database (following instructions [here](https://rfam.readthedocs.io/en/latest/genome-annotation.html))

```
conda create -n infernal inferna
conda activate infernal
wget ftp://ftp.ebi.ac.uk/pub/databases/Rfam/CURRENT/Rfam.clanin
wget ftp://ftp.ebi.ac.uk/pub/databases/Rfam/CURRENT/Rfam.cm.gz
gunzip Rfam.cm.gz
cmpress Rfam.cm

cmscan -Z 1369.48 --cut_ga --rfam --nohmmonly --tblout cvir.tblout --fmt 2 --cpu 40 --clanin Rfam.clanin Rfam.cm reference.fasta > cvir-genome.cmscan
```
Remove lower quality hists overlapping with higher quality hits
`grep -v " = " cvir.tblout  > cvir.no_overlap.tblout`

Files available:

```
http://kitt.uri.edu/cvir.tblout
http://kitt.uri.edu/cvir.no_overlap.tblout
http://kitt.uri.edu/cvir-genome.cmscan
```

### Dowloaded latest version of [miRBase](http://www.mirbase.org) and use HiSat to map to genome

```
wget ftp://mirbase.org/pub/mirbase/CURRENT/mature.fa.gz
wget ftp://mirbase.org/pub/mirbase/CURRENT/hairpin.fa.gz
gunzip *.fa.gz
cat *.fa > miRNA.fasta
hisat2 -p 24 --mp 5,1 -f -x reference.fasta -U miRNA.fasta | samtools view -b > miRNA.bam
bedtools bamtobed -i miRNA.bam > miRNA.bed
```

Bed file available `http://kitt.uri.edu/miRNA.bed`
