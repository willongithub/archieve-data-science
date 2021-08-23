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
# pie chart
iplot = iris["species"].value_counts()\
                       .plot(kind='pie', autopct="%.2f", figsize=(8, 8))
iplot.set_ylabel('')

# boxplot
iris.boxplot(by="species", figsize=(12, 6))

# scatterplot
sns.set(style='darkgrid')
sc = iris[iris.species == "Iris-setosa"].plot(kind='scatter', x="sepal_length",
                                              y="sepal_width", color='red',
                                              label="Setosa")

iris[iris.species == "Iris-versicolor"].plot(kind='scatter', x="sepal_length",
                                              y="sepal_width", color='green',
                                              label="Versicolor", ax=sc)

iris[iris.species == "Iris-virginica"].plot(kind='scatter', x="sepal_length",
                                              y="sepal_width", color='orange',
                                              label="Virginica", ax=sc)


sc.set_xlabel("Sepal Length in cm")
sc.set_ylabel("Sepal Width in cm")
sc.set_title("Sepal Length vs Sepal Width")

# Linear regression practice
from sklearn.metrics import mean_squared_error, mean_absolute_error

# split the dataset into train/test sets
from sklearn.model_selection import train_test_split

# import linear regression
from sklearn.linear_model import LinearRegression

# drop petal width from dataset
input = iris[selected_columns].drop(labels="petal_width", axis=1)


# Logistic Regression in classify images of numbers in MNIST inmages
import numpy as np
from sklearn.datasets import fetch_openml

# load images
digits = fetch_openml("mnist_784")
#digits = load_digits()

plt.figure(figsize=(10, 2))
for index, (image, label) in enumerate(zip(digits.data[0, 5],
                                           digits.target[0:5])):
    plt.subplot(1, 5, index + 1)
    plt.imshow(np.reshape(image, (28, 28)), cmap=plt.cm.gray)
    plt.title("Training: %i\n" % int(label), fontsize=15)

# show corresponding matrix
digits.data[0]
