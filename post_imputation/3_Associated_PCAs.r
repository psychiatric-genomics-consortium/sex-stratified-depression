## R script to identify which PCAs are associated with phenotype
## usage:
## module load r
## Rscript 3_Associated_PCAs.r {filename}
## * note {filename} is the original name of your data, the code automatically applies the _qc1 suffix 

args <- commandArgs(trailingOnly = TRUE)
filename <- args[1]

# load fam file assumes pheno is used in column 6
famfile<-read.table(paste0(filename,"_qc1.fam"),header=FALSE,sep="")
# load eigenvec using plink format: FID, IID, PC1, PC2, etc.. Allows first line to be loaded using comment.char
PCAfile<-read.table(paste0(filename,"_qc1_pca.eigenvec"),comment.char = '&',header=TRUE,sep="")

# rename 6th column in fam file as pheno
colnames(famfile)[6]<-"pheno"
# rename 1st column in PCAfile as FID
colnames(PCAfile)[1]<-"FID"

# merge fam and PCA file based on IID
famPCA<-merge(PCAfile,famfile[,c(1,6)],by.x="IID",by.y="V1")

# check whether phenotype is coded as 0/1 and if not assume 1/2 and adjust to 0/1
if (all(names(table(unlist(famPCA$pheno), useNA="ifany")) %in% 0:1) == FALSE) {
  famPCA$pheno <- famPCA$pheno - 1
}

# recheck whether phenotype is coded as 0/1 and if so conduct regression analysis otherwise stop and report error
if (all(names(table(unlist(famPCA$pheno), useNA="ifany")) %in% 0:1) == TRUE) {
  ## set up vector for PCA selection. First 4 selected and remaining 16 set to 0
  usePCA<-c(rep(1,4),rep(0, 16))
  ## loop through PCs 5-20 (1-4 pre-selected)
  for (n in 5:20) {
    ## logistics regression of each PC in turn on pheno. n+2 used for column position to account for FID and IID
    model <- glm(famPCA$pheno ~ famPCA[,n+2], data = famPCA, family = binomial)
    ## if p < 0.05 then mark PC for selection
    if (coef(summary(model))[,4][[2]] < 0.05) {
      usePCA[n]<-1
    }
  }
} else {
  ## phenotype not coded as 0/1
  print("check whole sample phenotype is coded as 0 / 1")
  stop()
}

## output
print(paste("Recommended PCs:",list(which(usePCA == 1)),"for whole sample"))

## The merge causes IID and FID to switch places so reordered here and output along with PCs 1-4 and those associated with pheno
write.table(famPCA[,c(2,1,(which(usePCA == 1)+2))],paste0(filename,"_qc1_PCA.covar"),col.names=TRUE,row.names=FALSE,sep=" ",quote=FALSE)


## Males

# load male fam file assumes pheno is used in column 6
malefamfile<-read.table(paste0(filename,"_qc1_male.fam"),header=FALSE,sep="")
# load male eigenvec using plink format: FID, IID, PC1, PC2, etc.. Allows first line to be loaded using comment.char
malePCAfile<-read.table(paste0(filename,"_qc1_male_pca.eigenvec"),comment.char = '&',header=TRUE,sep="")

# rename 6th column in fam file as pheno
colnames(malefamfile)[6]<-"pheno"
# rename 1st column in PCAfile as FID
colnames(malePCAfile)[1]<-"FID"

# merge fam and PCA file based on IID
malefamPCA<-merge(malePCAfile,malefamfile[,c(1,6)],by.x="IID",by.y="V1")

# check whether phenotype is coded as 0/1 and if not assume 1/2 and adjust to 0/1
if (all(names(table(unlist(malefamPCA$pheno), useNA="ifany")) %in% 0:1) == FALSE) {
  malefamPCA$pheno <- malefamPCA$pheno - 1
}

# recheck whether phenotype is coded as 0/1 and if so conduct regression analysis otherwise stop and report error
if (all(names(table(unlist(malefamPCA$pheno), useNA="ifany")) %in% 0:1) == TRUE) {
  ## set up vector for male PCA selection. First 4 selected and remaining 16 set to 0
  maleusePCA<-c(rep(1,4),rep(0, 16))
  ## loop through PCs 5-20 (1-4 pre-selected)
  for (n in 5:20) {
    ## logistics regression of each PC in turn on pheno. n+2 used for column position to account for FID and IID
    model <- glm(malefamPCA$pheno ~ malefamPCA[,n+2], data = malefamPCA, family = binomial)
    ## if p < 0.05 then mark PC for selection
    if (coef(summary(model))[,4][[2]] < 0.05) {
      maleusePCA[n]<-1
    }
  }
} else {
  ## phenotype not coded as 0/1
  print("check male sample phenotype is coded as 0 / 1")
  stop()
}

## output
print(paste("Recommended PCs:",list(which(maleusePCA == 1)),"for male only sample"))

## The merge causes IID and FID to switch places so reordered here and output along with PCs 1-4 and those associated with pheno
write.table(malefamPCA[,c(2,1,(which(maleusePCA == 1)+2))],paste0(filename,"_qc1_male_PCA.covar"),col.names=TRUE,row.names=FALSE,sep=" ",quote=FALSE)


## Females


# load female fam file assumes pheno is used in column 6
femalefamfile<-read.table(paste0(filename,"_qc1_female.fam"),header=FALSE,sep="")
# load female eigenvec using plink format: FID, IID, PC1, PC2, etc.. Allows first line to be loaded using comment.char
femalePCAfile<-read.table(paste0(filename,"_qc1_female_pca.eigenvec"),comment.char = '&',header=TRUE,sep="")

# rename 6th column in fam file as pheno
colnames(femalefamfile)[6]<-"pheno"
# rename 1st column in PCAfile as FID
colnames(femalePCAfile)[1]<-"FID"

# merge fam and PCA file based on IID
femalefamPCA<-merge(femalePCAfile,femalefamfile[,c(1,6)],by.x="IID",by.y="V1")

# check whether phenotype is coded as 0/1 and if not assume 1/2 and adjust to 0/1
if (all(names(table(unlist(femalefamPCA$pheno), useNA="ifany")) %in% 0:1) == FALSE) {
  femalefamPCA$pheno <- femalefamPCA$pheno - 1
}

# recheck whether phenotype is coded as 0/1 and if so conduct regression analysis otherwise stop and report error
if (all(names(table(unlist(femalefamPCA$pheno), useNA="ifany")) %in% 0:1) == TRUE) {
  ## set up vector for female PCA selection. First 4 selected and remaining 16 set to 0
  femaleusePCA<-c(rep(1,4),rep(0, 16))
  ## loop through PCs 5-20 (1-4 pre-selected)
  for (n in 5:20) {
    ## logistics regression of each PC in turn on pheno. n+2 used for column position to account for FID and IID
    model <- glm(femalefamPCA$pheno ~ femalefamPCA[,n+2], data = femalefamPCA, family = binomial)
    ## if p < 0.05 then mark PC for selection
    if (coef(summary(model))[,4][[2]] < 0.05) {
      femaleusePCA[n]<-1
    }
  }
} else {
  ## phenotype not coded as 0/1
  print("check female sample phenotype is coded as 0 / 1")
  stop()
}

## output
print(paste("Recommended PCs:",list(which(femaleusePCA == 1)),"for female only sample"))

## The merge causes IID and FID to switch places so reordered here and output along with PCs 1-4 and those associated with pheno
write.table(femalefamPCA[,c(2,1,(which(femaleusePCA == 1)+2))],paste0(filename,"_qc1_female_PCA.covar"),col.names=TRUE,row.names=FALSE,sep=" ",quote=FALSE)
