# -*- coding: utf-8 -*-
"""
Created on Sun Aug 20 20:13:35 2017

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

df["Term"] = df["Term"].astype('category')
df["Term"] = df["Term"].cat.codes

df["YearsInCurrentJob"] = df["YearsInCurrentJob"].astype('category')
df["YearsInCurrentJob"] = df["YearsInCurrentJob"].cat.codes

df["HomeOwnership"] = df["HomeOwnership"].astype('category')
df["HomeOwnership"] = df["HomeOwnership"].cat.codes

df["Purpose"] = df["Purpose"].astype('category')
df["Purpose"] = df["Purpose"].cat.codes

df.dtypes

#Separating the predictor and target variable
X = df.ix[:,3:]
y = df.ix[:,2]


#Cross Validation
from sklearn.cross_validation import ShuffleSplit
rs = ShuffleSplit(n=88907,n_iter=10)
print rs


from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import AdaBoostClassifier
from sklearn.ensemble import RandomForestClassifier

from sklearn import metrics

lr = LogisticRegression()
ab = AdaBoostClassifier()
rf = RandomForestClassifier()

#CrossValidation execution
for train_index, test_index in rs:
    #print train_index, test_index
    X_Train, X_Test = X.ix[train_index], X.ix[test_index]
    y_Train, y_Test =  y.ix[train_index], y.ix[test_index]
    #Logistic Regression
    #model = lr.fit(X_Train, y_Train)
    #predictions = lr.predict(X_Test)
    
    #adaBoost
    #model = ab.fit(X_Train, y_Train)
    #predictions = ab.predict(X_Test)
    
    #RandomForest
    model = rf.fit(X_Train, y_Train)
    predictions = rf.predict(X_Test)
    
    #print predictions[:5]
    #print "Score:", model.score(X_Test, y_Test)
    
    #AUC Calculation
    fpr, tpr, thresholds = metrics.roc_curve(y_Test, predictions)
    print "AUC:", metrics.auc(fpr, tpr)
    


#Todo
# 1. One Hot encoding of categorical variable and Logistic regression
# 2. Numeric Feature Normalization[MinMax, StandNormal] and run SVM, Neural Network
# 3. removing Feature which doesnt correlate well with target variable [TaxLiens]
