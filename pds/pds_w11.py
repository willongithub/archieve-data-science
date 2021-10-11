# Programming for Data Science
# Week 11 Tutorial
# Pandas and Scikit-learn

# %%
import pandas as pd

# %%
# Example 1
url = 'https://media.githubusercontent.com/media/neurospin/pystatsml/master/datasets/salary_table.csv'
salary = pd.read_csv(url)
salary.shape
print(salary)

# %%
# Example 2
cols = ['education', 'experience', 'management', 'salary']
salary_ordered = salary.loc[:, cols]
# salary_ordered = salary[cols]
print(salary_ordered)

# %%
# Example 3
rows = salary['education']=='Master'
salary_master = salary.loc[rows, :]
# salary_master = salary[rows]
print(salary_master)

# %%
# Example 4
rows = salary['education']=='Bachelor'
cols = ['exprience', 'management', 'salary']

# %% rows then cols
print('Select rows then cols:')
salary_rows = salary[rows]
print(salary_rows)
salary_rows_cols = salary_rows[cols]
print(salary_rows_cols)

# %% rows and cols
print('Select rows and cols:')
salary_rows_cols = salary[rows][cols]
print(salary_rows_cols)

# %% loc()
print('Use loc():')
salary_rows_cols = salary.loc[rows, cols]
print(salary_rows_cols)

# %%
# Example 5
salary_sorted = salary.sort_values(by=['education', 'salary'], ascending=False)
print(salary_sorted)

# %%
import tempfile, os.path

# %%
# Example 6
dir = tempfile.gettempdir()
filename = os.path.join(dir, 'salary_sorted.csv')
print(dir)

salary_sorted.to_csv(filename, index=False)
# output_check = pd.read_csv(filename)
# print(output_check)

# %%
# Example 7
dir = tempfile.gettempdir()
filename = os.path.join(dir, 'salary_sorted.xlsx')
print(dir)

salary_sorted.to_excel(filename, sheet_name='Sorted salary', index=False)
# output_check = pd.read_excel(filename)
# print(output_check)

# %%
# Question 1
dir = tempfile.gettempdir()
filename = os.path.join(dir, 'salary_3_edu.xlsx')
print(dir)

# %% phd sheet
rows = salary_sorted['education'] == 'Ph.D'
cols = ['exprience', 'management', 'salary']
salary_phd = salary_sorted[rows][cols]

# %% master sheet
rows = salary_sorted['education'] == 'Master'
cols = ['exprience', 'management', 'salary']
salary_master = salary_sorted[rows][cols]

# %% bachelor sheet
rows = salary_sorted['education'] == 'Bachelor'
cols = ['exprience', 'management', 'salary']
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

# %%
from sklearn import datasets, neighbours, metrics, svm
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt

# %%
dataset_iris = datasets.load_iris()
dataset_iris.head(5)
dataset_iris.info()

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
print(X_train, '\n')
print(X_test, '\n')
print(y_train, '\n')
print(y_test, '\n')

# %%
classifier_knn = neighbours.KNeighborsClass(n_neighbors=3)
classifier_knn.fit(X_train, y_train)
y_pred = classifier_knn.predict(X_test)
metrics.plot_confusion_matrix(classifier_knn, X_test, y_test, display_labels=class_names)
plt.show()

# %%
classifier_knn = neighbours.KNeighborsClass(n_neighbors=1)
classifier_knn.fit(X_train, y_train)
y_pred = classifier_knn.predict(X_test)
metrics.plot_confusion_matrix(classifier_knn, X_test, y_test, display_labels=class_names)
plt.show()

# %%
classifier_svm = svm.SVC(gamma=0.5)
classifier_svm.fit(X_train, y_train)
y_pred = classifier_svm.predict(X_test)
metrics.plot_confusion_matrix(classifier_svm, X_test, y_test, display_labels=class_names)
plt.show()

# %%
classifier_svm = svm.SVC(gamma=0.1)
classifier_svm.fit(X_train, y_train)
y_pred = classifier_svm.predict(X_test)
metrics.plot_confusion_matrix(classifier_svm, X_test, y_test, display_labels=class_names)
plt.show()

# %%
print("Accuracy:",metrics.accuracy_score(y_test, y_pred))
print("Precision:",metrics.precision_score(y_test, y_pred, average='weighted'))
print("Recall:",metrics.recall_score(y_test, y_pred, average='weighted'))
print("F1-score:",metrics.f1_score(y_test, y_pred, average='weighted'))

# %%
# Question 3
def get_accuracy(true_list, pred_list):
    result = true_list - pred_list
    result = result.count(0)
    return result

accuracy = get_accuracy(y_test, y_pred)
print(f'Accuracy: {accuracy} %')