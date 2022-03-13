# !/usr/bin/env python3

"""
Programming for Data Science
Week 7 Tutorial
"""

print(__doc__)

import io_data as io
import tkinter

WIDTH = 1280
HEIGHT = 800

RADIUS = 5
X_INDEX = 0
Y_INDEX = 1

# Programme 1
dataset_1 = io.read_multi_dim_data("data/data_4c_2d.txt")

X_SCALE, Y_SCALE, X_OFF, Y_OFF = io.transform_data_for_canvas_display(
    dataset_1, X_INDEX, Y_INDEX, WIDTH, HEIGHT)

window_1 = tkinter.Tk()
canvas_1 = tkinter.Canvas(window_1, width=WIDTH, height=HEIGHT)

io.display_data(
    canvas_1, dataset_1,
    X_SCALE, Y_SCALE,
    X_OFF, Y_OFF,
    X_INDEX, Y_INDEX)

canvas_1.pack()
window_1.mainloop()


# Programme 2
WIDTH = 1024
HEIGHT = 768

RADIUS = 7
X_INDEX = 1
Y_INDEX = 3

dataset_2 = io.read_multi_dim_data("data/data_2c_4d.txt")

X_SCALE, Y_SCALE, X_OFF, Y_OFF = io.transform_data_for_canvas_display(
    dataset_2, X_INDEX, Y_INDEX, WIDTH, HEIGHT)

window_2 = tkinter.Toplevel()
canvas_2 = tkinter.Canvas(window_2, width=WIDTH, height=HEIGHT)

io.display_data(
    canvas_2, dataset_2,
    X_SCALE, Y_SCALE,
    X_OFF, Y_OFF,
    X_INDEX, Y_INDEX,
    colour="wine",
    shape='triangle')

canvas_2.pack()
window_2.mainloop()


# Programme 3
centre_1 = (5.1, 3.0, 1.1, 0.5)
centre_2 = (4.4, 3.2, 2.8, 0.2)
centre_3 = (5.7, 3.9, 3.9, 0.8)
centre_list = [centre_1, centre_2, centre_3]

iris_list = io.read_multi_dim_data("data/iris.data")
