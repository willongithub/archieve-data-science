#!/usr/bin/env python3

# PDS Lab Week 4

"""
Programming for Data Science
Week 4 Tutorial
"""

import io_data as io
import tkinter

data_list_1 = io.read_data_file("PDS/data/ellipse1.txt")
# print(data_list_1)

data_list_2 = io.read_data_file("PDS/data/ellipse2.txt")
# print(data_list_2)

top = tkinter.Tk()
c = tkinter.Canvas(top, bg="white", height=900, width=1440)

dataset = data_list_1

s = 100
r = 5
d = 200

for x, y in dataset:
    x = x*s + d
    y = y*s + d
    c.create_oval(x - r, y - r, x + r, y + r, outline="red", fill="red")

# Question 1
unknown_sample = (2.236779, 2.896883)
x1 = unknown_sample[0]*s + d
y1 = unknown_sample[1]*s + d
c.create_oval(x1 - r, y1 - r, x1 + r, y1 + r,
              outline="red", fill="white")

# Question 3
nearest_sample = io.find_nearest_neighbour(unknown_sample, dataset)
x2 = nearest_sample[0]*s + d
y2 = nearest_sample[1]*s + d
c.create_oval(x2 - r, y2 - r, x2 + r, y2 + r,
              outline="yellow", fill= "red")
c.create_line(x1, y1, x2, y2)

c.pack()
top.mainloop()
