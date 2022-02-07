# Programming for Data Science
# Week 11 Tutorial
# Pandas and Scikit-learn

# %%
import pandas as pd

# %%
# Example 1
url = 'https://media.githubusercontent.com/media/neurospin/pystatsml/master/datasets/salary_table.csv'
salary = pd.read_csv(url)
print(salary.shape)
salary.head(5)

# %%
# Example 2
cols = ['education', 'experience', 'management', 'salary']
salary_ordered = salary.loc[:, cols]
# salary_ordered = salary[cols]
salary_ordered.head(10)

# %%
# Example 3
rows = salary['education']=='Master'
salary_master = salary.loc[rows, :]
# salary_master = salary[rows]
salary_master.head(10)

# %%
# Example 4
rows = salary['education']=='Bachelor'
cols = ['experience', 'management', 'salary']

# %% rows than cols
# Select rows.
salary_rows = salary[rows]
salary_rows.head(10)

# %%
# Select columns.
salary_rows_cols = salary_rows[cols]
salary_rows_cols.head(10)

# %%
# Select rows and cols.
salary_rows_cols = salary[rows][cols]
salary_rows_cols.head(10)

# %%
# Use loc().
salary_rows_cols = salary.loc[rows, cols]
salary_rows_cols.head(10)

# %%
# Example 5
salary_sorted = salary.sort_values(by=['education', 'salary'], ascending=False)
salary_sorted.head(10)

# %%
# import tempfile, os.path

# %%
# Example 6
# dir = tempfile.gettempdir()
# filename = os.path.join(dir, 'salary_sorted.csv')
# print(dir)
filename = 'data/salary_sorted.csv'

salary_sorted.to_csv(filename, index=False)
# output_check = pd.read_csv(filename)
# print(output_check)

# %%
# Example 7
# dir = tempfile.gettempdir()
# filename = os.path.join(dir, 'salary_sorted.xlsx')
# print(dir)
filename = 'data/salary_sorted.xlsx'

salary_sorted.to_excel(filename, sheet_name='Sorted salary', index=False)
# output_check = pd.read_excel(filename)
# print(output_check)

# %%
# Question 1
# dir = tempfile.gettempdir()
# filename = os.path.join(dir, 'salary_3_edu.xlsx')
# print(dir)
filename = 'data/salary_3_edu.xlsx'

# %%
# phd sheet
rows = salary_sorted['education'] == 'Ph.D'
cols = ['experience', 'management', 'salary']
salary_phd = salary_sorted[rows][cols]

# %%
# master sheet
rows = salary_sorted['education'] == 'Master'
cols = ['experience', 'management', 'salary']
salary_master = salary_sorted[rows][cols]

# %%
# bachelor sheet
rows = salary_sorted['education'] == 'Bachelor'
cols = ['experience', 'management', 'salary']
salary_bachelor = salary_sorted[rows][cols]

# %% open excel workbook
with pd.ExcelWriter(filename) as writer:
    salary_phd.to_excel(writer, sheet_name='Ph.D')
    salary_master.to_excel(writer, sheet_name='Master')
    salary_bachelor.to_excel(writer, sheet_name='Bachelor')

# %% output check
output_check = pd.read_excel(filename)
print(output_check)

# %%
# Question 2
from sklearn import datasets, neighbors, metrics, svm
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt

# %%
dataset_iris = datasets.load_iris()
print(dataset_iris.feature_names)
print(dataset_iris.target_names)

# %%
X = dataset_iris.data
print('Array of data samples:')
print(X, '\n')

# %%
n_samples, n_features = X.shape
print(f'Number of data samples: {n_samples}')
print(f'Number of features (Dimensionality): {n_features}\n')

# %%
y = dataset_iris.target
print('True class index of data samples:')
print(y, '\n')

# %%
class_names =dataset_iris.target_names
print(f'Array of class names: {class_names}')
print(f'Number of classes: {len(class_names)}\n')

# %%
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=14)
print(X_train.shape)
# print(X_train, '\n')
print(y_train.shape)
# print(y_train, '\n')

# %%
print(X_test.shape)
# print(X_test, '\n')
print(y_test.shape)
# print(y_test, '\n')

# %%
classifier_knn = neighbors.KNeighborsClassifier(n_neighbors=3)
classifier_knn.fit(X_train, y_train)
y_pred = classifier_knn.predict(X_test)
# metrics.plot_confusion_matrix(classifier_knn, X_test, y_test, display_labels=class_names)
# metrics.ConfusionMatrixDisplay.from_predictions(y_test, y_pred, display_labels=class_names)
metrics.ConfusionMatrixDisplay.from_estimator(classifier_knn, X_test, y_test, display_labels=class_names)
plt.show()

# %%
classifier_knn = neighbors.KNeighborsClassifier(n_neighbors=1)
classifier_knn.fit(X_train, y_train)
y_pred = classifier_knn.predict(X_test)
# metrics.plot_confusion_matrix(classifier_knn, X_test, y_test, display_labels=class_names)
# metrics.ConfusionMatrixDisplay.from_predictions(y_test, y_pred, display_labels=class_names)
metrics.ConfusionMatrixDisplay.from_estimator(classifier_knn, X_test, y_test, display_labels=class_names)
plt.show()

# %%
classifier_svm = svm.SVC(gamma=0.5)
classifier_svm.fit(X_train, y_train)
y_pred = classifier_svm.predict(X_test)
# metrics.plot_confusion_matrix(classifier_svm, X_test, y_test, display_labels=class_names)
# metrics.ConfusionMatrixDisplay.from_predictions(y_test, y_pred, display_labels=class_names)
metrics.ConfusionMatrixDisplay.from_estimator(classifier_knn, X_test, y_test, display_labels=class_names)
plt.show()

# %%
classifier_svm = svm.SVC(gamma=0.1)
classifier_svm.fit(X_train, y_train)
y_pred = classifier_svm.predict(X_test)
# metrics.plot_confusion_matrix(classifier_svm, X_test, y_test, display_labels=class_names)
# metrics.ConfusionMatrixDisplay.from_predictions(y_test, y_pred, display_labels=class_names)
metrics.ConfusionMatrixDisplay.from_estimator(classifier_knn, X_test, y_test, display_labels=class_names)
plt.show()

# %%
# evaluation metrics
print("Accuracy:",metrics.accuracy_score(y_test, y_pred))
print("Precision:",metrics.precision_score(y_test, y_pred, average='weighted'))
print("Recall:",metrics.recall_score(y_test, y_pred, average='weighted'))
print("F1-score:",metrics.f1_score(y_test, y_pred, average='weighted'))

# %%
# Question 3
def get_accuracy(true_list, pred_list):
    result = true_list == pred_list
    return (result.sum()/len(result)) * 100

accuracy = get_accuracy(y_test, y_pred)
print(f'Accuracy: {accuracy}%')
# %%
