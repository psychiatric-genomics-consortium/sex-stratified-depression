## Script to run step 2 of regenie using imputed data for females in bfile format
## This file should be run after running 5_regenie_Step1_FEMALE.sh and checking the .log file for any errors

## usage:
## $ module load regenie
## $ ./5_regenie_Step2_FEMALE.sh filename filename_qc1_female_PCA.covar
## *note filename is the name of your data without the .bed/.bim/.fam suffix. 
## After the filename, the covariate filename is also required and if you have retained the covariate filenames from Step 4,
## then you will only need to update the filename prefix.

regenie \
--step 2 \
--bed $1 \
--keep $1_qc1_female.id \
--extract $1_qc1_female.snplist \
--covarFile $2 \
--phenoFile $1.pheno \
--cc12 \
--bsize 200 \
--bt \
--af-cc \
--firth \
--pThresh 0.05 \
--pred $1_qc1_female_regenie_step1_pred.list \
--out $1_qc1_female_regenie_firth
