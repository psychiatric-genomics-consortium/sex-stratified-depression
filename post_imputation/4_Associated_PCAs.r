## R script to identify which PCAs are associated with phenotype
## usage:
## module load r
## Rscript 4_Associated_PCAs.r {filename}
## * note {filename} is the original name of your data, the code automatically applies the _qc1 suffix

args <- commandArgs(trailingOnly = TRUE)
filename <- args[1]

# load pheno file assuming pheno is in column 3
phenofile<-read.table(paste0(filename,".pheno"),header=FALSE,sep="")

## Check whether PCs are from plink or eigensoft and prepare accordingly
## If both files exist then stop and prompt for change to file name or location
if (file.exists(paste0(filename,"_qc1_pca.eigenvec")) == TRUE && file.exists(paste0(filename,"_qc1_eigen.vec")) == TRUE) {
  print("Found PCs from both plink and eigensoft. Please rename or move the unwanted file")
  stop()
} else if (file.exists(paste0(filename,"_qc1_pca.eigenvec")) == TRUE) {
  ## If PCs are in plink format: IID, FID, PC1-PC20
  PCAfile<-read.table(paste0(filename,"_qc1_pca.eigenvec"),comment.char = '&',header=TRUE,sep="")
  # rename 3rd column in fam file as pheno
  colnames(phenofile)[3]<-"pheno"
  # rename 1st column in PCAfile as FID
  colnames(PCAfile)[1]<-"FID"
  # merge PCA and pheno file based on IID
  famPCA<-merge(PCAfile,phenofile[,c(2,3)],by.x="IID",by.y="V2")
  famPCA$pheno<-as.numeric(famPCA$pheno)
} else if (file.exists(paste0(filename,"_qc1_eigen.vec")) == TRUE) {
  ## If PCs are in eigensoft format. assuming format FID:ID, PCs 1-20, phenotype
  PCAfile<-read.table(text = gsub(":", " ", readLines(paste0(filename,"_qc1_eigen.vec"))))
  # rename columns in PCAfile and convert phenotype to binary. Id and FID switched to match the merge in other data format. This is switched back during write.table
  colnames(PCAfile)<-c("FID","IID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17","PC18","PC19","PC20","pheno")
  PCAfile$pheno[which(PCAfile$pheno == "Control")]<-0
  PCAfile$pheno[which(PCAfile$pheno == "Case")]<-1
  PCAfile$pheno<-as.numeric(PCAfile$pheno)
  # rename PCA file famPCA
  famPCA<-PCAfile
} else {
  print("No PCA file found. Please recheck")
  stop()
}

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

##load fam file
famfile<-read.table(paste0(filename,".fam"),header=FALSE,sep="")

## if both sexes present then include sex in covariate file
if ((nrow(famfile[which(famfile$V5 == 1),]) > 0) & (nrow(famfile[which(famfile$V5 == 2),]) > 0)) {
  colnames(famfile)[2]<-"IID"
  colnames(famfile)[5]<-"sex"
  famPCA<-merge(famPCA,famfile[,c(2,5)],by="IID")
  ## Output: sex, PCs 1-4 and those associated with pheno. Plus a covariate file without sex for use with X chromosome data
  write.table(famPCA[,c(which(colnames(famPCA) == "FID"),which(colnames(famPCA) == "IID"),which(colnames(famPCA) == "sex"),(which(usePCA == 1)+2))],paste0(filename,"_qc1_PCA.covar"),col.names=TRUE,row.names=FALSE,sep=" ",quote=FALSE)
  write.table(famPCA[,c(which(colnames(famPCA) == "FID"),which(colnames(famPCA) == "IID"),(which(usePCA == 1)+2))],paste0(filename,"_qc1_PCA_forX.covar"),col.names=TRUE,row.names=FALSE,sep=" ",quote=FALSE)
} else {
  ## Output: PCs 1-4 and those associated with pheno
  write.table(famPCA[,c(which(colnames(famPCA) == "FID"),which(colnames(famPCA) == "IID"),(which(usePCA == 1)+2))],paste0(filename,"_qc1_PCA.covar"),col.names=TRUE,row.names=FALSE,sep=" ",quote=FALSE)
}

## Males

# load male fam file assumes pheno is used in column 6
malephenofile<-read.table(paste0(filename,".pheno"),header=FALSE,sep="")

## Check whether PCs are from plink or eigensoft and prepare accordingly
## If both files exist then stop and prompt for change to file name or location
if (file.exists(paste0(filename,"_qc1_male_pca.eigenvec")) == TRUE && file.exists(paste0(filename,"_qc1_male_eigen.vec")) == TRUE) {
  print("Found PCs from both plink and eigensoft for males. Please rename or move the unwanted file")
  stop()
} else if (file.exists(paste0(filename,"_qc1_male_pca.eigenvec")) == TRUE) {
## If PCs are in plink format
  malePCAfile<-read.table(paste0(filename,"_qc1_male_pca.eigenvec"),comment.char = '&',header=TRUE,sep="")
  # rename 3rd column in pheno file as pheno
  colnames(malephenofile)[3]<-"pheno"
  # rename 1st column in PCAfile as FID
  colnames(malePCAfile)[1]<-"FID"
  # merge fam and PCA file based on IID
  malefamPCA<-merge(malePCAfile,malephenofile[,c(2,3)],by.x="IID",by.y="V2")
  malefamPCA$pheno<-as.numeric(malefamPCA$pheno)
} else if (file.exists(paste0(filename,"_qc1_male_eigen.vec")) == TRUE) {
  ## If PCs are in eigensoft format. assuming format FID:ID, PCs 1-20, phenotype
  malePCAfile<-read.table(text = gsub(":", " ", readLines(paste0(filename,"_qc1_male_eigen.vec"))))
  # rename columns in PCAfile and convert phenotype to binary
  colnames(malePCAfile)<-c("FID","IID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17","PC18","PC19","PC20","pheno")
  malePCAfile$pheno[which(malePCAfile$pheno == "Control")]<-0
  malePCAfile$pheno[which(malePCAfile$pheno == "Case")]<-1
  malePCAfile$pheno<-as.numeric(malePCAfile$pheno)
  # rename PCA file famPCA
  malefamPCA<-malePCAfile
} else {
  print("No PCA file found for males. Please recheck")
  stop()
}

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

## screen output
print(paste("Recommended PCs:",list(which(maleusePCA == 1)),"for male only sample"))

## Output PCs 1-4 and those associated with pheno
write.table(malefamPCA[,c(which(colnames(malefamPCA) == "FID"),which(colnames(malefamPCA) == "IID"),(which(maleusePCA == 1)+2))],paste0(filename,"_qc1_male_PCA.covar"),col.names=TRUE,row.names=FALSE,sep=" ",quote=FALSE)

## Females

# load female fam file assumes pheno is used in column 6
femalephenofile<-read.table(paste0(filename,".pheno"),header=FALSE,sep="")

## Check whether PCs are from plink or eigensoft and prepare accordingly
## If both files exist then stop and prompt for change to file name or location
if (file.exists(paste0(filename,"_qc1_female_pca.eigenvec")) == TRUE && file.exists(paste0(filename,"_qc1_female_eigen.vec")) == TRUE) {
  print("Found PCs from both plink and eigensoft for females. Please rename or move the unwanted file")
  stop()
} else if (file.exists(paste0(filename,"_qc1_female_pca.eigenvec")) == TRUE) {
  ## If PCs are in plink format
  femalePCAfile<-read.table(paste0(filename,"_qc1_female_pca.eigenvec"),comment.char = '&',header=TRUE,sep="")
  # rename 3rd column in fam file as pheno
  colnames(femalephenofile)[3]<-"pheno"
  # rename 1st column in PCAfile as FID
  colnames(femalePCAfile)[1]<-"FID"
  # merge fam and PCA file based on IID
  femalefamPCA<-merge(femalePCAfile,femalephenofile[,c(2,3)],by.x="IID",by.y="V2")
  femalefamPCA$pheno<-as.numeric(femalefamPCA$pheno)
} else if (file.exists(paste0(filename,"_qc1_female_eigen.vec")) == TRUE) {
  ## If PCs are in eigensoft format. assuming format FID:ID, PCs 1-20, phenotype
  femalePCAfile<-read.table(text = gsub(":", " ", readLines(paste0(filename,"_qc1_female_eigen.vec"))))
  # rename columns in PCAfile and convert phenotype to binary
  colnames(femalePCAfile)<-c("FID","IID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17","PC18","PC19","PC20","pheno")
  femalePCAfile$pheno[which(femalePCAfile$pheno == "Control")]<-0
  femalePCAfile$pheno[which(femalePCAfile$pheno == "Case")]<-1
  femalePCAfile$pheno<-as.numeric(femalePCAfile$pheno)
  # rename PCA file famPCA
  femalefamPCA<-femalePCAfile
} else {
  print("No PCA file found for females. Please recheck")
  stop()
}

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

## screen output
print(paste("Recommended PCs:",list(which(femaleusePCA == 1)),"for female only sample"))

## Output PCs 1-4 and those associated with pheno
write.table(femalefamPCA[,c(which(colnames(femalefamPCA) == "FID"),which(colnames(femalefamPCA) == "IID"),(which(femaleusePCA == 1)+2))],paste0(filename,"_qc1_female_PCA.covar"),col.names=TRUE,row.names=FALSE,sep=" ",quote=FALSE)
