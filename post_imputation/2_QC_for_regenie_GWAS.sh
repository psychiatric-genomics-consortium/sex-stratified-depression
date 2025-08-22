## Script to apply quality control (QC) thresholds to imputed data in bfile format using PLINK2
## This file should be used where there is relatedness in your sample and you plan to run a GWAS using regenie
## The script will create apply QC thesholds and create whole sample, male-only, and female-only id and snp lists.

## QC removes:
## un-phenotyped individuals
## individuals with unknown sex
## individuals with more than 10% missing variants
## multi-allelic variants
## variants with maf < 0.005
## variants with a missing rate > 0.1
## variants out of HWE with p < 1e-6

## usage:
## $ module load plink2
## $ ./2_QC_for_regenie_GWAS.sh filename
## * note filename is the name of your data without the .bed/.bim/.fam suffix

plink2 \
--bfile $1 \
--pheno $1.pheno \
--prune \
--max-alleles 2 \
--chr 1-22 \
--remove-nosex \
--maf 0.005 \
--geno 0.1 \
--mind 0.1 \
--hwe 1e-6 \
--write-samples \
--write-snplist \
--out $1_qc

## females
plink2 \
--bfile $1 \
--pheno $1.pheno \
--prune \
--max-alleles 2 \
--chr 1-22 \
--keep-females \
--maf 0.005 \
--geno 0.1 \
--mind 0.1 \
--hwe 1e-6 \
--write-samples \
--write-snplist \
--out $1_qc_female

# males
plink2 \
--bfile $1 \
--pheno $1.pheno \
--prune \
--max-alleles 2 \
--chr 1-22 \
--keep-males \
--maf 0.005 \
--geno 0.1 \
--mind 0.1 \
--hwe 1e-6 \
--write-samples \
--write-snplist \
--out $1_qc_male
