
summary(CleanDS)

naRemovedDS <- CleanDS

#Finding number of NA values in each Coulmn
na_count <-sapply(CleanDS, function(y) sum(length(which(is.na(y)))))
na_count <- data.frame(na_count)
na_count

#Finding number of Unique values in each column
unique_count <-sapply(CleanDS, function(y) sum(length(unique(y))))
unique_count <- data.frame(unique_count)
unique_count

#Based on the unique values we can consider below columns as categorical variable
categortyVariable <- c("Term","YearsInCurrentJob","HomeOwnership","Purpose","NumOfCreditProblems","Bankruptcies","TaxLiens")
nummericVariable <- c("CurrentLoanAmount","CreditScore","AnnualIncome","MonthlyDebt","YearsOfCreditHistory","MonthsSinceLastDelinquent","NumOfOpenAccounts","CurrentCreditBalance","MaximumOpenCredit")
targetVariable <- c("LoanStatus")
idVariable <- c("LoanID","CustomerID")

#-----------------------------------------------------------------------
# To find out outliers
#-----------------------------------------------------------------------
t(apply(CleanDS[,c("CurrentLoanAmount","CreditScore","AnnualIncome","MonthlyDebt","YearsOfCreditHistory","MonthsSinceLastDelinquent","NumOfOpenAccounts","CurrentCreditBalance","MaximumOpenCredit")], 2, quantile, probs = seq(0,1,0.1),  na.rm = TRUE))
t(apply(CleanDS[,c("CurrentLoanAmount","CreditScore","AnnualIncome","MonthlyDebt","YearsOfCreditHistory","MonthsSinceLastDelinquent","NumOfOpenAccounts","CurrentCreditBalance","MaximumOpenCredit")], 2, quantile, probs = seq(0.9,1,0.02),  na.rm = TRUE))


#-----------------------------------------------------------------------------------------
#To figure out the replacement value of NA
#NA columns - CreditScore, AnnualIncome, MonthsSinceLastDelinquent, Bankruptcies, TaxLiens
#-----------------------------------------------------------------------------------------

#To get mean of the columns which contains NA grouped by LoanStatus
library(reshape2)
groupByTable <- group_by(CleanDS,LoanStatus)
summarise(groupByTable,round(mean(CreditScore,na.rm=TRUE)))
# Mean of creditscore column differs between two classes in magnitude of 3

table(CleanDS[is.na(CleanDS$CreditScore),"LoanStatus"])
round(mean(CleanDS$CreditScore,na.rm=TRUE)) #Overall mean

#-------------------------------------------
# Credit Score
#-------------------------------------------
# replacing NA values in creditscore with mean values of correspoding LoanStatus
naRemovedDS[is.na(naRemovedDS$CreditScore) & naRemovedDS$LoanStatus == "Charged Off","CreditScore"] <- 2397
naRemovedDS[is.na(naRemovedDS$CreditScore) & naRemovedDS$LoanStatus == "Fully Paid","CreditScore"] <- 723

#To verify if NA is changed
data.frame(sapply(naRemovedDS, function(y) sum(length(which(is.na(y))))))


#-------------------------------------------
# Annual Income
#-------------------------------------------
summarise(groupByTable,round(mean(AnnualIncome,na.rm=TRUE)))
table(CleanDS[is.na(CleanDS$AnnualIncome),"LoanStatus"])
round(mean(CleanDS$AnnualIncome,na.rm=TRUE)) 

naRemovedDS[is.na(naRemovedDS$AnnualIncome) & naRemovedDS$LoanStatus == "Charged Off","AnnualIncome"] <- 66573
naRemovedDS[is.na(naRemovedDS$AnnualIncome) & naRemovedDS$LoanStatus == "Fully Paid","AnnualIncome"] <- 74482

#To verify if NA is changed
data.frame(sapply(naRemovedDS, function(y) sum(length(which(is.na(y))))))


#-------------------------------------------
# MonthsSinceLastDelinquent
#-------------------------------------------
summarise(groupByTable,round(mean(MonthsSinceLastDelinquent,na.rm=TRUE)))
table(CleanDS[is.na(CleanDS$MonthsSinceLastDelinquent),"LoanStatus"])
round(mean(CleanDS$MonthsSinceLastDelinquent,na.rm=TRUE)) 

naRemovedDS[is.na(naRemovedDS$MonthsSinceLastDelinquent) & naRemovedDS$LoanStatus == "Charged Off","MonthsSinceLastDelinquent"] <- 34
naRemovedDS[is.na(naRemovedDS$MonthsSinceLastDelinquent) & naRemovedDS$LoanStatus == "Fully Paid","MonthsSinceLastDelinquent"] <- 35

#-------------------------------------------
# Bankruptcies
#-------------------------------------------
summarise(groupByTable,round(mean(Bankruptcies,na.rm=TRUE)))
table(CleanDS[is.na(CleanDS$Bankruptcies),"LoanStatus"])
round(mean(CleanDS$Bankruptcies,na.rm=TRUE)) 

naRemovedDS[is.na(naRemovedDS$Bankruptcies),"Bankruptcies"] <- 0

#-------------------------------------------
# TaxLiens
#-------------------------------------------
summarise(groupByTable,round(mean(TaxLiens,na.rm=TRUE)))
table(CleanDS[is.na(CleanDS$TaxLiens),"LoanStatus"])
round(mean(CleanDS$TaxLiens,na.rm=TRUE)) 

naRemovedDS[is.na(naRemovedDS$TaxLiens),"TaxLiens"] <- 0


#-------------------------------------------
# To Analysis where CurrentLoanAmount is 99999999
#-------------------------------------------
# Total number of records which contain the extreme value 99999999
table(CleanDS[CleanDS$CurrentLoanAmount == 99999999,"LoanStatus"])
round(mean(CleanDS$CurrentLoanAmount[CleanDS$CurrentLoanAmount != 99999999],na.rm=TRUE))
# Overall column is baised duer to above outlier records
round(mean(CleanDS$CurrentLoanAmount,na.rm=TRUE))

#groupByTable_for_CurrentLoanAmount <- group_by(CleanDS[CleanDS$CurrentLoanAmount != 99999999,],LoanStatus)
#summarise(groupByTable_for_CurrentLoanAmount,round(mean(CurrentLoanAmount,na.rm=TRUE)))


# replacing the outlier 
naRemovedDS[naRemovedDS$CurrentLoanAmount == 99999999,"CurrentLoanAmount"] <- 13984
round(mean(naRemovedDS$CurrentLoanAmount,na.rm=TRUE))

t(apply(CleanDS[,c("CurrentLoanAmount","CreditScore","AnnualIncome","MonthlyDebt","YearsOfCreditHistory","MonthsSinceLastDelinquent","NumOfOpenAccounts","CurrentCreditBalance","MaximumOpenCredit")], 2, quantile, probs = seq(0.9,1,0.02),  na.rm = TRUE))
t(apply(naRemovedDS[,c("CurrentLoanAmount","CreditScore","AnnualIncome","MonthlyDebt","YearsOfCreditHistory","MonthsSinceLastDelinquent","NumOfOpenAccounts","CurrentCreditBalance","MaximumOpenCredit")], 2, quantile, probs = seq(0.9,1,0.02),  na.rm = TRUE))


#----------------------------------------------------
# Verifying whether NA values are removed
#----------------------------------------------------
#Finding number of NA values in each Coulmn
na_count <-sapply(naRemovedDS, function(y) sum(length(which(is.na(y)))))
na_count <- data.frame(na_count)
na_count

#Final DS
naRemovedDS$Purpose <- gsub("Other","other",naRemovedDS$Purpose)
write.csv(naRemovedDS, file = "D:\\gitProjects\\RProgramming\\LoanStatus\\FinalDS.csv", row.names = FALSE)




table(CleanDS[,"LoanStatus"])


