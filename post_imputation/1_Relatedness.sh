## Script to identify second-degree related individuals within imputed data in bfile format using PLINK2
## Sex should be in column 5
## A three column depression phenotype file (Family ID, Individuals ID, depression status (control = 1, case = 2))
## is expected and will need to have the same name as your imputed data with a .pheno suffix.

## The script will create a relationship matrix for the whole sample and then identify the related individuals
## usage:
## $ module load plink2
## $ ./1_Relatedness.sh {filename}
## * note {filename} is the name of your data file without the .bed/.bim/.fam suffix

## You should compare the number of individuals in your .fam file to the number of individuals listed in the file suffixed with king.cutoff.out.id
## If > 10% of individuals are related, then it is advised to use regenie for the association analysis to account for relatedness and analysing the whole sample
## If <= 10% of individuals are related, then then related individuals can be removed using 2_Post_Imputation_QC_PLINK_GWAS.sh; with plink used for the association analysis

plink2 \
--bfile $1 \
--pheno $1.pheno \
--prune \
--max-alleles 2 \
--remove-nosex \
--chr 1-22 \
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

rm $1_king.king.*
rm $1_king_unrel.king.cutoff.in.id
