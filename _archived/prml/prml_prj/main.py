# Pattern Recognition and Machine Learning
# Assignment 3
# Unit Project
# Analyse Effect of User Review on Movie Box Office:
#   Mining Data on Social Media
# ------------------------------------------------------------------------------
# Name:
# ID:

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
from sklearn.model_selection import GridSearchCV
from sklearn.datasets import load_files
from sklearn.model_selection import train_test_split
from sklearn import metrics

nb = MultinomialNB(alpha=1)