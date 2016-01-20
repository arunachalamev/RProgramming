# This code cluster the Iris data (consider only 2 dimension)

# Load the Iris dataset for clustering
library(datasets)
head(iris)

#Initial plot of Iris dataset based on Petal characteristics
library(ggplot2)
ggplot(iris,aes(Petal.Length,Petal.Width,color=Species))+geom_point()

#Create 3 cluster with 20 random initialization
set.seed(20)
irisCluster <- kmeans(iris[,3:4],3,nstart=20)
irisCluster

#Compare the Assigned and True cluster
table(irisCluster$cluster,iris$Species)

#Plot the predicted Cluster
irisCluster$cluster <- as.factor(irisCluster$cluster)
ggplot(iris,aes(Petal.Length,Petal.Width,color=irisCluster$cluster))+geom_point()