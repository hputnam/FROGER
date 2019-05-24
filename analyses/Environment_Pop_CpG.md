KE Lotterhos
A Downey-Wall

As part of a larger analysis of population structure and associations with the environment, we've looked at (1) CpG O/E differences 
among populations and (2) associations between CpG O/E and environmental variables.

1) A Kruskal Wallis test for CpGO/E (of a gene or exon or whatever feature) ~ Population. This tells us if CpGO/E differences among 
populations are significant (but note that this does not correct for population structure).
* We also calculated the CV in CpGO/E among individuals, which represents overall variation at that locus

The code is here:
https://github.com/jpuritz/OysterGenomeProject/tree/master/popstructureOutliers/src/7cpg

And outputs are here:
__EasternOysterGenome/Population Structure/Large_outputs/envi_assoc_CpG


2) We used lfmm_ridge to calculate the association between CpGO/E and the available environmental variables (based on Kevin's code). 
We also calculated Spearman's rho.

Code is located in the OysterGenomeProject repository here:
- https://github.com/jpuritz/OysterGenomeProject/tree/master/popstructureOutliers/src/8cpgoe_enviAssoc


And the outputs are here:
- [Figures](https://github.com/jpuritz/OysterGenomeProject/tree/master/popstructureOutliers/figures/7cpgoe_enviAssoc)
- [Significance and rho tables for individual environmental variables, and complete .rds file for all associations](https://github.com/jpuritz/OysterGenomeProject/tree/master/popstructureOutliers/data/cpgoe_enviAssoc_results) 
- Google drive for large outputs: __EasternOysterGenome/Population Structure/Large_outputs/envi_assoc_CpG
