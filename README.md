# pgc-template Project Title
Starting points for new PGC repositories. One paragraph of project description goes here.

## Embargo date

These data are private to WHAT DISTRIBUTION until DATE. All results found here cannot be share, discussed, or presented in any way without explicit permission from WHOM. 

## Project overview

More detail. PGC group. Analysis. Samples. Processing. Genome build. Imputation reference. Where data are. Who did what when. Or, classic who what where when how why. 

### Post Imputation Steps 
## - Autosomal chromosomes

```mermaid
stateDiagram-v2
 state anc <<join>>
 state rel2 <<join>>
 state rel <<join>>
 [*] --> 1_Relatedness.sh : Determine relatedness with
 1_Relatedness.sh --> 2_QC_for_PLINK_GWAS.sh : If <= 10% related use
 1_Relatedness.sh --> 2_QC_for_regenie_GWAS.sh : If > 10% related use
 2_QC_for_PLINK_GWAS.sh --> anc
 2_QC_for_regenie_GWAS.sh --> anc
 anc --> 3_Create_Single_Ancestry_PCAs.sh : If single ancestry use
 anc --> 3_Create_Multi_Ancestry_PCAs.sh : If multi ancestry use
 3_Create_Single_Ancestry_PCAs.sh --> 4_Associated_PCAs.r
 3_Create_Multi_Ancestry_PCAs.sh --> 4_Associated_PCAs.r
 4_Associated_PCAs.r --> rel2 : If used 2_QC_for_regenie_GWAS.sh
 4_Associated_PCAs.r --> rel : If used 2_QC_for_PLINK_GWAS.sh
 rel --> 5_PLINK_GWAS_FEMALE.sh
 rel --> 5_PLINK_GWAS_MALE.sh
 rel --> 5_PLINK_GWAS_GxSEX.sh
 rel2 --> 5_regenie_Step1_FEMALE.sh
 rel2 --> 5_regenie_Step1_MALE.sh
 rel2 --> 5_regenie_Step1_GxSEX.sh
 5_regenie_Step1_FEMALE.sh --> 5_regenie_Step2_FEMALE.sh
 5_regenie_Step1_MALE.sh --> 5_regenie_Step2_MALE.sh
 5_regenie_Step1_GxSEX.sh --> 5_regenie_Step2_GxSEX.sh 
```


 
 
### Step 1

Describe this step

```
Code used 1
```

### Step 2

Describe this step

```
Code used 2
```

### Step 3

Describe this step

```
Code used 3
```

And repeat

```
until finished
```

## Checking the results

Sanity checks on results. 

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Analysts

* **Person Numberone** - *analyst* - [PGC](https://med.unc.edu/pgc)

## License

This project is licensed under XXX License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* readme template from https://gist.github.com/PurpleBooth/109311bb0361f32d87a2#file-readme-template-md
* Hat tip to anyone whose code was used
* Inspiration
* etc

