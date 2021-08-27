#!/usr/bin/env python3

# PRML Lab Week 4

"""
Pattern Recognition and Machine Learning
Week 4 Tutorial
"""

import pandas as pd

# Diabetes Data Analysis
# 3.1
# load dataset
diabete_dataset = pd.read_csv("PRML/data/diabetes.csv", sep=",")

diabete_dataset

diabete_dataset.shape

# 3.2
diabete_dataset.info()

# 3.3
diabete_dataset.corr()
