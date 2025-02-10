## Script to identify a set of variants in linkage equilibrium with a maf > 0.05 and use these to construct PCs using PLINK2

## usage:
## $ module load plink2
## $ ./3_Create_Single_Ancestry_PCAs.sh {filename}
## * note {filename} is the original name of your data without the _qc1 and .bed/.bim/.fam suffix 

## Identify variants in linkage equilibrium with a maf > 0.05
plink2 \
--bfile $1_qc1 \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_indep

## Use independent variants to create PCs
plink2 \
--bfile $1_qc1 \
--extract $1_qc1_indep.prune.in \
--pca 20 \
--out $1_qc1_pca

## Identify variants in linkage equilibrium with a maf > 0.05 in females
plink2 \
--bfile $1_qc1_female \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_female_indep

## Use independent variants to create PCs in females
plink2 \
--bfile $1_qc1_female \
--extract $1_qc1_female_indep.prune.in \
--pca 20 \
--out $1_qc1_female_pca

## Identify variants in linkage equilibrium with a maf > 0.05 in males
plink2 \
--bfile $1_qc1_male \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_male_indep

## Use independent variants to create PCs in males
plink2 \
--bfile $1_qc1_male \
--extract $1_qc1_male_indep.prune.in \
--pca 20 \
--out $1_qc1_male_pca
