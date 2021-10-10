# Programming for Data Science
# Week 10 Tutorial
# Python packages: NumPy, Matplotlib, Scikit-learn

# %%
import numpy as np

# %%
# Example 1
list_0 = [1, 2, 3]
array_0 = np.array(list_0)
print(array_0)

# %%
# Question 1
list_1 = [1, 2, 3]
list_2 = [4, 5, 6]
list_3 = [7, 8, 9]

array_1 = np.array([list_1, list_2, list_3]).flatten()
array_2 = np.array([array_1[:4], array_1[2:6], array_1[4:8]])
print(array_2)

# %%
# Example 2
list_4 = [[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7, 8]]
array_3 = np.array(list_4)
print(array_3, '\n')
print(array_3[:, 0])

# %%
# Question 2
print(array_3[:3, 2:])

# %%
# Question 3
print(array_3[1:, 2:])

# %%
# Question 4
print(array_3.reshape(4, 3), '\n')
print(array_3.T, '\n')
print(array_3.flatten())

# %%
# Example 3
print(np.random.random(), '\n')
print(np.random.random(5))

# %%
# Example 4
print('np.random.rand(2, 3):')
print(np.random.rand(2, 3))
print('np.random.rand(2, 3, 4):')
print(np.random.rand(2, 3, 4))

# %%
# Example 5
print('np.random.randn(2, 3):')
print(np.random.randn(2, 3))
print('np.random.randn(2, 3, 4):')
print(np.random.randn(2, 3, 4))

# %%
# Example 6
print('np.random.randint(low=4):')
print(np.random.randint(low=4))
print('np.random.randint(low=4, high=10):')
print(np.random.randint(low=4, high=10))
print('np.random.randint(low=3, high=10, size=5):')
print(np.random.randint(low=3, high=10, size=5))
print('np.random.randint(low=2, high=10, size=(4, 5)):')
print(np.random.randint(low=2, high=10, size=(4, 5)))

# %%
# Example 7
print('np.random.random_integers(low=2, high=10, size=(4, 5)):')
print(np.random.random_integers(low=2, high=10, size=(4, 5)))
print('np.random.random_sample(size=(4, 5)):')
print(np.random.random_sample(size=(4, 5)))
print('np.random.random(size=(4, 5)):')
print(np.random.random(size=(4, 5)))
print('np.random.ranf(size=(4, 5)):')
print(np.random.ranf(size=(4, 5)))

# %%
import matplotlib.pyplot as plt

# %%
# Example 8
x, y = [], []
values = np.linspace(start=0, stop=2*np.pi, num=100)
for i in values:
    r = np.cos(20*i)
    x.append(r*np.cos(i))
    y.append(r*np.sin(i))
plt.plot(x, y, c='r')
plt.title('r = cos(20*i)')
plt.show()

# %%
# Example 9
for i in np.arange(0, 300, 50):
    x, y = [], []
    values = np.linspace(start=0, stop=2*np.pi, num=100)
    for j in values:
        r = np.cos(i*j)
        x.append(r*np.cos(j))
        y.append(r*np.sin(j))
plt.plot(x, y, c='r')
plt.title('r = cos(20*i)')
plt.show()

# %%
# Example 10
for i in range(10):
    R = 10
    k, l = np.random.random()*2
    x, y = []*2
    values = np.linspace(0, 200, 400)
    for j in values:
        xx = R*((1 - k)*np.cos(j) + l*k*np.cos((1 - k)*j/k))
        x.append(xx)
        yy = R*((1 - k)*np.sin(j) + l*k*np.sin((1 - k)*j/k))
        y.append(yy)
    plt.plot(x, y, c='r')
    plt.title(f'k = {k}, l = {l}')
    plt.show()

# %%
from sklearn import datasets

# %%
# Example 11
iris = datasets.load_iris()
X = iris.data[:, :2]
Y = iris.target
labels = iris.target_names

plt.scatter(X[:, 0], X[:, 1], label='iris', c='r', marker='o', s=50)

plt.xlabel('Sepal length')
plt.ylabel('Sepal width')
plt.title('Iris dataset')
plt.legend()
plt.show()

# %%
# Queation 5
plt.scatter(X[:50, 0], X[:50, 1], label='iris', c='r', marker='o', s=50)
plt.scatter(X[49:100, 0], X[49:100, 1], label='iris', c='g', marker='s', s=50)
plt.scatter(X[99:150, 0], X[99:150, 1], label='iris', c='b', marker='^', s=50)

plt.xlabel('Sepal length')
plt.ylabel('Sepal width')
plt.title('Iris dataset')
plt.legend()
plt.show()