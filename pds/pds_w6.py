#!/usr/bin/env python3
print(__doc__)

"""
Programming for Data Science
Week 6 Tutorial
"""
# %% Q1
# reload when debug
from importlib import reload
import sys
reload(sys.modules["pds.io_data"])
import pds.io_data as io
# %%
iris_dict = io.read_data_dict("pds/data/iris.data")
keys = list(iris_dict.keys())
[print(type(iris_dict.keys()), keys[i], type(iris_dict[keys[i]]),
    len(iris_dict[keys[i]])) for i in range(len(keys))];
# %% Q2
import tkinter
# %% 1)
iris_list = io.read_multi_dim_data("pds/data/iris.data")
# max([i[0] for i in iris_list])
# min([i[0] for i in iris_list])
# max([i[1] for i in iris_list])
# min([i[1] for i in iris_list])
# %%
window = tkinter.Tk()
window.title("Data Viwer");
size = 1024
canvas = tkinter.Canvas(window, height=size*0.75, width=size)
scaler = size/(7.9 - 4.3)*0.8
io.disp_point(canvas, iris_list, 5, 'red', scaler)
# canvas.pack()
# window.mainloop()
# %% 2)
# centre samples
centre_1 = (5.1, 3.0, 1.1, 0.5)
centre_2 = (4.4, 3.2, 2.8, 0.2)
centre_3 = (5.7, 3.9, 3.9, 0.8)
centre_list = [centre_1, centre_2, centre_3]
io.disp_point(canvas, centre_list, 7, 'black', scaler)
io.disp_label(tkinter, canvas, centre_list, scaler)
# canvas.pack()
# window.mainloop()
# %% 3)
list_1 = io.find_nearest_centre(iris_list, centre_list, centre_1)
# %% 4)
list_2 = io.find_nearest_centre(iris_list, centre_list, centre_2)
# %% 5)
list_3 = io.find_nearest_centre(iris_list, centre_list, centre_3)
# %% 6)
lists = [list_1, list_2, list_3]
# %%
for l in lists:
    io.draw_lines(l, canvas, scaler)
canvas.pack()
window.mainloop()
# %% 7)
# %% 8)
# %% 9)
# %% 10)
# %% Q3