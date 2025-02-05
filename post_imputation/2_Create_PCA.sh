plink2 \
--bfile $1_qc1 \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_indep

plink2 \
--bfile $1_qc1 \
--extract $1_qc1_indep.prune.in \
--pca 20 \
--out $1_qc1_pca

plink2 \
--bfile $1_qc1_female \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_female_indep

plink2 \
--bfile $1_qc1_female \
--extract $1_qc1_female_indep.prune.in \
--pca 20 \
--out $1_qc1_female_pca

plink2 \
--bfile $1_qc1_male \
--maf 0.05 \
--indep-pairwise 200kb 0.5 \
--out $1_qc1_male_indep

plink2 \
--bfile $1_qc1_male \
--extract $1_qc1_male_indep.prune.in \
--pca 20 \
--out $1_qc1_male_pca
