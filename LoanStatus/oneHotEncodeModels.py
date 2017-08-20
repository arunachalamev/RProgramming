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
