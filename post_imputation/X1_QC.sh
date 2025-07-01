## Script to apply quality control to the X chromosome.
## Imputed data should be hard called bed/bim/fam format aligned with genome build 19
## Sex should be in column 5

## QC removes:
## PAR regions
## individuals with unknown sex
## individuals with more than 10% missing variants
## variants with maf < 0.005
## variants with a missing rate > 0.1
## variants with significantly different frequencies between the sexes

## usage:
## $ ./X1_QC.sh filename
## * note filename is the name of your data file without the .bed/.bim/.fam suffix

echo "filename $1" > params_qc.txt
echo "xwasloc xwas-3.0/bin/" >> params_qc.txt
echo "exclind 0" >> params_qc.txt
echo "build 19" >> params_qc.txt
echo "alpha 0.05" >> params_qc.txt
echo "plinkformat bed" >> params_qc.txt
echo "maf 0.005" >> params_qc.txt
echo "missindiv 0.10" >> params_qc.txt
echo "missgeno 0.10" >> params_qc.txt
echo "quant 0" >> params_qc.txt

./xwas-3.0/bin/xwas_qc.post_imputation.sh params_qc.txt
