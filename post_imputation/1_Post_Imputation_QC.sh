plink2 \
--bfile $1 \
--prune \
--max-alleles 2 \
--remove-nosex \
--maf 0.005 \
--geno 0.1 \
--mind 0.1 \
--hwe 1e-6 \
--make-bed \
--out $1_qc1

plink2 \
--bfile $1 \
--prune \
--max-alleles 2 \
--keep-females \
--maf 0.005 \
--geno 0.1 \
--mind 0.1 \
--hwe 1e-6 \
--make-bed \
--out $1_qc1_female

plink2 \
--bfile $1 \
--prune \
--max-alleles 2 \
--keep-males \
--maf 0.005 \
--geno 0.1 \
--mind 0.1 \
--hwe 1e-6 \
--make-bed \
--out $1_qc1_male
