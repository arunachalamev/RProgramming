#Renaming the columns of Imported Dataset
names(OriginalDS) <- c("LoanID","CustomerID","LoanStatus","CurrentLoanAmount","Term","CreditScore","YearsInCurrentJob","HomeOwnership","AnnualIncome","Purpose","MonthlyDebt","YearsOfCreditHistory","MonthsSinceLastDelinquent","NumOfOpenAccounts","NumOfCreditProblems","CurrentCreditBalance","MaximumOpenCredit","Bankruptcies","TaxLiens")

#Converting categorical column into factor variables
OriginalDS$LoanStatus        = as.factor(OriginalDS$LoanStatus)
OriginalDS$Term              = as.factor(OriginalDS$Term)
OriginalDS$YearsInCurrentJob = as.factor(OriginalDS$YearsInCurrentJob)
OriginalDS$HomeOwnership     = as.factor(OriginalDS$HomeOwnership)
OriginalDS$Purpose           = as.factor(OriginalDS$Purpose)

summary(OriginalDS)
str(OriginalDS)

#Number of unique LoanID,CustomerID and its Combination
length(unique(OriginalDS$CustomerID))
length(unique(OriginalDS$LoanID))
length(unique(OriginalDS$LoanID,OriginalDS$CustomerID))

#Removing exact Duplicate records
cols <- c("LoanID","CustomerID","LoanStatus","CurrentLoanAmount","Term","CreditScore","YearsInCurrentJob","HomeOwnership","AnnualIncome","Purpose","MonthlyDebt","YearsOfCreditHistory","MonthsSinceLastDelinquent","NumOfOpenAccounts","NumOfCreditProblems","CurrentCreditBalance","MaximumOpenCredit","Bankruptcies","TaxLiens")
duplicateRecords <- OriginalDS[duplicated(OriginalDS[, cols]),]
uniqueRecords    <- OriginalDS[!duplicated(OriginalDS[, cols]),]

#writing into file
write.csv(duplicateRecords, file = "D:\\gitProjects\\RProgramming\\LoanStatus\\DuplicateRecords.csv", row.names = FALSE)
write.csv(uniqueRecords, file = "D:\\gitProjects\\RProgramming\\LoanStatus\\UniqueRecords.csv", row.names = FALSE)

summary(uniqueRecords)

#Number of unique LoanID,CustomerID and its Combination
length(unique(uniqueRecords$CustomerID))
length(unique(uniqueRecords$LoanID))
length(unique(uniqueRecords$LoanID,uniqueRecords$CustomerID))


cols <- c("LoanID","CustomerID","LoanStatus")
temp <-  uniqueRecords[duplicated(uniqueRecords[, cols]),]

tempidx <- (duplicated(uniqueRecords[,cols]) | duplicated(uniqueRecords[,cols], fromLast = TRUE))
dupAndOriginal <- uniqueRecords[tempidx, ] 
nonDuplicatedRecords <- uniqueRecords[!tempidx, ] 

write.csv(dupAndOriginal, file = "D:\\gitProjects\\RProgramming\\LoanStatus\\dupAndOriginal.csv", row.names = FALSE)
#Each loan id or customer id is contains a double records
# Num of records - 19342
# Unique customer/load id - 9671

#Get records which contains max information
temp <- dupAndOriginal[dupAndOriginal$CurrentLoanAmount< 99999999 & !(is.na(dupAndOriginal$CreditScore) & is.na(dupAndOriginal$AnnualIncome)),]

#Cleaned dataset
cleanDS <- rbind(nonDuplicatedRecords,temp)

write.csv(cleanDS, file = "D:\\gitProjects\\RProgramming\\LoanStatus\\CleanDS.csv", row.names = FALSE)
