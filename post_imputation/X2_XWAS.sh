./xwas-3.0/bin/xwas \
--bfile $1_final_x \
--xwas \
--remove $1_king_unrel.king.cutoff.out.id \
--freq-x \
--out $1_final_X_freq

./xwas-3.0/bin/xwas \
--bfile $1_final_x \
--xwas \
--remove $1_king_unrel.king.cutoff.out.id \
--freqdiff-x 0.05 \
--out $1_final_X_freqdiff

awk '($9 < 0.05 )' $1_final_X_freqdiff.xtest | awk '{print $2}' > $1_final_X_freqdiff.exclude

./xwas-3.0/bin/xwas \
--bfile $1_final_x \
--xwas \
--sex \
--strat-sex \
--remove $1_king_unrel.king.cutoff.out.id \
--exclude $1_final_X_freqdiff.exclude \
--fishers \
--stouffers \
--sex-diff \
--pheno $1.pheno \
--covar $1_qc1_PCA_forX.covar \
--out $1_final_X_xwas

./xwas-3.0/bin/xwas \
--bfile $1_final_x \
--xwas \
--sex \
--xchr-model 2 \
--strat-sex \
--remove $1_king_unrel.king.cutoff.out.id \
--exclude $1_final_X_freqdiff.exclude \
--fishers \
--stouffers \
--sex-diff \
--pheno $1.pheno \
--covar $1_qc1_PCA_forX.covar \
--out $1_final_X_model2
