## Script to identify a set of variants in linkage equilibrium with a maf > 0.05 and use these to construct PCs using PLINK2

## usage:
## $ module load plink2
## $ ./3_Create_Single_Ancestry_PCAs.sh filename
## * note filename is the name of your data without the _qc and .bed/.bim/.fam suffix

## create file of high LD regions to be excluded for PCA
echo "5 44000000 51500000 r1" > highld_for_exc.txt
echo "6 25000000 33500000 r2" >> highld_for_exc.txt
echo "8 8000000 12000000 r3" >> highld_for_exc.txt
echo "11 45000000 57000000 r4" >> highld_for_exc.txt

## Identify variants in linkage equilibrium with a maf > 0.05
plink2 \
--bfile $1 \
--keep $1_qc.id \
--exclude range highld_for_exc.txt \
--extract $1_qc.snplist \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc_indep

## Use independent variants to create PCs
plink2 \
--bfile $1 \
--keep $1_qc.id \
--extract $1_qc_indep.prune.in \
--pca 20 \
--out $1_qc_pca

## Identify variants in linkage equilibrium with a maf > 0.05 in females
plink2 \
--bfile $1 \
--keep $1_qc_female.id \
--exclude range highld_for_exc.txt \
--extract $1_qc_female.snplist \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc_female_indep

## Use independent variants to create PCs in females
plink2 \
--bfile $1 \
--keep $1_qc_female.id \
--extract $1_qc_female_indep.prune.in \
--pca 20 \
--out $1_qc_female_pca

## Identify variants in linkage equilibrium with a maf > 0.05 in males
plink2 \
--bfile $1 \
--keep $1_qc_male.id \
--exclude range highld_for_exc.txt \
--extract $1_qc_male.snplist \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc_male_indep

## Use independent variants to create PCs in males
plink2 \
--bfile $1 \
--keep $1_qc_male.id \
--extract $1_qc_male_indep.prune.in \
--pca 20 \
--out $1_qc_male_pca
