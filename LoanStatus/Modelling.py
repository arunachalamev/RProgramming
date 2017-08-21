# -*- coding: utf-8 -*-
"""
Created on Sun Aug 20 15:16:35 2017

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


 
from sklearn import linear_model
from sklearn.cross_validation import train_test_split
#from matplotlib import pyplot as plt

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
print X_train.shape, y_train.shape
print X_test.shape, y_test.shape


lm = linear_model.LogisticRegression()
model = lm.fit(X_train, y_train)
predictions = lm.predict(X_test)

predictions[0:5]
print "Score:", model.score(X_test, y_test)


from sklearn import ensemble
rf = ensemble.AdaBoostClassifier()
from sklearn import cross_validation
scores = cross_validation.cross_val_score(rf,X,y,cv=10)
print scores

scores = cross_validation.cross_val_score(lm,X,y,cv=10)
print scores


from sklearn.cross_validation import ShuffleSplit
rs = ShuffleSplit(n=88907,n_iter=10)
print rs

from sklearn import metrics
from sklearn.ensemble import RandomForestClassifier
clf = RandomForestClassifier()

for train_index, test_index in rs:
    #print train_index, test_index
    X_Train, X_Test = X.ix[train_index], X.ix[test_index]
    y_Train, y_Test =  y.ix[train_index], y.ix[test_index]
    #Logistic Regression
    #model = lm.fit(X_Train, y_Train)
    #predictions = lm.predict(X_Test)
    
    #adaBoost
    #model = rf.fit(X_Train, y_Train)
    #predictions = rf.predict(X_Test)
    
    #RandomForest
    model = clf.fit(X_Train, y_Train)
    predictions = clf.predict(X_Test)
    
    
    #print predictions[:5]
    #print "Score:", model.score(X_Test, y_Test)
    
    #AUC Calculation
    fpr, tpr, thresholds = metrics.roc_curve(y_Test, predictions)
    print "AUC:", metrics.auc(fpr, tpr)
    