# Pattern Recognition and Machine Learning
# Assignment 3
# Unit Project
# Analyse Effect of User Review on Movie Box Office:
#   Mining Data on Social Media
# ------------------------------------------------------------------------------
# Name:
# ID:

'''Comment opinion analyser.

Sentiment analysis of comments for each movie. It will give a score on how
people think about the move from 1~10.
'''

import data_loader

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.svm import LinearSVC
from sklearn.pipeline import Pipeline
from sklearn.model_selection import GridSearchCV
from sklearn.datasets import load_files
from sklearn.model_selection import train_test_split
from sklearn import metrics
import matplotlib.pyplot as plt

folder = 'assets/comment_data'
dataset = load_files(folder, shuffle=False)
print(len(dataset.data))
# print(dataset.data[0])

X_train, X_test, y_train, y_test = train_test_split(
    dataset.data, dataset.target, test_size=0.2, random_state=111)

pipeline = Pipeline([
    ('vect', TfidfVectorizer(min_df=3, max_df=0.95)),
    ('clf', LinearSVC(C=1000)),
])

parameters = {
        'vect__ngram_range': [(1, 1), (1, 2)],
    }
grid_search = GridSearchCV(pipeline, parameters, n_jobs=-1)
grid_search.fit(X_train, y_train)

n_candidates = len(grid_search.cv_results_['params'])
for i in range(n_candidates):
    print(i, 'params - %s; mean - %0.2f; std - %0.2f'
            % (grid_search.cv_results_['params'][i],
            grid_search.cv_results_['mean_test_score'][i],
            grid_search.cv_results_['std_test_score'][i]))

y_pred = grid_search.predict(X_test)

print(metrics.classification_report(y_test, y_pred,
                                    target_names=dataset.target_names))

cm = metrics.confusion_matrix(y_test, y_pred)
print(cm)

plt.matshow(cm)
plt.show()