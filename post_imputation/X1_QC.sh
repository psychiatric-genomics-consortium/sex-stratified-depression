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
