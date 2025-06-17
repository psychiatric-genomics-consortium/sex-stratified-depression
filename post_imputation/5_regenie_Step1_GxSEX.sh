## Script to run step 1 of regenie using QC'd genotyped variants from both sexes in bfile format
## Sex should be added as a covariate in the covariate file.

## usage:
## $ module load regenie
## $ ./5_regenie_Step1_GxSEX.sh {filename} {covariate filename}
## * note {filename} is the original name of your data without the .bed/.bim/.fam suffix. The {covariatefilename} is the full name of the file
## containing the PCs identified as associated with depression using 4_Associated_PCAs.r along with sex, age and any other relevant covariates

regenie \
--step 1 \
--bed $1 \
--keep $1_qc1.id \
--extract $1_qc1_geno.prune.in \
--covarFile $2 \
--phenoFile $1.pheno \
--cc12 \
--bsize 100 \
--bt \
--out $1_qc1_regenie_step1_GxSEX
