#!/usr/bin/env python3

# PRML Lab Week 3

"""
Pattern Recognition and Machine Learning
Week 3 Tutorial
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Exploring the dataset
iris = pd.read_csv("data/iris.data", sep=',', names=["sepal_length",
                                                     "sepal_width",
                                                     "petal_length",
                                                     "petal_width",
                                                     "species"])

iris.head()

iris.info()

iris.isnull().sum()

iris["species"].value_counts()

iris["species"]

# Visualizing data with Matplotlib
