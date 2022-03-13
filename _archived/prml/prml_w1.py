# PRML Tute Week 1

## Curve Fitting
from pandas import read_csv
from matplotlib import pyplot
from numpy import arange
from scipy.optimize import curve_fit

# load dataset
url = "https://raw.githubusercontent.com/jbrownlee/Datasets/master/longley.csv"
dataframe = read_csv(url, header=None)
data = dataframe.values

# read input and output values
x, y = data[:, 4], data[:, -1]

# plot
pyplot.scatter(x, y)
pyplot.show()

# define objective function
def objective(x, a, b):
    return a * x + b

# fit the curve
popt, _ = curve_fit(objective, x, y)
a, b = popt
print("y = %.5f * %.5f" % (a, b))

# plot the outcome
pyplot.scatter(x, y)

# draw line on top of it
x_line = arange(min(x), max(x), 1)

y_line = objective(x_line, a, b)

pyplot.plot(x_line, y_line, "--", color="red")
pyplot.show()
