## Script to run step 1 of regenie using imputed data for males in bfile format
## A depression phenotype file is created from column 6 of the .fam file. Cases = 2, Controls = 1
## Only the previously identified variants in linkage equilibrium and with a maf > 0.05 are used in regenie step 1

## usage:
## $ module load regenie
## $ ./5_regenie_Step1_MALE.sh {filename} {covariate filename}
## * note {filename} is the original name of your data without the .bed/.bim/.fam suffix. The {covariatefilename} is the full name of the file
## containing the PCs identified as associated with depression using 4_Associated_PCAs.r along with age and any other relevant covariates

echo "FID IID pheno" > $1_qc1_male.pheno
awk '{ print $1, $2, $6 }' $1_qc1_male.fam >> $1_qc1_male.pheno

regenie \
--step 1 \
--bed $1_qc1_male \
--extract $1_qc1_male_indep.prune.in \
--covarFile $2 \
--phenoFile $1_qc1_male.pheno \
--cc12 \
--bsize 100 \
--bt \
--out $1_qc1_regenie_step1_male
