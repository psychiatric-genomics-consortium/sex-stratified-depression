## Script to apply quality control (QC) thresholds using PLINK to genotyped variants in preparation for Step 1 of regenie
## In your working directory, you need to create a single-column list of genotyped variants’ IDs for your data and save it in a file
## named genotypedvariants.txt with no header row 
## The script will apply QC thesholds and create whole sample, male-only, and female-only pruned snp lists.

## QC removes:
## multi-allelic variants
## non autosomal variants
## variants with maf < 0.01
## variants with a missing rate > 0.01
## variants out of HWE with p < 1e-15
## Applies LD pruning using a R2 threshold of 0.9 with a window size of 1,000 markers and a step size of 100 markers

## usage:
## $ module load plink2
## $ ./5_regenie_Prep_Geno.sh {filename}
## * note {filename} is the original name of your data without the .bed/.bim/.fam suffix

plink2 \
--bfile $1 \
--keep $1_qc1.id \
--extract genotypedvariants.txt \
--max-alleles 2 \
--chr 1-22 \
--maf 0.01 \
--geno 0.01 \
--hwe 1e-15 \
--indep-pairwise 1000 100 0.9 \
--out $1_qc1_geno

## females
plink2 \
--bfile $1 \
--keep $1_qc1_female.id \
--extract genotypedvariants.txt \
--max-alleles 2 \
--chr 1-22 \
--maf 0.01 \
--geno 0.01 \
--hwe 1e-15 \
--indep-pairwise 1000 100 0.9 \
--out $1_qc1_female_geno

##males
plink2 \
--bfile $1 \
--keep $1_qc1_male.id \
--extract genotypedvariants.txt \
--max-alleles 2 \
--chr 1-22 \
--maf 0.01 \
--geno 0.01 \
--hwe 1e-15 \
--indep-pairwise 1000 100 0.9 \
--out $1_qc1_male_geno
