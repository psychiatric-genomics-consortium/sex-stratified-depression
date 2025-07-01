## Script to run Genotype X Sex interation GWAS using PLINK2 logistic regression
## This file should be used when there was low relatedness in your sample and they were removed using the 2_QC_for_PLINK_GWAS.sh file

## usage:
## $ module load plink2
## $ ./sex-stratified-depression/post_imputation/5_PLINK_GWAS_GxSEX.sh filename filename_qc1_PCA.covar covariate_sex_number

## filename is the name of your data without the .bed/.bim/.fam suffix. 
## After the filename, the covariate filename is also required and 
## if you have retained the covariate filenames from Step 4, then you will only need to update the filename prefix. 
## You will also need to add which number covariate sex is in the covariate file (excluding the FID and IID columns).
## So if the first line of your covariate file is FID, IID, age, batch, sex, PC1, PC2, etc. then you would update covariate_sex_number to 3.

total="$(head -n 1 $2 | wc -w)"
param1=$((total-1))
param2=$((param1+$3))

plink2 \
--bfile $1 \
--pheno $1.pheno \
--keep $1_qc1.id \
--extract $1_qc1.snplist \
--glm interaction 'log10' cols=chrom,pos,omitted,a1freqcc,totallele,totallelecc,machr2,firth,test,nobs,orbeta,se,p  \
--covar $2 \
--parameters 1-$param1, $param2 \
--out $1_qc1_GWAS
