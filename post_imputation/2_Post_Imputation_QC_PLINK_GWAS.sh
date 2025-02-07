## Script to apply quality control (QC) thresholds to imputed data in bfile format using PLINK2
## Sex should be in column 5 and the depression phenotype should be in column 6 of the .fam file
## This file should be used when there is low relatedness in your sample and they have been identifed by running 1_Relatedness.sh
## The script will create apply QC thesholds and create whole sample, male-only, and female-only dataset.
## QC removes:
## un-phenotyped individuals
## related individuals
## individuals with unknown sex
## individuals with more than 10% missing variants
## multi-allelic variants
## variants with maf < 0.005
## variants with a missing rate > 0.1
## variants out of HWE with p < 1e-6

## usage:
## $ module load plink2
## $ ./1_Post_Imputation_QC.sh {filename}
## * note {filename} is the original name of your data without the .bed/.bim/.fam suffix

plink2 \
--bfile $1 \
--prune \
--max-alleles 2 \
--remove $1$_king_unrel.king.cutoff.out.id \
--remove-nosex \
--maf 0.005 \
--geno 0.1 \
--mind 0.1 \
--hwe 1e-6 \
--make-bed \
--out $1_qc1

plink2 \
--bfile $1 \
--prune \
--max-alleles 2 \
--remove $1$_king_unrel.king.cutoff.out.id
--keep-females \
--maf 0.005 \
--geno 0.1 \
--mind 0.1 \
--hwe 1e-6 \
--make-bed \
--out $1_qc1_female

plink2 \
--bfile $1 \
--prune \
--max-alleles 2 \
--remove $1$_king_unrel.king.cutoff.out.id
--keep-males \
--maf 0.005 \
--geno 0.1 \
--mind 0.1 \
--hwe 1e-6 \
--make-bed \
--out $1_qc1_male
