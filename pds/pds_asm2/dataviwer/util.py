# Programming for Data Science
# Assignment 2 - Classification in Data Science
# ==============================================================================
"""Classification helper components."""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from sklearn.datasets import load_iris, load_breast_cancer, load_wine
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler, MinMaxScaler, MaxAbsScaler, RobustScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, plot_confusion_matrix, ConfusionMatrixDisplay, classification_report, confusion_matrix

class Classifier:
    """"""

    def __init__(self, model, dataset):
        """"""

        self.estimator = model
        self.dataset = dataset
        self.partition = 0.2
        self.fold = 5
        self.score = 'accuracy'
        self.scaler = 'minmax'
        self.verbose = 1
        self.parallel = -1

        self.demo = True

        self.params = {}

    @property
    def model(self):
        return self.estimator

    @property
    def data(self):
        return self.dataset.DESCR
    
    @property
    def info(self):
        print(f'Classifier: {self.estimator}')
        print(f'Dataset: {self.dataset}')
        print(f'Test partition: {self.partition}')
        print(f'Cross-validation fold: {self.fold}')
        print(f'Cross-validation metric: {self.score}')
        print(f'Preprocess scaler: {self.scaler}')

    def set_params(self, flag='', **params):
        if flag == '': flag = self.estimator

        if flag == 'knn':
            if len(self.params) == 0:
                self.params['n_neighbors'] = np.linspace(1, 10, 10)
        elif flag == 'svc':
            if len(self.params['gamma']) == 0:
                self.params['gamma'] = np.logspace(-2, 2, 10)
            if len(self.params['C']) == 0:
                self.params['C'] = np.logspace(-1, 0, 10)
        
        elif flag == 'k':
            self.params['n_neighbors'] = params['k']
        elif flag == 'g':
            self.params['gamma'] = params['g']
        elif flag == 'c':
            self.params['C'] = params['c']
        else:
            self.params = params

    def set_classifier(self, model=''):
        if model != '': self.estimator = model

        if self.estimator == 'knn':
            model = KNeighborsClassifier()
        elif self.estimator == 'svc':
            model = SVC()
        else:
            raise ValueError('Specified estimator illegal.')
        
        return model

    def set_scaler(self, scaler=''):
        if scaler != '': self.scaler = scaler

        if self.scaler == 'none':
            scaler = None
        elif self.scaler == 'standard':
            scaler = StandardScaler()
        elif self.scaler == 'minmax':
            scaler = MinMaxScaler()
        elif self.scaler == 'maxabs':
            scaler = MaxAbsScaler()
        elif self.scaler == 'robust':
            scaler = RobustScaler()
        else:
            raise ValueError('Specified scaler illegal.')
        
        return scaler

    def load_data(self, data):
        """"""

        if data == 'iris':
            data = load_iris()
        elif data == 'cancer':
            data = load_breast_cancer()
        elif data == 'wine':
            data = load_wine()
        else:
            if type(data) != 'sklearn.utils.Bunch':           
                raise ValueError('Specified dataset illegal.')
        
        return data

    def get_result(self):
        """"""

        data = self.load_data(self.dataset)
        estimator = self.set_classifier(self.estimator)
        scaler = self.set_scaler(self.scaler)

        state = 111 if self.demo else 0
        
        X_train, X_test, y_train, y_test = train_test_split(
            data.data,
            data.target,
            test_size=self.partition,
            random_state=state)

        grid_search = GridSearchCV(
            estimator = estimator,
            param_grid = self.params,
            cv = self.fold,
            scoring = self.score,
            verbose = self.verbose,
            n_jobs = self.parallel
        )
        
        pipe = make_pipeline(
            scaler,
            grid_search,
        )
        
        pipe.fit(X_train, y_train)

        # n_candidates = len(grid_search.cv_results_['params'])
        # for i in range(n_candidates):
        #     print(i, 'params - %s; mean - %0.2f; std - %0.2f'
        #         % (grid_search.cv_results_['params'][i],
        #         grid_search.cv_results_['mean_test_score'][i],
        #         grid_search.cv_results_['std_test_score'][i]))

        y_pred = pipe.predict(X_test)

        result = classification_report(
            y_test, y_pred,
            target_names=data.target_names)

        # print(confusion_matrix(y_test, y_pred))

        accuracy = accuracy_score(y_test, y_pred) * 100
        plotcm = plot_confusion_matrix(
            pipe, X_test, y_test, display_labels=data.target_names)
        plotcm.ax_.set_title('Accuracy = {0:.2f}%'.format(accuracy))
        # plt.show()

        return plotcm
