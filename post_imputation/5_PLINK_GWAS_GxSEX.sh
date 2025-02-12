## Script to run Genotype X Sex interation GWAS using PLINK2 logistic regression 
## Depression phenotype should be in column 6 of the .fam file
## This file should be used when there was low relatedness in your sample and they were removed using the 2_QC_for_PLINK_GWAS.sh file

## THIS CODE WILL NEED THE PARAMETERS LINE EDITED BASED ON NUMBER OF COVARIATES AND POSITION OF SEX IN YOUR COVARIATE FILE
## For example, if you have 10 covariates and sex is the 6th covariate, then {ncovar} is 10 and {sexcovar} is 6
## So this makes the parameters line:
## --parameters 1-11, 17 \
## You can check this has run correctly in the *glm.logistic.hybrid output file with results calculated for ADD, each covariate, and ADDxsex

## usage:
## $ module load plink2
## $ ./5_PLINK_GWAS_GxSEX.sh {filename} {covariatefilename}
## * note {filename} is the original name of your data without the .bed/.bim/.fam suffix. The {covariatefilename} is the full name of the file
## containing the PCs identified as associated with depression using 4_Associated_PCAs.r along with sex, age and any other relevant covariates

plink2 \
--bfile $1_qc1 \
--glm interaction 'log10' cols=chrom,pos,ax,a1freqcc,totallele,totallelecc,machr2,firth,test,nobs,orbeta,se,p  \
--covar $2 \
--parameters 1-{ncovar + 1}, {sexcovar + ncovar + 1} \
--out $1_qc1_GWAS
