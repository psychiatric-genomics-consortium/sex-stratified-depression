## Script to run step 2 of regenie using imputed data for females in bfile format
## This file should be run after running 5_regenie_Step1_FEMALE.sh and checking the .log file for any errors 

## usage:
## $ module load regenie
## $ ./5_regenie_Step2_FEMALE.sh {filename} {covariate filename}
## * note {filename} is the original name of your data without the .bed/.bim/.fam suffix. The {covariatefilename} is the full name of the file
## containing the PCs identified as associated with depression using 4_Associated_PCAs.r along with age and any other relevant covariates

regenie \
--step 2 \
--bed $1_qc1_female \
--covarFile $2 \
--phenoFile $1_qc1_female.pheno \
--cc12 \
--bsize 200 \
--bt \
--af-cc \
--firth \
--pThresh 0.05 \
--pred $1_qc1_female_regenie_step1_pred.list \
--out $1_qc1_female_regenie_firth
