'''Classification helper components.'''

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from sklearn.datasets import load_iris, load_breast_cancer, load_wine
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, plot_confusion_matrix, ConfusionMatrixDisplay, classification_report, confusion_matrix

def get_data(data_name: str='iris') -> object:
    ''''''

    try:
        if data_name == 'iris':
            data = load_iris()
            # data = load_iris(return_X_y=True, as_frame=True)
        elif data_name == 'cancer':
            data = load_breast_cancer()
            # data = load_breast_cancer(return_X_y=True, as_frame=True)
        elif data_name == 'wine':
            data = load_wine()
            # data = load_wine(return_X_y=True, as_frame=True)
    except Exception:
        print('Loading dataset failed.')
    
    return data

class Classifier():
    ''''''

    def __init__(
        self,
        classifier,
        data,
        ratio=0.2,
        k_fold=5,
        score='accuracy',
        scaler='standard',
        demo=True) -> None:
        ''''''

        self.estimator = classifier
        self.dataset = data
        self.partition = ratio
        self.cv_fold = k_fold
        self.score = score
        self.scaler = scaler
        self.demo_flag = demo
    
    def set_classifier(self, classifier):
        self.estimator = classifier

    def set_split_ratio(self, ratio):
        self.partition = ratio

    def set_params(self, flag, *values):
        if flag == 'k':
            self.params = {
                # 'n_neighbors': [1, 2, 3, 4, 5, 6, 7, 8, 9],
                # 'n_neighbors': values,
                'n_neighbors': np.linspace(1, 10, 10),
            }
        elif flag == 'g':
            self.params = {
                # 'gamma': [0.0001, 0.001, 0.01, 0.1, 1.0, 10.0],
                # 'gamma': values,
                'gamma': np.logspace(-2, 2, 10),
            }
        elif flag == 'c':
            self.params = {
                # 'C': [0.1, 0.2, 0.4, 0.6, 0.8, 1.0],
                # 'C': values,
                'C': np.logspace(-1, 0, 10),
            }
        elif flag == 'gc':
            self.params = {
                # 'gamma': [0.0001, 0.001, 0.01, 0.1, 1.0, 10.0],
                # 'C': [0.1, 0.2, 0.4, 0.6, 0.8, 1.0],
                # 'gamma': values[0],
                # 'C': values[1],
                'gamma': np.logspace(-2, 2, 10),
                'C': np.logspace(-1, 0, 10),
            }
        else:
            self.params = {}

    def set_k_fold(self, k_fold):
        self.cv_fold = k_fold
    
    def set_score(self, score):
        self.score = score

    def set_preprocess(self, scaler):
        self.scaler = scaler

    def set_demo_flag(self, demo):
        self.demo_flag = demo

    def get_result(self):
        ''''''

        if self.estimator == 'knn':
            self.estimator = KNeighborsClassifier()
        elif self.estimator == 'svc':
            self.estimator = SVC()
        
        if self.scaler == 'standard':
            self.scaler = StandardScaler()
        elif self.scaler == 'minmax':
            self.scaler = MinMaxScaler()

        X_train, X_test, y_train, y_test = train_test_split(
            self.dataset.data,
            self.dataset.target,
            test_size=self.partition,
            random_state=self.test_flag)

        pipe = make_pipeline(
            self.scaler(),
            self.estimator(),
        )
        
        grid_search = GridSearchCV(
            estimator = pipe,
            param_grid = self.params,
            cv = self.cv_fold,
            scoring = self.score,
            verbose = 1,
            n_jobs = -1
        )
        
        grid_search.fit(X_train, y_train)

        n_candidates = len(grid_search.cv_results_['params'])
        for i in range(n_candidates):
            print(i, 'params - %s; mean - %0.2f; std - %0.2f'
                % (grid_search.cv_results_['params'][i],
                grid_search.cv_results_['mean_test_score'][i],
                grid_search.cv_results_['std_test_score'][i]))

        y_pred = grid_search.predict(X_test)

        print(classification_report(
            y_test, y_pred,
            target_names=self.dataset.target_names))

        print(confusion_matrix(y_test, y_pred))
