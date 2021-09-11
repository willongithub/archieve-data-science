# !/usr/bin/env python3
"""
Programming for Data Science
Week 6 Tutorial
"""
print(__doc__)

# %%
# reload when debug
# from importlib import reload
# import sys
# reload(sys.modules["pds.io_data"])
# %%
from sys import argv
import io_data as io
file_path = ""
# %%
# from sys import argv
# import pds.io_data as io
# file_path = "pds/"

# %% Q1
iris_dict = io.read_data_dict(file_path + "data/iris.data")
keys = list(iris_dict.keys())
[print(type(iris_dict.keys()), keys[i], type(iris_dict[keys[i]]),
    len(iris_dict[keys[i]])) for i in range(len(keys))];

# %% Q2
import tkinter
# define the width of window created
WINDOW_SIZE = 1024
if len(argv) > 1:
    WINDOW_SIZE = int(argv[1])
# %% 1)
iris_list = io.read_multi_dim_data(file_path + "data/iris.data")
max_x = max([i[0] for i in iris_list])
min_x = min([i[0] for i in iris_list])
param = min_x*0.9
# %%
window_1 = tkinter.Tk()
window_1.title("Data Viwer");
size = WINDOW_SIZE
canvas = tkinter.Canvas(window_1, height=size*0.75, width=size)
scalar = size/(max_x - min_x)*0.8
io.disp_point(canvas, iris_list, 4, 'red', scalar, param)
# %% 2)
# define centres
centre_1 = (5.1, 3.0, 1.1, 0.5)
centre_2 = (4.4, 3.2, 2.8, 0.2)
centre_3 = (5.7, 3.9, 3.9, 0.8)
centres = [centre_1, centre_2, centre_3]
io.disp_point(canvas, centres, 8, 'black', scalar, param)
io.disp_label(tkinter, canvas, centres, scalar, param, 'white')
canvas.pack()
window_1.mainloop()

# %% 3)
list_1 = io.find_nearest_centre(iris_list, centres, centre_1)
# %% 4)
list_2 = io.find_nearest_centre(iris_list, centres, centre_2)
# %% 5)
list_3 = io.find_nearest_centre(iris_list, centres, centre_3)
# %% 6)
lists = [list_1, list_2, list_3]

# %%
window_2 = tkinter.Tk()
window_2.title("Data Viwer");
canvas = tkinter.Canvas(window_2, height=size*0.75, width=size)
io.disp_point(canvas, iris_list, 4, 'red', scalar, param)
io.disp_point(canvas, centres, 8, 'black', scalar, param)
io.disp_label(tkinter, canvas, centres, scalar, param, 'white')
for l, t in zip(lists, centres):
    io.draw_lines(l, t, canvas, scalar, param)
canvas.pack()
window_2.mainloop()

# %% 7)
window_3 = tkinter.Tk()
window_3.title("Data Viwer");
canvas = tkinter.Canvas(window_3, height=size*0.75, width=size)
# %%
new_centre_1 = io.find_centre(list_1)
io.disp_point(canvas, list_1, 4, 'orange', scalar, param)
# %% 8)
new_centre_2 = io.find_centre(list_2)
io.disp_point(canvas, list_2, 4, 'blue', scalar, param)
# %% 9)
new_centre_3 = io.find_centre(list_3)
io.disp_point(canvas, list_3, 4, 'green', scalar, param)
# %% 10)
new_centres = [new_centre_1, new_centre_2, new_centre_3]
io.disp_point(canvas, centres, 8, 'gray', scalar, param)
io.disp_label(tkinter, canvas, centres, scalar, param, 'gray')
io.disp_point(canvas, new_centres, 8, 'black', scalar, param)
io.disp_label(tkinter, canvas, new_centres, scalar, param, 'white')
# %%
for l, t in zip(lists, new_centres):
    io.draw_lines(l, t, canvas, scalar, param)
canvas.pack()
window_3.mainloop()

# %% Q3
ellipse_list = io.read_data_file(file_path + "data/ellipse1.txt")
max_width = max([i[0] for i in ellipse_list])
min_width = min([i[0] for i in ellipse_list])
scalar = size/(max_width - min_width)*0.8
# print(max_width) # 7.2
# print(min_width) # -1.9
param = - min_x*0.9
centre_1 = (2.036779, 2.896883)
centre_2 = (2.836779, 3.896883)
centres = [centre_1, centre_2]
window_4 = tkinter.Tk()
window_4.title("Data Viwer")
canvas = tkinter.Canvas(window_4, height=size*0.75, width=size)
# %%
io.disp_point(canvas, ellipse_list, 4, 'red', scalar, param)
io.disp_point(canvas, centres, 8, 'black', scalar, param)
io.disp_label(tkinter, canvas, centres, scalar, param, 'white')
canvas.pack()
window_4.mainloop()

# %%
window_5 = tkinter.Tk()
window_5.title("Data Viwer")
canvas = tkinter.Canvas(window_5, height=size*0.75, width=size)
# %%
io.disp_point(canvas, ellipse_list, 4, 'red', scalar, param)
io.disp_point(canvas, centres, 8, 'black', scalar, param)
io.disp_label(tkinter, canvas, centres, scalar, param, 'white')
# %%
list_1 = io.find_nearest_centre(ellipse_list, centres, centre_1)
list_2 = io.find_nearest_centre(ellipse_list, centres, centre_2)
lists = [list_1, list_2]
# %%
for l, t in zip(lists, centres):
    io.draw_lines(l, t, canvas, scalar, param)
canvas.pack()
window_5.mainloop()

# %%
window_6 = tkinter.Tk()
window_6.title("Data Viwer")
canvas = tkinter.Canvas(window_6, height=size*0.75, width=size)
new_centre_1 = io.find_centre(list_1)
io.disp_point(canvas, list_1, 4, 'orange', scalar, param)
new_centre_2 = io.find_centre(list_2)
io.disp_point(canvas, list_2, 4, 'blue', scalar, param)
new_centres = [new_centre_1, new_centre_2]
io.disp_point(canvas, centres, 8, 'gray', scalar, param)
io.disp_point(canvas, new_centres, 8, 'black', scalar, param)
io.disp_label(tkinter, canvas, centres, scalar, param, 'gray')
io.disp_label(tkinter, canvas, new_centres, scalar, param, 'white')
for l, t in zip(lists, new_centres):
    io.draw_lines(l, t, canvas, scalar, param)
canvas.pack()
window_6.mainloop()