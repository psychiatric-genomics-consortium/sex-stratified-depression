## Script to run male only GWAS using PLINK2 logistic regression
## This file should be used when there was low relatedness in your sample and they were removed using the 2_QC_for_PLINK_GWAS.sh file

## usage:
## $ module load plink2
## $ ./sex-stratified-depression/post_imputation/5_PLINK_GWAS_MALE.sh filename filename_qc1_male_PCA.covar

## filename is the original name of your data without the .bed/.bim/.fam suffix. After the filename, the covariate filename is also required and 
## if you have retained the covariate filenames from Step 4, then you will just need to update the filename prefix.

plink2 \
--bfile $1 \
--pheno $1.pheno \
--keep $1_qc1_male.id \
--extract $1_qc1_male.snplist \
--glm 'log10' cols=chrom,pos,omitted,a1freqcc,totallele,totallelecc,machr2,firth,test,nobs,orbeta,se,p  \
--covar $2 \
--out $1_qc1_male_GWAS
