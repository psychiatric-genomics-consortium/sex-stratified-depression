## Script to run female only GWAS using PLINK2 logistic regression 
## Depression phenotype should be in column 6 of the .fam file
## This file should be used when there was low relatedness in your sample and they were removed using the 2_QC_for_PLINK_GWAS.sh file

## usage:
## $ module load plink2
## $ ./5_PLINK_GWAS_FEMALE.sh {filename} {covariatefilename}
## * note {filename} is the original name of your data without the .bed/.bim/.fam suffix. The {covariatefilename} is the full name of the file
## containing the sex-specific PCs identified as associated with depression using 4_Associated_PCAs.r along with age and any other relevant covariates

plink2 \
--bfile $1_qc1_female \
--glm 'log10' cols=chrom,pos,ax,a1freqcc,totallele,totallelecc,machr2,firth,test,nobs,orbeta,se,p  \
--covar $2 \
--out $1_qc1_female_GWAS
