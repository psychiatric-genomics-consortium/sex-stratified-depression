plink2 \
--bfile $1_qc1 \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_indep

plink2 \
--bfile $1_qc1 \
--extract $1_qc1_indep.prune.in \
--maj-ref force \
--snps-only \
--make-bed \
--out $1_qc1_eigen

cp $1_qc1_eigen.fam $1_qc1_eigen.pedind

echo "genotypename: "$1"_qc1_eigen.bed" > par.file
echo "snpname: "$1"_qc1_eigen.bim" >> par.file
echo "indivname: "$1"_qc1_eigen.pedind" >> par.file
echo "outputformat: EIGENSTRAT" >> par.file
echo "genotypeoutname: "$1"_qc1_eigen.geno" >> par.file
echo "snpoutname: "$1"_qc1_eigen.snp" >> par.file
echo "indivoutname: "$1"_qc1_eigen.ind" >> par.file
echo "familynames: YES" >> par.file

convertf -p par.file

echo "genotypename: "$1"_qc1_eigen.geno" > par.file2
echo "snpname: "$1"_qc1_eigen.snp" >> par.file2
echo "indivname: "$1"_qc1_eigen.ind" >> par.file2
echo "evecoutname: "$1"_qc1_eigen.vec" >> par.file2
echo "evaloutname: "$1"_qc1_eigen.val" >> par.file2
echo "numoutevec: 20" >> par.file2

smartpca -p par.file2

## Females

plink2 \
--bfile $1_qc1_female \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_female_indep

plink2 \
--bfile $1_qc1_female \
--extract $1_qc1_female_indep.prune.in \
--maj-ref force \
--snps-only \
--make-bed \
--out $1_qc1_female_eigen

cp $1_qc1_female_eigen.fam $1_qc1_female_eigen.pedind

echo "genotypename: "$1"_qc1_female_eigen.bed" > par.female.file
echo "snpname: "$1"_qc1_female_eigen.bim" >> par.female.file
echo "indivname: "$1"_qc1_female_eigen.pedind" >> par.female.file
echo "outputformat: EIGENSTRAT" >> par.female.file
echo "genotypeoutname: "$1"_qc1_female_eigen.geno" >> par.female.file
echo "snpoutname: "$1"_qc1_female_eigen.snp" >> par.female.file
echo "indivoutname: "$1"_qc1_female_eigen.ind" >> par.female.file
echo "familynames: YES" >> par.female.file

convertf -p par.female.file

echo "genotypename: "$1"_qc1_female_eigen.geno" > par.female.file2
echo "snpname: "$1"_qc1_female_eigen.snp" >> par.female.file2
echo "indivname: "$1"_qc1_female_eigen.ind" >> par.female.file2
echo "evecoutname: "$1"_qc1_female_eigen.vec" >> par.female.file2
echo "evaloutname: "$1"_qc1_female_eigen.val" >> par.female.file2
echo "numoutevec: 20" >> par.female.file2

smartpca -p par.female.file2

## Males

plink2 \
--bfile $1_qc1_male \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_male_indep

plink2 \
--bfile $1_qc1_male \
--extract $1_qc1_male_indep.prune.in \
--maj-ref force \
--snps-only \
--make-bed \
--out $1_qc1_male_eigen

cp $1_qc1_male_eigen.fam $1_qc1_male_eigen.pedind

echo "genotypename: "$1"_qc1_male_eigen.bed" > par.male.file
echo "snpname: "$1"_qc1_male_eigen.bim" >> par.male.file
echo "indivname: "$1"_qc1_male_eigen.pedind" >> par.male.file
echo "outputformat: EIGENSTRAT" >> par.male.file
echo "genotypeoutname: "$1"_qc1_male_eigen.geno" >> par.male.file
echo "snpoutname: "$1"_qc1_male_eigen.snp" >> par.male.file
echo "indivoutname: "$1"_qc1_male_eigen.ind" >> par.male.file
echo "familynames: YES" >> par.male.file

convertf -p par.male.file

echo "genotypename: "$1"_qc1_male_eigen.geno" > par.male.file2
echo "snpname: "$1"_qc1_male_eigen.snp" >> par.male.file2
echo "indivname: "$1"_qc1_male_eigen.ind" >> par.male.file2
echo "evecoutname: "$1"_qc1_male_eigen.vec" >> par.male.file2
echo "evaloutname: "$1"_qc1_male_eigen.val" >> par.male.file2
echo "numoutevec: 20" >> par.male.file2

smartpca -p par.male.file2
