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