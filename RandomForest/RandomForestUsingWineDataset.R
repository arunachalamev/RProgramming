#url <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv'
#wine <- read.table(url)

#Load the Wine Dataset
wine <- read.csv("C:/Users/arellave/Desktop/winequality-white.csv", sep=";", stringsAsFactors=FALSE)
head(wine)
barplot(table(wine$quality)

#Create label based on the Quality Score
wine$taste <- ifelse(wine$quality < 6 ,'bad','good')
wine$taste[wine$quality == 6] <- 'normal'
wine$taste <- as.factor(wine$taste)

table(wine$taste)

#Build out the train and test dataset
set.seed(123)
samp <- sample(nrow(wine),0.6*nrow(wine))
train <- wine[samp,]
test <- wine[-samp,]

#Create a random forest model with train data
library(randomForest)
model <- randomForest(taste ~. -quality,data = train)
model

#predict the label in test dataset
pred <- predict(model,newdata=test)
table(pred,test$taste)
