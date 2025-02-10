## Script to identify a set of variants in linkage equilibrium with a maf > 0.05 and use these to construct PCs using Eigensoft

## usage:
## $ module load plink2
## $ module load eigensoft.sh
## $ ./3_Create_Multi_Ancestry_PCAs.sh {filename}
## * note {filename} is the original name of your data without the _qc1 and .bed/.bim/.fam suffix 

## Identify variants in linkage equilibrium with a maf > 0.05
plink2 \
--bfile $1_qc1 \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_indep

## Create bed/bim/fam file of independent variants that are SNPs and have the reference allele as the major allele
plink2 \
--bfile $1_qc1 \
--extract $1_qc1_indep.prune.in \
--maj-ref force \
--snps-only \
--make-bed \
--out $1_qc1_eigen

## copy .pedind file from .fam file 
cp $1_qc1_eigen.fam $1_qc1_eigen.pedind

## create par.file for convertf
echo "genotypename: "$1"_qc1_eigen.bed" > par.file
echo "snpname: "$1"_qc1_eigen.bim" >> par.file
echo "indivname: "$1"_qc1_eigen.pedind" >> par.file
echo "outputformat: EIGENSTRAT" >> par.file
echo "genotypeoutname: "$1"_qc1_eigen.geno" >> par.file
echo "snpoutname: "$1"_qc1_eigen.snp" >> par.file
echo "indivoutname: "$1"_qc1_eigen.ind" >> par.file
echo "familynames: YES" >> par.file

## run convertf to create eigenstrat format from plink format
convertf -p par.file

## create parameter file to run PCA
echo "genotypename: "$1"_qc1_eigen.geno" > par.file2
echo "snpname: "$1"_qc1_eigen.snp" >> par.file2
echo "indivname: "$1"_qc1_eigen.ind" >> par.file2
echo "evecoutname: "$1"_qc1_eigen.vec" >> par.file2
echo "evaloutname: "$1"_qc1_eigen.val" >> par.file2
echo "numoutevec: 20" >> par.file2

## Create PCs with smartpca
smartpca -p par.file2

## Females

## Identify variants in linkage equilibrium with a maf > 0.05 for female subset
plink2 \
--bfile $1_qc1_female \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_female_indep

## Create female bed/bim/fam file of independent variants that are SNPs and have the reference allele as the major allele
plink2 \
--bfile $1_qc1_female \
--extract $1_qc1_female_indep.prune.in \
--maj-ref force \
--snps-only \
--make-bed \
--out $1_qc1_female_eigen

## copy .pedind file from .fam file 
cp $1_qc1_female_eigen.fam $1_qc1_female_eigen.pedind

## create par.female.file for convertf
echo "genotypename: "$1"_qc1_female_eigen.bed" > par.female.file
echo "snpname: "$1"_qc1_female_eigen.bim" >> par.female.file
echo "indivname: "$1"_qc1_female_eigen.pedind" >> par.female.file
echo "outputformat: EIGENSTRAT" >> par.female.file
echo "genotypeoutname: "$1"_qc1_female_eigen.geno" >> par.female.file
echo "snpoutname: "$1"_qc1_female_eigen.snp" >> par.female.file
echo "indivoutname: "$1"_qc1_female_eigen.ind" >> par.female.file
echo "familynames: YES" >> par.female.file

## run convertf to create eigenstrat format from plink format
convertf -p par.female.file

## create female parameter file to run PCA
echo "genotypename: "$1"_qc1_female_eigen.geno" > par.female.file2
echo "snpname: "$1"_qc1_female_eigen.snp" >> par.female.file2
echo "indivname: "$1"_qc1_female_eigen.ind" >> par.female.file2
echo "evecoutname: "$1"_qc1_female_eigen.vec" >> par.female.file2
echo "evaloutname: "$1"_qc1_female_eigen.val" >> par.female.file2
echo "numoutevec: 20" >> par.female.file2

## Create female PCs with smartpca
smartpca -p par.female.file2

## Males

## Identify variants in linkage equilibrium with a maf > 0.05 for male subset
plink2 \
--bfile $1_qc1_male \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_male_indep

## Create male bed/bim/fam file of independent variants that are SNPs and have the reference allele as the major allele
plink2 \
--bfile $1_qc1_male \
--extract $1_qc1_male_indep.prune.in \
--maj-ref force \
--snps-only \
--make-bed \
--out $1_qc1_male_eigen

## copy .pedind file from .fam file 
cp $1_qc1_male_eigen.fam $1_qc1_male_eigen.pedind

## create par.male.file for convertf
echo "genotypename: "$1"_qc1_male_eigen.bed" > par.male.file
echo "snpname: "$1"_qc1_male_eigen.bim" >> par.male.file
echo "indivname: "$1"_qc1_male_eigen.pedind" >> par.male.file
echo "outputformat: EIGENSTRAT" >> par.male.file
echo "genotypeoutname: "$1"_qc1_male_eigen.geno" >> par.male.file
echo "snpoutname: "$1"_qc1_male_eigen.snp" >> par.male.file
echo "indivoutname: "$1"_qc1_male_eigen.ind" >> par.male.file
echo "familynames: YES" >> par.male.file

## run convertf to create eigenstrat format from plink format
convertf -p par.male.file

## create male parameter file to run PCA
echo "genotypename: "$1"_qc1_male_eigen.geno" > par.male.file2
echo "snpname: "$1"_qc1_male_eigen.snp" >> par.male.file2
echo "indivname: "$1"_qc1_male_eigen.ind" >> par.male.file2
echo "evecoutname: "$1"_qc1_male_eigen.vec" >> par.male.file2
echo "evaloutname: "$1"_qc1_male_eigen.val" >> par.male.file2
echo "numoutevec: 20" >> par.male.file2

## Create male PCs with smartpca
smartpca -p par.male.file2
