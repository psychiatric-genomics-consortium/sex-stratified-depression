## Script to run step 2 of regenie using imputed data from both sexes in bfile format
## Sex should be added as a covariate in the covariate file.

## usage:
## $ module load regenie
## $ ./5_regenie_Step2_GxSEX.sh {filename} {covariate filename}
## * note {filename} is the original name of your data without the .bed/.bim/.fam suffix. The {covariatefilename} is the full name of the file
## containing the PCs identified as associated with depression using 4_Associated_PCAs.r along with sex, age and any other relevant covariates

regenie \
--step 2 \
--bed $1 \
--keep $1_qc1.id \
--extract $1_qc1.snplist \
--covarFile $2 \
--phenoFile $1.pheno \
--cc12 \
--bsize 200 \
--bt \
--interaction sex[1] \
--af-cc \
--firth \
--pThresh 0.05 \
--pred $1_qc1_regenie_step1_GxSEX_pred.list \
--out $1_qc1_regenie_firth_GxSEX
