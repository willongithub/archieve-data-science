#!/usr/bin/env python3

# PDS Lab Week 4

"""
Programming for Data Science
Week 4 Tutorial
"""

import io_module as io

data_list_1 = io.read_data_file("PDS/data/ellipse1.txt")
print(data_list_1)

import tkinter

data_list_2 = io.read_data_file("PDS/data/ellipse2.txt")
print(data_list_2)

top = tkinter.Tk()
c = tkinter.Canvas(top, bg="white", height=900, width=1440)

s = 100
r = 5
for x, y in data_list_2:
    x = x*s + 200
    y = y*s + 200
    c.create_oval(x - r, y - r, x + r, y + r, outline="red", fill="orange")

c.pack()
top.mainloop()

# Question 1

# Question 2
