## Script to identify a set of variants in linkage equilibrium with a maf > 0.05 and use these to construct PCs using Eigensoft

## usage:
## $ module load plink2
## $ module load eigensoft
## $ ./3_Create_Multi_Ancestry_PCAs.sh filename
## * note filename is the name of your data without the _qc1 and .bed/.bim/.fam suffix

## create file of high LD regions to be excluded for PCA
echo "5 44000000 51500000 r1" > highld_for_exc.txt
echo "6 25000000 33500000 r2" >> highld_for_exc.txt
echo "8 8000000 12000000 r3" >> highld_for_exc.txt
echo "11 45000000 57000000 r4" >> highld_for_exc.txt

## Identify variants in linkage equilibrium with a maf > 0.05
plink2 \
--bfile $1 \
--keep $1_qc1.id \
--exclude range highld_for_exc.txt \
--extract $1_qc1.snplist \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_indep

## Create bed/bim/fam file of independent SNPs with the reference allele as the major allele
plink2 \
--bfile $1 \
--keep $1_qc1.id \
--extract $1_qc1_indep.prune.in \
--maj-ref force \
--snps-only \
--pheno $1.pheno \
--make-bed \
--out $1_qc1_eigen

echo "Independent SNPs identified in full sample"
echo "Converting to eigenstrat format"

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
convertf -p par.file > $1_qc1_eigen_convertf.log 2>&1

## create parameter file to run PCA
echo "genotypename: "$1"_qc1_eigen.geno" > par.file2
echo "snpname: "$1"_qc1_eigen.snp" >> par.file2
echo "indivname: "$1"_qc1_eigen.ind" >> par.file2
echo "evecoutname: "$1"_qc1_eigen.vec" >> par.file2
echo "evaloutname: "$1"_qc1_eigen.val" >> par.file2
echo "numoutevec: 20" >> par.file2

echo "Calculating PCAs for full sample"

## Create PCs with smartpca
smartpca -p par.file2 > $1_qc1_eigen_smartpca.log 2>&1

rm $1_qc1_eigen.bed
rm $1_qc1_eigen.bim
rm $1_qc1_eigen.fam
rm $1_qc1_indep.prune.out
rm $1_qc1_eigen.pedind
rm $1_qc1_eigen.snp
rm $1_qc1_eigen.ind
rm $1_qc1_eigen.geno
rm par.file
rm par.file2

echo "PCAs for full sample complete"

## Females

## Identify variants in linkage equilibrium with a maf > 0.05 for female subset
plink2 \
--bfile $1 \
--keep $1_qc1_female.id \
--exclude range highld_for_exc.txt \
--extract $1_qc1_female.snplist \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_female_indep

## Create female bed/bim/fam file of independent variants that are SNPs and have the reference allele as the major allele
plink2 \
--bfile $1 \
--keep $1_qc1_female.id \
--extract $1_qc1_female_indep.prune.in \
--maj-ref force \
--snps-only \
--pheno $1.pheno \
--make-bed \
--out $1_qc1_female_eigen

echo "Independent SNPs identified in female sample"
echo "Converting to eigenstrat format"

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
convertf -p par.female.file > $1_qc1_female_eigen_convertf.log 2>&1

## create female parameter file to run PCA
echo "genotypename: "$1"_qc1_female_eigen.geno" > par.female.file2
echo "snpname: "$1"_qc1_female_eigen.snp" >> par.female.file2
echo "indivname: "$1"_qc1_female_eigen.ind" >> par.female.file2
echo "evecoutname: "$1"_qc1_female_eigen.vec" >> par.female.file2
echo "evaloutname: "$1"_qc1_female_eigen.val" >> par.female.file2
echo "numoutevec: 20" >> par.female.file2

echo "Calculating PCAs for female sample"

## Create female PCs with smartpca
smartpca -p par.female.file2 > $1_qc1_female_eigen_smartpca.log 2>&1

rm $1_qc1_female_eigen.bed
rm $1_qc1_female_eigen.bim
rm $1_qc1_female_eigen.fam
rm $1_qc1_female_indep.prune.out
rm $1_qc1_female_eigen.pedind
rm $1_qc1_female_eigen.snp
rm $1_qc1_female_eigen.ind
rm $1_qc1_female_eigen.geno
rm par.female.file
rm par.female.file2

echo "PCAs for female sample complete"

## Males

## Identify variants in linkage equilibrium with a maf > 0.05 for male subset
plink2 \
--bfile $1 \
--keep $1_qc1_male.id \
--exclude range highld_for_exc.txt \
--extract $1_qc1_male.snplist \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_male_indep

## Create male bed/bim/fam file of independent variants that are SNPs and have the reference allele as the major allele
plink2 \
--bfile $1 \
--keep $1_qc1_male.id \
--extract $1_qc1_male_indep.prune.in \
--maj-ref force \
--snps-only \
--pheno $1.pheno \
--make-bed \
--out $1_qc1_male_eigen

echo "Independent SNPs identified in male sample"
echo "Converting to eigenstrat format"

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
convertf -p par.male.file > $1_qc1_male_eigen_convertf.log 2>&1

## create male parameter file to run PCA
echo "genotypename: "$1"_qc1_male_eigen.geno" > par.male.file2
echo "snpname: "$1"_qc1_male_eigen.snp" >> par.male.file2
echo "indivname: "$1"_qc1_male_eigen.ind" >> par.male.file2
echo "evecoutname: "$1"_qc1_male_eigen.vec" >> par.male.file2
echo "evaloutname: "$1"_qc1_male_eigen.val" >> par.male.file2
echo "numoutevec: 20" >> par.male.file2

echo "Calculating PCAs for male sample"

## Create male PCs with smartpca
smartpca -p par.male.file2 > $1_qc1_male_eigen_smartpca.log 2>&1

rm $1_qc1_male_eigen.bed
rm $1_qc1_male_eigen.bim
rm $1_qc1_male_eigen.fam
rm $1_qc1_male_indep.prune.out
rm $1_qc1_male_eigen.pedind
rm $1_qc1_male_eigen.snp
rm $1_qc1_male_eigen.ind
rm $1_qc1_male_eigen.geno
rm par.male.file
rm par.male.file2

echo "PCAs for male sample complete"
