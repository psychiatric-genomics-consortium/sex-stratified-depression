## Script to run step 2 of regenie using imputed data from both sexes in bfile format
## Sex should be added as a covariate in the covariate file.

## usage:
## $ module load regenie
## $ ./5_regenie_Step2_GxSEX.sh filename filename_qc1_PCA.covar
## *note filename is the name of your data without the .bed/.bim/.fam suffix. 
## After the filename, the covariate filename is also required and if you have retained the covariate filenames from Step 4,
## then you will only need to update the filename prefix.

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
