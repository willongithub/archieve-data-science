# Programming for Data Science
# Assignment 2 - Classification in Data Science
# ==============================================================================
"""Classifier helper components."""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from sklearn.datasets import load_iris, load_breast_cancer, load_wine
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.pipeline import make_pipeline
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.preprocessing import (StandardScaler, MinMaxScaler, MaxAbsScaler,
                                   RobustScaler)
from sklearn.metrics import (ConfusionMatrixDisplay, classification_report,
                             accuracy_score)

class Classifier:
    """Implement KNN and SVC classifier."""

    def __init__(self, model):
        """Initalze for KNN or SVC."""

        self.model_name = model
        self.dataset_name = 'iris'
        self.partition = 0.2
        self.fold = 5
        self.score = 'accuracy'
        self.scaler = 'minmax'
        self.verbose = 1
        self.parallel = -1

        # Set random state not not.
        self.demo = True

        if model == 'knn':
            self.params = {       
                'n_neighbors': []
            }
        if model == 'svc':
            self.params = {
                'gamma': [],
                'C': []
            }

        self.data_object = None

    @property
    def model(self):
        return self.model_name

    @property
    def data(self):
        """Return dataset description."""

        return self.data_object.DESCR
    
    @property
    def info(self):
        """Return basic info of current classifier."""

        info = [
            f'Classifier: {self.model_name}',
            f'Dataset: {self.dataset_name}',
            f'Data dimmsion: {self.data_object.data.shape}',
            f'Test partition: {self.partition}',
            f'CV fold: {self.fold}',
            f'CV metric: {self.score}',
            # f'Preprocess scaler: {self.scaler}'
        ]

        return info

    def set_params(self, flag='', **params):
        """Load params when fitting or manully set the values."""

        # No flag means load params instead of setting.
        if flag == '': flag = self.model_name

        if flag == 'knn':
            if len(self.params['n_neighbors']) == 0:
                self.params['n_neighbors'] = np.linspace(1, 30, 30,
                                                         dtype=int).tolist()
        elif flag == 'svc':
            if len(self.params['gamma']) == 0:
                self.params['gamma'] = np.logspace(-3, 3, 10).tolist()
            if len(self.params['C']) == 0:
                self.params['C'] = np.logspace(-3, 3, 10).tolist()
        
        # Set values according to flag.
        elif flag == 'k':
            self.params['n_neighbors'] = [params['k']]
        elif flag == 'g':
            self.params['gamma'] = [params['g']]
        elif flag == 'c':
            self.params['C'] = [params['c']]

        # Reset to auto.
        elif flag == 'auto':
            if self.model_name == 'knn':
                self.params['n_neighbors'] = []
        elif flag == 'auto_g':
            if self.model_name == 'svc':
                self.params['gamma'] = []
        elif flag == 'auto_c':
            if self.model_name == 'svc':
                self.params['C'] = []
        else:
            self.params = params
        
        return self.params

    def set_classifier(self, model=''):
        """Load estimator when fitting or manully set the values."""

        if model != '': self.model_name = model

        if self.model_name == 'knn':
            estimator = KNeighborsClassifier()
        elif self.model_name == 'svc':
            estimator = SVC()
        else:
            raise ValueError('Specified estimator illegal.')
        
        return estimator

    def set_scaler(self, scaler=''):
        """Load scaler when fitting or manully set the values."""

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

    def load_data(self, dataset):
        """Load dataset."""
        
        if dataset == 'iris':
            data = load_iris()
        elif dataset == 'cancer':
            data = load_breast_cancer()
        elif dataset == 'wine':
            data = load_wine()
        else:
            if type(dataset) != 'sklearn.utils.Bunch':           
                raise ValueError('Specified dataset illegal.')
            else:
                data = dataset
        
        return data

    def get_result(self):
        """Fit the model and return results."""

        self.data_object = self.load_data(self.dataset_name)
        estimator = self.set_classifier(self.model_name)
        # scaler = self.set_scaler(self.scaler)

        params = self.set_params()

        state = 111 if self.demo else 0
        
        X_train, X_test, y_train, y_test = train_test_split(
            self.data_object.data,
            self.data_object.target,
            test_size=self.partition,
            random_state=state)

        # pipe = make_pipeline(
        #     scaler,
        #     estimator,
        # )

        grid_search = GridSearchCV(
            estimator = estimator,
            param_grid = params,
            cv = self.fold,
            scoring = self.score,
            verbose = self.verbose,
            n_jobs = self.parallel
        )
        
        grid_search.fit(X_train, y_train)

        y_pred = grid_search.predict(X_test)


        result = {
            'y_true': y_test,
            'y_pred': y_pred,
            'gscv': grid_search
        }

        return result

    def get_report(self, result):
        """Return fitting report, including recall, accuracy, etc."""
        report = classification_report(
            result['y_true'], result['y_pred'],
            target_names=self.data_object.target_names)

        return report

    def get_output(self, result):
        """Return assignment require outputs."""

        params = result['gscv'].best_params_
        accuracy = accuracy_score(result['y_true'], result['y_pred']) * 100
        prediction = pd.DataFrame({
            'True': result['y_true'],
            'Pred': result['y_pred']
        })
        output = [
            f'Accuracy score: {accuracy:3.2f}%',
            f'Best parameters:\n{params}',
            f'Prediction:\n{prediction}'
        ]

        return output

    def get_confusion_matrix_plot(self, result):
        """Plot confusion matrix."""

        plot = ConfusionMatrixDisplay.from_predictions(
            result['y_true'], result['y_pred'],
            display_labels=self.data_object.target_names).figure_

        return plot

    def get_params_cv_plot(self, result):
        """Plot cross-validation of hyper parameters."""
        
        if self.model_name == 'knn':
            x = self.params['n_neighbors']
            y = result['gscv'].cv_results_['mean_test_score'].tolist()

            fig, ax = plt.subplots()
            ax.plot(x, y, label='score')

            max_y = max(y)
            max_x = x[y.index(max_y)]

            text = f'K: {max_x}'

            ax.plot(max_x, max_y, ls='', marker='o', label='optimal')

            arrowprops = dict(
                arrowstyle="->",
                shrinkB=5,
                connectionstyle='angle3, angleA=90, angleB=170')
            options = dict(
                xy=(max_x, max_y),
                xytext=(0.85, 0.5),
                xycoords='data',
                textcoords='figure fraction',
                arrowprops=arrowprops,
                ha='right', va='top')

            ax.annotate(text, **options)

            ax.set_xlabel('Number of Neighbors (K)')
            ax.set_ylabel('CV Score')
            ax.set_title("CV hyper-parameters (KNN)")
            ax.legend()
        
        if self.model_name == 'svc':
            x = result['gscv'].cv_results_['param_gamma']
            y = result['gscv'].cv_results_['param_C']
            z = result['gscv'].cv_results_['mean_test_score']

            fig = plt.figure()
            ax = fig.add_subplot(projection='3d')
            
            ax.plot(x, y, z, label='score')

            
            max_x = result['gscv'].best_params_['gamma']
            max_y = result['gscv'].best_params_['C']
            max_z = max(z)

            text = f'Gamma: {max_x:3.2f}, C: {max_y:3.2f}'

            ax.plot(max_x, max_y, max_z, ls='', marker='o', label='optimal')

            ax.text(max_x, max_y, max_z + 0.05, text)

            ax.set_xlabel('Gamma')
            ax.set_ylabel('C')
            ax.set_zlabel('CV Score')
            ax.set_title("CV hyper-parameters (SVC)")
            ax.legend()
        
        return fig