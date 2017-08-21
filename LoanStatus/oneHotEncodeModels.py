# -*- coding: utf-8 -*-
"""
Created on Sun Aug 20 20:23:46 2017

@author: arellave
"""

import numpy as np
import pandas as pd

#Reading the Input file
input_file ="FinalDS.csv"
df = pd.read_csv(input_file, header = 0)
original_headers = list(df.columns.values)

print (df.shape)
df.dtypes

#Converting into category datatype
df["LoanStatus"] = df["LoanStatus"].astype('category')
df["LoanStatus"] = df["LoanStatus"].cat.codes


df1 = pd.get_dummies(df, columns=["Term", "YearsInCurrentJob", "HomeOwnership","Purpose"], prefix=["Term", "YearsInCurrentJob", "HomeOwnership","Purpose"])

df1.dtypes

#Separating the predictor and target variable
X = df1.ix[:,3:]
y = df1.ix[:,2]

#Cross Validation
from sklearn.cross_validation import ShuffleSplit
rs = ShuffleSplit(n=88907,n_iter=5)
print rs

from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import AdaBoostClassifier
from sklearn.ensemble import RandomForestClassifier

from sklearn import metrics

lr = LogisticRegression()
ab = AdaBoostClassifier()
rf = RandomForestClassifier()

AUC_lr,AUC_ab,AUC_rf = [],[],[]
#CrossValidation execution
for train_index, test_index in rs:
    #print train_index, test_index
    X_Train, X_Test = X.ix[train_index], X.ix[test_index]
    y_Train, y_Test =  y.ix[train_index], y.ix[test_index]
    #Logistic Regression
    model = lr.fit(X_Train, y_Train)
    predictions = lr.predict(X_Test)
    fpr, tpr, thresholds = metrics.roc_curve(y_Test, predictions)
    AUC_lr.append(metrics.auc(fpr,tpr))
    
    
    #adaBoost
    model = ab.fit(X_Train, y_Train)
    predictions = ab.predict(X_Test)
    fpr, tpr, thresholds = metrics.roc_curve(y_Test, predictions)    
    AUC_ab.append(metrics.auc(fpr,tpr))
    
    #RandomForest
    model = rf.fit(X_Train, y_Train)
    predictions = rf.predict(X_Test)
    
    #print predictions[:5]
    #print "Score:", model.score(X_Test, y_Test)
    
    fpr, tpr, thresholds = metrics.roc_curve(y_Test, predictions)
    #print "AUC:", metrics.auc(fpr, tpr)
    AUC_rf.append(metrics.auc(fpr,tpr))
    
print "AUC :"    
print "Logistic Regression - Mean:", np.mean(AUC_lr), "Std dev: ",np.std(AUC_lr)
print "AdaBoost            - Mean:", np.mean(AUC_ab), "Std dev: ",np.std(AUC_ab)
print "Random Forest       - Mean:", np.mean(AUC_rf), "Std dev: ",np.std(AUC_rf)



