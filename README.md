# PGC - Sex-stratified GWAS of depression 
Major Depressive Disorder (MDD) is more common in women, with a lifetime prevalence nearly twice as high than in men (7.2% to 4.3%). It would be valuable to consider how common genetic variation influences liability to MDD on a sex-specific basis. GWAS has reached a point where adequate power may be available to identify risk loci which exhibit sex specific effects, differences in heritability, and patterns of genetic correlations.

The goals of this research are to investigate sex specific risk loci for Major Depression. We propose to perform genetic discovery using GWAS approaches and meta-analysis in a sex stratified fashion on the autosomes. We will use a combined approach of using available individual data from the Psychiatric Genomics Consortium to stratify by sex as well as allowing for sex stratified summary statistics to be contributed by groups not already sharing individual level data. Additionally a genotype-by-sex interaction analysis will be performed.

Where possible, we will use XWAS to move beyond autosomal differences to investigate the X chromosome in genotyped samples with available data. LDSC will be used to calculate heritabilities and phenome-wide comparative genetic correlation between sex stratified analyses.  MAGMA will be used to investigate tissue enrichments. We will calculate and compare effect sizes at discovered loci as well as heritability and genetic correlations. 

### Embargo

Results cannot be shared, presented, or published in any way without explicit permission from Joel Gelernter, Dan Levey, Murray Stein, or David Howard.

## Imputation

If your data is already imputed then skip to the [Post Imputation Steps](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression#post-imputation-steps), although the tools, reference panels, and parameters used for imputation should be reported to the lead authors.

Imputation should be performed using the ricopili pipeline. See below for instructions: 

[Website](https://sites.google.com/a/broadinstitute.org/ricopili/overview)

[Tutorial](https://docs.google.com/document/d/1ux_FbwnvSzaiBVEwgS7eWJoYlnc_o0YHFb07SPQsYjI/edit?tab=t.0#heading=h.tkgxq8x9kt6n)

[Manuscript](https://academic.oup.com/bioinformatics/article/36/3/930/5545088)

Imputation is a multi-stage process of pre-imputation quality control, PCA, and imputation. Analysts should familiarise themselves with the ricopili documentation shown above.  

The default settings should be used for the ‘preimp’ and ‘pca’ modules.

A detailed QC report will be generated during the ‘preimp’ stage and will be placed in the ‘qc/’ subdirectory and this report should be shared with the lead authors to aid with manuscript writing. Any ‘amber’ and ‘red’ flags should be examined, and steps should be taken (see ricopili tutorial) to address the identified issues. Please keep a record of the steps taken and share those with the lead authors.

To conduct the imputation, the largest reference panel suitable for the ancestry of your data should be used. For example, for European ancestry data the HRC panel should be used, whilst other ancestries are generally better represented using the relevant 1000 genomes panel. Please record which panel was used and report this to the lead authors.

The imputed data should be converted to best guess/hard called genotypes with variants with an imputation accuracy (INFO) score less than 0.6 removed.

If you have X chromosome data, then the imputation should be conducted separately for males and females and follow the guidance provided [here](https://docs.google.com/document/d/1qeQFfvqNI2Lkp6XCYXmnGoEL3f9LRPJcMpwRk0rnJf4/edit?tab=t.0#heading=h.eti7izkzx2ko)

## Post Imputation Steps
### Autosomal chromosomes

The ricopili imputation pipeline lifts the data over the build to hg19. If a different tool was used for imputation, then you will need to check that your data is aligned with build hg19. If your data is not using build hg19, then visit: https://genome.sph.umich.edu/wiki/LiftOver which contains guidance on how best to update the genome build for your data.

We have prepared [sample code](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/tree/master/post_imputation) based on [PLINK2](https://www.cog-genomics.org/plink/2.0/), [eigensoft](https://github.com/DReichLab/EIG), [R](https://www.r-project.org/), [regenie](https://rgcgithub.github.io/regenie/options/), and [XWAS](https://github.com/KeinanLab/xwas-3.0) which can be cloned using the code below. There are comments at the top of each sample code with instructions. The guidance below assumes you will have launched an interactive session to run each sample code.

The format of the results files, naming conventions, and what to return to us is provided [lower down the page](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression#format-of-the-results-files-and-naming-conventions). Please also prepare a readme file to accompany the summary statistics based on this [description](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression#readme-file).

It is advised to create a working directory to which you have read, write and execute access for the analysis and then move into that directory:

```
mkdir SexStratAnalysis
cd SexStratAnalysis
```

Next set up symbolic links to your imputed genome-wide data, updating the file path and the filename you wish to use below.

```
ln -s path_to_your_bed_file.bed filename.bed
ln -s path_to_your_bim_file.bim filename.bim
ln -s path_to_your_fam_file.fam filename.fam
```

and then clone the sample code repository using:
```
git clone https://github.com/psychiatric-genomics-consortium/sex-stratified-depression.git
```

The sample code expects your imputed data to be in best guess/hard called bed/bim/fam PLINK format with sex in column 5 (male = 1, female = 2) of the fam file. The sample code expects the chromosomes to be merged so that there is a single set of bed/bim/fam files containing genome-wide data. regenie may fail if your data includes variants that are listed as being on chromosomes 24 and above and so those variants should be removed. 

The sample code requires that the relevant software has been loaded using ```module load software```. You can use ```module spider software``` to check whether the software is installed on your server and find it's location. If the software isn't available, then you will need to download and install the software and update the sample code to point to the relevant executable.

All sample code should be treated as a beta testing software release. All log and output files should be checked carefully to make sure the code has performed as expected for your data.

A three column depression phenotype file (Family ID, Individuals ID, depression status (control = 1, case = 2)) is required in the working directory and will need to have the same filename as your imputed data with a .pheno suffix. A header row in the phenotype file is optional if you are planning to use PLINK for the GWAS, but regenie will require a header row (FID, IID, depression).

The schematic below illustrates the analysis pipeline for the autosomal chromosomes:

![Image](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/pipeline.png)
 
#### Step 1

Step 1 is to examine your data to determine the proportion of second-degree relatives in your data using the KING-robust kinship estimator in PLINK. This can be performed using the [1_Relatedness.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/1_Relatedness.sh) sample code by running the code below. You are likely to need to update the software name (in this instance plink2) to match that used on your server and the filename prefix (i.e. leave off bed/bim/fam) in all subsequent code snippets.

```
module load plink2
./sex-stratified-depression/post_imputation/1_Relatedness.sh filename
```

To identify the proportion of relatives you will need to compare the number of individuals written to *king.cutoff.out.id with the number of individuals in the fam file. Note that’s the *king.cutoff.out.id contains a header row so you will need to subtract 1 if you use ```wc -l * king.cutoff.out.id``` to count the number of rows. The proportion of relatves can also be calculated using the following code:

```
fam_rows=$(wc -l "filename.fam" | awk '{print $1}')
removed_ind=$(wc -l "filename_king_unrel.king.cutoff.out.id" | awk '{print $1-1}')
echo "scale=3; $removed_ind / $fam_rows" | bc -l
```

If the proportion of related individuals is less than or equal to 0.1 of the whole sample, then you can opt to remove them and run the GWAS using PLINK. If your sample contains more than 0.1 related individuals, then regenie is the preferred way to conduct the GWAS. You can also opt to use regenie regardless of the relatedness in your sample thereby keeping all samples.

#### Step 2

Step 2 is to apply quality control to prepare the data for either a PLINK (removing relatives) or a regenie GWAS (not removing relatives). The quality control removes individuals that aren’t phenotyped, don’t have a recorded sex or have an individual call rate less than 10%. Variants are removed which have a minor allele frequency < 0.005, have a variant call rate less than 10%, that are out of Hardy-Weinberg equilibrium with _P_ < 10<sup>-6</sup>, or that aren’t biallelic. Two additional subsamples are also created: one for males only and one for females only with the quality control applied to each of those subsamples. 

To prepare for a PLINK GWAS use [2_QC_for_PLINK_GWAS.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/2_QC_for_PLINK_GWAS.sh) by running:

```
module load plink2
./sex-stratified-depression/post_imputation/2_QC_for_PLINK_GWAS.sh filename
```

**OR** to prepare for a regenie GWAS use [2_QC_for_regenie_GWAS.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/2_QC_for_regenie_GWAS.sh) by running:

```
module load plink2
./sex-stratified-depression/post_imputation/2_QC_for_regenie_GWAS.sh filename
```

#### Step 3

Step 3 is to obtain the first 20 genetic principal components (PCs). If the ricopili pipeline was used, these PCs are created during the ‘pca’ module and stored in pacer_{filename}/{filename.menv.mvs} and these can be used. If you don’t have access to these PCs or didn’t use ricopili, then the PCs can be created below. If your data was obtained from a single ancestry, then PLINK can be used. If your data contains individuals from multiple ancestries, then eigensoft is recommended. The PCs are created from SNPs that are in linkage equilibrium (using 200kb window and r2 threshold of 0.5), have a minor allele frequency > 0.05, and are not located in high LD regions (based on https://github.com/gabraham/flashpca/blob/master/exclusion_regions_hg19.txt).

To create PCs for a single ancestry cohort use [3_Create_Single_Ancestry_PCAs.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/3_Create_Single_Ancestry_PCAs.sh) by running:

```
module load plink2
./sex-stratified-depression/post_imputation/3_Create_Single_Ancestry_PCAs.sh filename
```

**OR** to create PCs for a multi ancestry cohort use [3_Create_Multi_Ancestry_PCAs.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/3_Create_Multi_Ancestry_PCAs.sh) by running:

```
module load plink2
module load eigensoft
./sex-stratified-depression/post_imputation/3_Create_Multi_Ancestry_PCAs.sh filename
```

#### Step 4

Step 4 is to determine the PCs that will be included as covariates in the GWAS. The first 4 PCs and thereafter each component nominally associated (_P_ < 0.05) with case-control status should be included. A logistic regression of depression status on each component in turn should be used to determine an association and if you ran Step 3, this can be achieved using the [4_Associated_PCAs.r](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/4_Associated_PCAs.r) R code by running:

```
module load r
Rscript ./sex-stratified-depression/post_imputation/4_Associated_PCAs.r filename
```

It is then down to the analyst to prepare a final covariate file, combining the outputted PCs with any other appropriate covariates for their cohort, such as age, genotyping batch, etc. The final covariate files needs to be space separated and have a header row, with the first two columns containing FID and IID, with the remaining columns containing the associated PCs and any other covariates. For the whole sample genotype-by-sex interaction analysis, sex (1 = male, 2 = female) is automatically added as a covariate based on column 5 in the .fam file. Sex shouldn't be included in the other (male only, female only, and X chromosome) covariate files. 

#### Step 5

Step 5 is to run the GWAS. There are three association analyses to be performed: whole sample with a genotype-by-sex interaction, male-only, and female-only. If your sample includes only one sex, then only an analysis of that sex is possible. File formats and naming conventions are provided at the end of the document, and these should be followed as closely as possible.

Option 1 - **PLINK**

If related individuals were removed in step 2, then run [5_PLINK_GWAS_GxSEX.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/5_PLINK_GWAS_GxSEX.sh), [5_PLINK_GWAS_FEMALE.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/5_PLINK_GWAS_FEMALE.sh), and [5_PLINK_GWAS_MALE.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/5_PLINK_GWAS_MALE.sh) using the code below. After the filename, the covariate filename is also required and if you have retained the covariate filenames from Step 4, then you will only need to update the filename prefix. For the GxSEX analysis, you will also need to add which number covariate sex is, excluding the FID and IID columns. So if the first line of your covariate file is FID, IID, age, batch, sex, PC1, PC2, etc. then you would update covariate_sex_number below to 3. If your depression phenotype is also in column six of the fam file, you will need to delete the lines starting --pheno from the sample code, otherwise the GWAS will be performed twice with two identical outputs.

```
module load plink2
./sex-stratified-depression/post_imputation/5_PLINK_GWAS_GxSEX.sh filename filename_qc_PCA.covar covariate_sex_number
./sex-stratified-depression/post_imputation/5_PLINK_GWAS_FEMALE.sh filename filename_qc_female_PCA.covar
./sex-stratified-depression/post_imputation/5_PLINK_GWAS_MALE.sh filename filename_qc_male_PCA.covar
```

Option 2 - **regenie**

If you have relatedness in your sample or you are intending to use **regenie** for the GWAS, then there are multiple stages to this analysis. Firstly, a genomic relationship matrix is created using the original genotyped variants. You need to create a single-column list of genotyped variants’ IDs for your data and save it in a file called genotypedvariants.txt with no header row in your working directory.

Then running [5_regenie_Prep_Geno.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/5_regenie_Prep_Geno.sh) using the code below will apply the following quality control: (minor allele frequency of ≥ 1%, a Hardy–Weinberg equilibrium test with _P_ ≥ 10<sup>−15</sup>, a variant call rate above 99%, and LD pruned using a R<sup>2</sup> threshold of 0.9 with a window size of 1,000 markers and a step size of 100 markers.

```
module load plink2
./sex-stratified-depression/post_imputation/5_regenie_Prep_Geno.sh filename
```

Next you need to run step 1 of regenie for the three analyses using the code below. After the filename, the covariate filename is also required and if you have retained the covariate filenames from Step 4 of the autosomal analysis, then you will only need to update the filename prefix. If regenie fails at this point, it may be due to variants listed as being on chromosomes 24 and above in your data and so those should be removed.

```
module load regenie
./sex-stratified-depression/post_imputation/5_regenie_Step1_GxSEX.sh filename filename_qc_PCA.covar
./sex-stratified-depression/post_imputation/5_regenie_Step1_FEMALE.sh filename filename_qc_female_PCA.covar
./sex-stratified-depression/post_imputation/5_regenie_Step1_MALE.sh filename filename_qc_male_PCA.covar
```

followed by step 2 of regenie below. After the filename, the covariate filename is also required and if you have retained the covariate filenames from Step 4, then you will only need to update the filename prefix.

```
module load regenie
./sex-stratified-depression/post_imputation/5_regenie_Step2_GxSEX.sh filename filename_qc_PCA.covar
./sex-stratified-depression/post_imputation/5_regenie_Step2_FEMALE.sh filename filename_qc_female_PCA.covar
./sex-stratified-depression/post_imputation/5_regenie_Step2_MALE.sh filename filename_qc_male_PCA.covar
```

### X chromosome

The ricopili imputation pipeline lifts the data over the build to hg19. If a different tool was used for imputation, then you will need to check that your data is aligned with build hg19. If your data is not using build hg19, then visit: https://genome.sph.umich.edu/wiki/LiftOver which contains guidance on how best to update the genome build for your data.

It is assumed that you will have already run the analysis of the autosomal chromosomes as some of that output (list of related individuals and covariate file) are reused here. 

The XWAS software (https://github.com/KeinanLab/xwas-3.0) is recommended for the quality control and association analysis and a useful [manual](https://github.com/KeinanLab/xwas-3.0/blob/master/XWAS_manual_v3.0.pdf) is available.

From your existing working directory clone the XWAS repository from Github using:

```
git clone https://github.com/KeinanLab/xwas-3.0.git
```

We have prepared sample code for the remaining steps, located here: [post_imputation](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/tree/master/post_imputation). The sample code will have been cloned to your working directory during the autosomal steps [above](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression#autosomal-chromosomes). There are comments at the top of each sample code with instructions. The sample code expects genome-wide (autosomes plus the X chromosome) imputed data to be in best guess/hard called bed/bim/fam PLINK format with sex in column 5 (male = 1, female = 2) of the fam file. 

A three column depression phenotype file (Family ID, Individuals ID, depression status (control = 1, case = 2)) is required in the working directory and will need to have the same name as your imputed data with a .pheno suffix. A header row in the phenotype file is optional.

All sample code should be treated as a beta testing software release. All log and output files should be checked carefully to make sure the code has performed as expected for your data. 

#### Step X1

Step X1 is to run quality control on your data. Information on post-imputation QC is in section 5.3 in the XWAS manual. The [X1_QC.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/X1_QC.sh) sample code will perform the recommended quality control by running:

```
./sex-stratified-depression/post_imputation/X1_QC.sh filename
```

#### Step X2

Step X2 is to conduct the association analysis of the X chromosome. Section 6 of the XWAS [manual](https://github.com/KeinanLab/xwas-3.0/blob/master/XWAS_manual_v3.0.pdf) provides further details on the variant association testing. The [X2_XWAS.sh](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression/blob/master/post_imputation/X2_XWAS.sh) sample code will perform the recommended analyses of the X chromosome by running the code below. After the filename, the covariate filename is also required and if you have retained the covariate filenames created during Step 4 of the autosomal analysis, then you will only need to update the filename prefix for the covariate filename. Sex should not be included as a covariate in the covariate file.

```
./sex-stratified-depression/post_imputation/X2_XWAS.sh filename filename_qc_PCA_forX.covar
```

### Format of the results files and naming conventions

#### PLINK

If you ran the GWAS using PLINK and have both sexes in your data then there should be 3 summary statistic files:

```
filename_qc_GWAS.PHENO1.glm.logistic.hybrid
filename_qc_female_GWAS.PHENO1.glm.logistic.hybrid
filename_qc_male_GWAS.PHENO1.glm.logistic.hybrid
```

If you have only one sex available then you will just have a single summary statistic file for that sex.

These summary statistic files along with the respective GWAS log files should be archived and compressed to a folder. The folder name should take the following naming convention: COHORT[-SUBCOHORT]_CLUSTER_SEX_VERSION.PLINK where

* COHORT: abbreviation or code for cohort name. E.g., UK Biobank = UKBB, Generation Scotland = GenScot

* SUBCOHORT: Subcohort or substudy name, separated from cohort abbreviation by a hyphen (optional). For example, for GenScot: Scottish Family Health Study = -SFHS ("GenScot-SFHS").  Only required if submitting multiple sumstats files from subcohorts that are part of the same study.

* CLUSTER: Genetic similarity cluster abbreviation (three letter code, upper case; i.e., AFR, AMR, CSE, EAS, EUR, MID, HIS, SAS).

* SEX: FEMALE, MALE, or BOTH

*	VERSION: Version identifier for this analysis, to indicate dataset release / analyst / date etc. Examples: UK Biobank → ukb21007-hrc-noPGC,  Biobank Japan → SakaueKanai2020, FinnGen → R12.

For COHORT, SUBCOHORT, and VERSION, use only letters, numbers, and hyphens (no spaces, periods, underscores, or other punctuation).

To archive and compress the summary statistics and log files use:

```
tar cvzf COHORT[-SUBCOHORT]_CLUSTER_SEX_VERSION.PLINK.tgz *_GWAS*
```

Please also prepare a readme file to accompany the summary statistics based on this [description](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression#readme-file).

#### regenie

If you ran the GWAS using regenie and have both sexes in your data then there should be 3 summary statistic files:

```
filename_qc_regenie_firth_GxSEX_phenotype.regenie
filename_qc_female_regenie_firth_phenotype.regenie
filename_qc_male_regenie_firth_phenotype.regenie
```

If you have only one sex available then you will just have a single summary statistic file for that sex.

These summary statistic files along with the respective GWAS log files should be archived and compressed to a folder. The folder name should take the following naming convention: COHORT[-SUBCOHORT]_CLUSTER_SEX_VERSION.regenie where

* COHORT: abbreviation or code for cohort name. E.g., UK Biobank = UKBB, Generation Scotland = GenScot

* SUBCOHORT: Subcohort or substudy name, separated from cohort abbreviation by a hyphen (optional). For example, for GenScot: Scottish Family Health Study = -SFHS ("GenScot-SFHS").  Only required if submitting multiple sumstats files from subcohorts that are part of the same study.

* CLUSTER: Genetic similarity cluster abbreviation (three letter code, upper case; i.e., AFR, AMR, CSE, EAS, EUR, MID, HIS, SAS).

* SEX: FEMALE, MALE, or BOTH

*	VERSION: Version identifier for this analysis, to indicate dataset release / analyst / date etc. Examples: UK Biobank → ukb21007-hrc-noPGC,  Biobank Japan → SakaueKanai2020, FinnGen → R12.

For COHORT, SUBCOHORT, and VERSION, use only letters, numbers, and hyphens (no spaces, periods, underscores, or other punctuation).

To archive and compress the summary statistics and log files use:

```
tar cvzf COHORT[-SUBCOHORT]_CLUSTER_SEX_VERSION.regenie.tgz *firth*
```

Please also prepare a readme file to accompany the summary statistics based on this [description](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression#readme-file).

#### XWAS

If you ran the X chromosome analysis then there should be 4 summary statistic files:

```
filename_final_X_xwas.xstrat.logistic
filename_final_X_xwas.xdiff.logistic
filename_final_X_model2.xstrat.logistic
filename_final_X_model2.xdiff.logistic
```

These summary statistic files along with the respective log files should be archived and compressed to a folder. The folder name should take the following naming convention: COHORT[-SUBCOHORT]_CLUSTER_SEX_VERSION.XWAS where

* COHORT: abbreviation or code for cohort name. E.g., UK Biobank = UKBB, Generation Scotland = GenScot

* SUBCOHORT: Subcohort or substudy name, separated from cohort abbreviation by a hyphen (optional). For example, for GenScot: Scottish Family Health Study = -SFHS ("GenScot-SFHS").  Only required if submitting multiple sumstats files from subcohorts that are part of the same study.

* CLUSTER: Genetic similarity cluster abbreviation (three letter code, upper case; i.e., AFR, AMR, CSE, EAS, EUR, MID, HIS, SAS).

* SEX: FEMALE, MALE, or BOTH

*	VERSION: Version identifier for this analysis, to indicate dataset release / analyst / date etc. Examples: UK Biobank → ukb21007-hrc-noPGC,  Biobank Japan → SakaueKanai2020, FinnGen → R12.

For COHORT, SUBCOHORT, and VERSION, use only letters, numbers, and hyphens (no spaces, periods, underscores, or other punctuation).

To archive and compress the summary statistics and log files use:

```
tar cvzf COHORT[-SUBCOHORT]_CLUSTER_SEX_VERSION.XWAS.tgz *model2*log* *xwas*log*
```

Please also prepare a readme file to accompany the summary statistics based on this [description](https://github.com/psychiatric-genomics-consortium/sex-stratified-depression#readme-file).

#### Other

If any other association analysis software was used for the analyses, then please ensure the following information is included in the summary statistics.

•	Chromosome (CHR): 1-23 (numeric)

•	Marker (ID, SNP): Variant identifier, preferably reference SNP ID (rsID). If rsID not available: chromosome-position (CPID) formatted as CHR_POS_REF_ALT

•	Basepair position (POS, BP): GRCh37

•	Effect allele 

•	Non-effect allele

•	Frequency of effect allele in cases and controls

•	Sample size of cases and controls

•	Imputation info score 

•	Effect size: Odds ratio or log(Odds ratio)

•	Standard error: SE of log(OR)

•	Test statistic of association: T-statistic or Z-score

•	Association test -log10(p-value)

Please also prepare a readme file to accompany the summary statistics, see below.

### README file

Prepare a plaintext file with analyst and study information called COHORT[-SUBCOHORT]_VERSION.readme. Include:

•	Contact name, institution, email

•	Study name

•	PIs and analyst names, emails, and ORCiDs

•	Study description.

•	Total numbers of cases and controls for each analysis

•	Array version(s), imputation panel, and genotype build.

•	Genotyping and association analysis details

•	Ethics statements

•	PubMed ID references

•	Grant codes and acknowledgments



## Lead Analysts

* [David Howard](https://www.kcl.ac.uk/people/david-howard)
* [Joel Gelernter](https://medicine.yale.edu/profile/joel-gelernter/)
* [Dan Levey](https://medicine.yale.edu/profile/daniel-levey/)
* [Murray Stein](https://profiles.ucsd.edu/murray.stein)
* [Mark Adams](https://edwebprofiles.ed.ac.uk/profile/dr-mark-james-adams)
* [Alexandre Lussier](https://researchers.mgh.harvard.edu/profile/18516105/Alexandre-Lussier)

## License

This project is licensed under MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Andrew McIntosh, Cathryn Lewis, Swapnil Awasthi, Brittany Mitchell
