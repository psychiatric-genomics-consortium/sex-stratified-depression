## Script to identify second-degree related individuals within imputed data in bfile format using PLINK2
## Sex should be in column 5 and the depression phenotype should be in column 6 of the .fam file
## The script will create a relationship matrix for the whole sample and then identify the related individuals
## usage:
## $ module load plink2
## $ ./1_Relatedness.sh {filename}
## * note {filename} is the original name of your data without the .bed/.bim/.fam suffix

## If > 10% of individuals are related, then it is advised to use regenie for the association analysis to account for relatedness
## If <= 10% of individuals are related, then then related individuals can be removed using 2_Post_Imputation_PLINK_GWAS.sh; with plink used for the association analysis

plink2 \
--bfile $1 \
--prune \
--max-alleles 2 \
--remove-nosex \
--maf 0.01 \
--geno 0.1 \
--mind 0.1 \
--hwe 1e-6 \
--make-king triangle bin \
--out $1_king

plink2 \
--bfile $1 \
--king-cutoff $1_king 0.125 \
--out $1_king_unrel
