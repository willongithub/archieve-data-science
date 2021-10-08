# Programming for Data Science
# Week 11 Tutorial
# Pandas and Scikit-learn

# %%
import pandas as pd

# %%
# Example 1
url = ''
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
cols = ['Exprience', 'management', 'salary']

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

# %%
# Question 2

# %%
# Question 3