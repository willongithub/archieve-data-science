# Programming for Data Science
# Week 12 Tutorial
# GUI, Cross Validation and Python Class

# %%
import tkinter as tk

# %%
window = tk.Tk()
window.title('Programming for Data Science')
# width x height + x_offset + y_offset
window.geometry('500 x 400 + 100 + 100')

window.mainloop()

# %%
window = tk.Tk()
window.title('Programming for Data Science')
# width x height + x_offset + y_offset
window.geometry('500 x 400 + 100 + 100')

font = 'Cascadia Code, 14'

lbl_header = tk.Label(text='A Simple GUI', font=font, height=1)
lbl_header.place(x=150, y=10)

window.mainloop()

# %%
window = tk.Tk()
window.title('Programming for Data Science')
# width x height + x_offset + y_offset
window.geometry('500 x 400 + 100 + 100')

lbl_header = tk.Label(text='A Simple GUI', font=font, height=1)
lbl_header.place(x=150, y=10)
lbl = tk.Label(text='Select a colour: ', fg='navy', anchor='w', width=25, height=1, font=font)
lbl.place(x=20, y=50)

var = tk.StringVar()

button_1 = tk.Radiobutton(text='red', variable=var, value='r', font=font)
button_1.place(x=200, y=50)
button_1.deselect()

button_2 = tk.Radiobutton(text='blue', variable=var, value='b', font=font)
button_2.place(x=270, y=50)
button_2.deselect()

window.mainloop()

# %%
window = tk.Tk()
window.title('Programming for Data Science')
# width x height + x_offset + y_offset
window.geometry('500 x 400 + 100 + 100')

lbl_header = tk.Label(text='A Simple GUI', font=font, height=1)
lbl_header.place(x=150, y=10)
lbl = tk.Label(text='Select a colour: ', fg='navy', anchor='w', width=25, height=1, font=font)
lbl.place(x=20, y=50)

var = tk.StringVar()

button_1 = tk.Radiobutton(text='red', variable=var, value='r', font=font)
button_1.place(x=200, y=50)
button_1.deselect()

button_2 = tk.Radiobutton(text='blue', variable=var, value='b', font=font)
button_2.place(x=270, y=50)
button_2.deselect()

popout = tk.Label(text='', fg='navy', anchor='w', width=25, height=1, font=font)
popout.place(x=10, y=100)

window.mainloop()

# %%
def select_item():
    selected = var.get()
    if selected == 'r':
        note = 'Red selected'
    elif selected == 'b':
        note = 'Blue selected'
    else:
        note = 'Please select!'
    popout.config(text=note)

# %%
window = tk.Tk()
window.title('Programming for Data Science')
# width x height + x_offset + y_offset
window.geometry('500 x 400 + 100 + 100')

lbl_header = tk.Label(text='A Simple GUI', font=font, height=1)
lbl_header.place(x=150, y=10)
lbl = tk.Label(text='Select a colour: ', fg='navy', anchor='w', width=25, height=1, font=font)
lbl.place(x=20, y=50)

var = tk.StringVar()

button_1 = tk.Radiobutton(text='red', variable=var, value='r', font=font)
button_1.place(x=200, y=50)
button_1.deselect()

button_2 = tk.Radiobutton(text='blue', variable=var, value='b', font=font)
button_2.place(x=270, y=50)
button_2.deselect()

popout = tk.Label(text='', fg='navy', anchor='w', width=25, height=1, font=font)
popout.place(x=10, y=100)

button_3 = tk.Button(text='Confirm', fg='black', bg='lightblue', width=10, height=1, font=font, command=select_item)
button_3.place(x=20, y=150)

window.mainloop()

# %%
from sklearn import datasets, neighbors, mixture, metrics, svm
from sklearn.model_selection import train_test_split, GridSearchCV
import matplotlib.pyplot as plt
import numpy as np

# %%
dataset_iris = datasets.load_iris()

# %%
def train_model(dataset, size, classifier='knn'):
    X = dataset.data
    y = dataset.target
    names = dataset_iris.target_names

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=size, random_state=0)

    if classifier == 'knn':
        estimator = neighbors.KNeighborsClassifier()
        param = [{'n_neighbors': [1, 2, 3, 4, 5, 6]}]
    elif classifier == 'svm':
        estimator = svm.SVC()
        param = [{'gamma': [0.0001, 0.001, 0.01, 0.1, 1.0, 10.0]}]

    gscv = GridSearchCV(
        estimator = estimator,
        param_grid = param,
        cv = 5,
        scoring = 'accuracy'
    )

    gscv.fit(X_train, y_train)

    print(f'Grid scores on validation set: \n')
    means = gscv.cv_results_['mean_test_score']
    stds = gscv.cv_results_['std_test_score']
    results = gscv.cv_results_['params']

    for mean, std, param in zip(means, stds, results):
        print("Parameter: %r, accuracy: %0.3f (+/-%0.03f)"% (param, mean, std*2))
    print(f'\nBest parameter: {gscv.best_params_}')

    y_pred= gscv.predict(X_test)

    accuracy = metrics.accuracy_score(y_test, y_pred) * 100
    # plotcm = metrics.plot_confusion_matrix(gscv, X_test, y_test, display_labels=names)
    plotcm = metrics.ConfusionMatrixDisplay.from_estimator(gscv, X_test, y_test, display_labels=names)
    plotcm.ax_.set_title('Accuracy = {0:.2f}%'.format(accuracy))
    # plt.show()

# %%
train_model(dataset_iris, 0.3)

# %%
train_model(dataset_iris, 0.25)

# %%
train_model(dataset_iris, 0.2)

# %%
dataset_breast_cancer = datasets.load_breast_cancer()
dataset_wine = datasets.load_wine()

# %%
train_model(dataset_breast_cancer, 0.25)

# %%
train_model(dataset_wine, 0.25)

# %%
# Question 1
train_model(dataset_wine, 0.3, 'svm')

# %%
train_model(dataset_iris, 0.3, 'svm')

# %%
# Question 2
class Computer:
    brand = 'default'

    def __init__(self, md='new', hd='new') -> None:
        self.model = md
        self.harddisk = hd

    def change_model(self, md):
        self.model = md
    
    def change_harddisk(self, hd):
        self.harddisk = hd

    @classmethod
    def change_brand(cls, bd):
        cls.brand = bd

# %%
# init default objects
c1 = Computer()
print('c1: ' + c1.brand + ' ' + c1.model + ' ' + c1.harddisk)
c2 = Computer()
print('c2: ' + c2.brand + ' ' + c2.model + ' ' + c2.harddisk)

# %%
# set member value
c1 = Computer('air', '256')
print('c1: ' + c1.brand + ' ' + c1.model + ' ' + c1.harddisk)
c2 = Computer('pro', '512')
print('c2: ' + c2.brand + ' ' + c2.model + ' ' + c2.harddisk)

# %%
# object method
c1.change_model('iMac')
print('c1: ' + c1.brand + ' ' + c1.model + ' ' + c1.harddisk)
c2.change_harddisk('1T')
print('c2: ' + c2.brand + ' ' + c2.model + ' ' + c2.harddisk)

# %%
# class method
c1.change_brand('Pingguo')
print('c1: ' + c1.brand + ' ' + c1.model + ' ' + c1.harddisk)
print('c2: ' + c2.brand + ' ' + c2.model + ' ' + c2.harddisk)

# %%
