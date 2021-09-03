#!/usr/bin/env python3
print(__doc__)

# PDS Lab Week 5

"""
Programming for Data Science
Week 5 Tutorial
"""
# %%

# Q1
q1 = [i for i in range(100)]
print(q1)
# %%

# Q2
q2 = tuple([i for i in range(100)])
print(q2)
# %%

# Q3
q3 = ['2.1', '3.5', '4.8', '1.1', '2.0']
q3 = [float(i) for i in q3]
print(q3)
# %%

# Q4
q4 = [0, 2, 1, 3, 1, 2, 0, 1]
q4 = [i/sum(q4) for i in q4]
print(q4)
# %%

# Q5
q5 = ['red', 0, 2, 1, 1, 2, 0, 1, 'blue']
[q5.pop(i) for i in [0, -1]]
# q5.pop(0)
# q5.pop(-1)
print(q5)
# %%

# Q6
q6 = [0, 1, 0, 2, 0, 1]
for i in range(len(q6)):
  if q6[i] == 0:
    q6[i] = 10
print(q6)
# %%

# Q7
q7_1 = [2, 3, 1]
q7_2 = [4, 5, 2]
print(q7_1 + q7_2)
print([q7_1, q7_2])
print([tuple(q7_1), tuple(q7_2)])
# %%

# Q8
import pds.io_data as io
# %%

'''
For debuging module imported, you need to restart the kernel.
Otherwise reload the module as follows:
'''
from importlib import reload
import sys
reload(sys.modules["pds.io_data"])
# %%

iris_list = io.read_multi_dim_data("pds/data/iris.data")
print(iris_list)
# %%

# Q9
import tkinter
# %%

# centre samples
centre_1 = (5.1, 3.0, 1.1, 0.5)
centre_2 = (4.4, 3.2, 2.8, 0.2)
centre_3 = (5.7, 3.9, 3.9, 0.8)
centre_list = [centre_1, centre_2, centre_3]
# %%

window = tkinter.Tk()
window.title("Data Viwer")
canvas = tkinter.Canvas(window, height=800, width=1280)

io.disp_point(canvas, iris_list, 5, color="#eb0000")
io.disp_point(canvas, centre_list, 5, color="#000000")

io.disp_label(tkinter, canvas, centre_list)

canvas.pack()
window.mainloop()
# %%