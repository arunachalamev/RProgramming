str(CleanDS)

CleanDS$LoanStatus        = as.factor(CleanDS$LoanStatus)
CleanDS$Term              = as.factor(CleanDS$Term)
CleanDS$YearsInCurrentJob = as.factor(CleanDS$YearsInCurrentJob)
CleanDS$HomeOwnership     = as.factor(CleanDS$HomeOwnership)
CleanDS$Purpose           = as.factor(CleanDS$Purpose)

str(CleanDS)
summary(CleanDS)

#Fix Purpose column 
unique(CleanDS$Purpose)
#Purpose column contains - other and Other
CleanDS$Purpose <- gsub("Other","other",CleanDS$Purpose)
unique(CleanDS$Purpose)
CleanDS$Purpose           = as.factor(CleanDS$Purpose)

#plotting
library(ggplot2)
ggplot(data=CleanDS,aes(x=Term,fill=LoanStatus))+geom_bar(position=position_dodge())
ggplot(data=CleanDS,aes(x=YearsInCurrentJob,fill=LoanStatus))+geom_bar(position=position_dodge())
ggplot(data=CleanDS,aes(x=HomeOwnership,fill=LoanStatus))+geom_bar(position=position_dodge())
ggplot(data=CleanDS,aes(x=Purpose,fill=LoanStatus))+geom_bar(position=position_dodge()) + theme(axis.text.x  = element_text(angle=90))

ggplot(CleanDS, aes(x=LoanStatus, y=log(CurrentLoanAmount), fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=CreditScore, fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=log(AnnualIncome), fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=MonthlyDebt, fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=log(MonthlyDebt), fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=YearsOfCreditHistory, fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=MonthsSinceLastDelinquent, fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=NumOfOpenAccounts, fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=NumOfCreditProblems, fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=log(CurrentCreditBalance), fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=log(MaximumOpenCredit), fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=log(Bankruptcies), fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)
ggplot(CleanDS, aes(x=LoanStatus, y=TaxLiens, fill=LoanStatus)) + geom_boxplot() +   guides(fill=FALSE)

sum(CleanDS$CurrentLoanAmount == 99999999)
table(CleanDS[CleanDS$CurrentLoanAmount == 99999999,"LoanStatus"])
table(CleanDS[is.na(CleanDS$TaxLiens),"LoanStatus"])

table(CleanDS[,c("Bankruptcies","LoanStatus")],useNA="ifany")
#prop.table(table(CleanDS[,c("TaxLiens","LoanStatus")],useNA="ifany"),1)
table(CleanDS[,c("TaxLiens","LoanStatus")],useNA="ifany")
table(CleanDS[,c("NumOfCreditProblems","LoanStatus")],useNA="ifany")
table(CleanDS[,c("NumOfOpenAccounts","LoanStatus")],useNA="ifany")
table(CleanDS[,c("Purpose","LoanStatus")],useNA="ifany")
table(CleanDS[,c("HomeOwnership","LoanStatus")],useNA="ifany")

table(CleanDS[,c("YearsInCurrentJob","LoanStatus")],useNA="ifany")
table(CleanDS[,c("Term","LoanStatus")],useNA="ifany")
table(CleanDS[,c("CreditScore","LoanStatus")],useNA="ifany")

table(CleanDS[,c("CustomerID","LoanStatus")],useNA="ifany")

#finding the number of records with na
na_count <-sapply(CleanDS, function(y) sum(length(which(is.na(y)))))
na_count <- data.frame(na_count)
na_count


table(CleanDS[is.na(CleanDS$CreditScore),"LoanStatus"])
table(CleanDS[is.na(CleanDS$AnnualIncome),"LoanStatus"])
#the above two col have same set of defaulters
table(CleanDS[is.na(CleanDS$MonthsSinceLastDelinquent),"LoanStatus"])
table(CleanDS[is.na(CleanDS$Bankruptcies),"LoanStatus"])

table(CleanDS[is.na(CleanDS$TaxLiens),"LoanStatus"])
#na taxliens are always defaulter

#Unique values in each variable column
unique_count <-sapply(CleanDS, function(y) sum(length(unique(y))))
unique_count <- data.frame(unique_count)
unique_count

chisq.test(CleanDS$LoanStatus,CleanDS$TaxLiens,correct = FALSE)

chisq.test(CleanDS$LoanStatus,CleanDS$Term,correct = FALSE,simulate.p.value = TRUE)
chisq.test(CleanDS$LoanStatus,CleanDS$YearsInCurrentJob,correct = FALSE,simulate.p.value = TRUE)
chisq.test(CleanDS$LoanStatus,CleanDS$HomeOwnership,correct = FALSE,simulate.p.value = TRUE)
chisq.test(CleanDS$LoanStatus,CleanDS$Purpose,correct = FALSE,simulate.p.value = TRUE)
chisq.test(CleanDS$LoanStatus,CleanDS$NumOfCreditProblems,correct = FALSE,simulate.p.value = TRUE)
#Bankruptcies is not useful feature
chisq.test(CleanDS$LoanStatus,CleanDS$Bankruptcies,correct = FALSE,simulate.p.value = TRUE)
chisq.test(CleanDS$LoanStatus,CleanDS$TaxLiens,correct = FALSE,simulate.p.value = TRUE)


fisher.test(CleanDS$LoanStatus,CleanDS$TaxLiens,simulate.p.value = TRUE)
fisher.test(CleanDS$LoanStatus,CleanDS$Bankruptcies,simulate.p.value = TRUE)


model.lm <- lm(as.numeric(LoanStatus) ~ CurrentLoanAmount, data = CleanDS)
summary(model.lm)

model.lm <- lm(as.numeric(LoanStatus) ~ CreditScore, data = CleanDS)
summary(model.lm)

model.lm <- lm(as.numeric(LoanStatus) ~ AnnualIncome, data = CleanDS)
summary(model.lm)

model.lm <- lm(as.numeric(LoanStatus) ~ MonthlyDebt, data = CleanDS)
summary(model.lm)

model.lm <- lm(as.numeric(LoanStatus) ~ YearsOfCreditHistory, data = CleanDS)
summary(model.lm)

model.lm <- lm(as.numeric(LoanStatus) ~ Bankruptcies, data = CleanDS)
summary(model.lm)

model.lm <- lm(as.numeric(LoanStatus) ~ TaxLiens, data = CleanDS)
summary(model.lm)

#Replacing NA variable with mean
imputedDS <- CleanDS
str(imputedDS)
imputedDS[is.na(imputedDS$CreditScore),"CreditScore"] <- as.integer(mean(CleanDS$CreditScore,na.rm=TRUE))
imputedDS[is.na(imputedDS$MonthsSinceLastDelinquent),"MonthsSinceLastDelinquent"] <- as.integer(mean(CleanDS$MonthsSinceLastDelinquent,na.rm=TRUE))
imputedDS[is.na(imputedDS$AnnualIncome),"AnnualIncome"] <- as.integer(mean(CleanDS$AnnualIncome,na.rm=TRUE))
imputedDS[is.na(imputedDS$Bankruptcies),"Bankruptcies"] <- as.integer(mean(CleanDS$Bankruptcies,na.rm=TRUE))
imputedDS[is.na(imputedDS$TaxLiens),"TaxLiens"] <- as.integer(mean(CleanDS$TaxLiens,na.rm=TRUE))

          
#To verify whether NA variables removed
na_count <-sapply(imputedDS, function(y) sum(length(which(is.na(y)))))
na_count <- data.frame(na_count)
na_count

imputedDS$LoanStatus <- as.numeric(imputedDS$LoanStatus)
model <- lm(LoanStatus ~ CreditScore + AnnualIncome + Bankruptcies,data=imputedDS)

summary(model)
model
anova(model, test="Chisq")

quantile(CleanDS$CurrentLoanAmount,seq(0,1,0.1))

WithouIDDS = imputedDS[,c("LoanStatus","CurrentLoanAmount","Term","CreditScore","YearsInCurrentJob","HomeOwnership","AnnualIncome","Purpose","MonthlyDebt","YearsOfCreditHistory","MonthsSinceLastDelinquent","NumOfOpenAccounts","NumOfCreditProblems","CurrentCreditBalance","MaximumOpenCredit","Bankruptcies","TaxLiens")]
WithouIDDS = as.numeric(WithouIDDS)
WithouIDDS$Term <- as.numeric(WithouIDDS$Term)
WithouIDDS$YearsInCurrentJob <- as.numeric(WithouIDDS$YearsInCurrentJob)
WithouIDDS$HomeOwnership <- as.numeric(WithouIDDS$HomeOwnership)
WithouIDDS$Purpose <- as.numeric(WithouIDDS$Purpose)

WithouIDDS$MaximumOpenCredit <- imputedDS$MaximumOpenCredit


str(WithouIDDS)
q <- t(apply(WithouIDDS, 2, quantile, probs = seq(0.9,1,0.05),  na.rm = TRUE))
q


quantile(WithouIDDS$MaximumOpenCredit,seq(0,1,0.01))
quantile(WithouIDDS$CurrentLoanAmount,seq(0,1,0.01))

WithouIDDS$MaximumOpenCredit <- squish(WithouIDDS$MaximumOpenCredit, round(quantile(WithouIDDS$MaximumOpenCredit, c(0, .99))))
range(WithouIDDS$MaximumOpenCredit)



#Records with 99999999 as CurrentLoanAmount
CurrentLoanAmountOutlier <-WithouIDDS[WithouIDDS$CurrentLoanAmount >= 99999999,]
