from asyncio.windows_events import NULL
from pickle import NONE
from posixpath import split
import re
from unittest import result
from numpy import Inf, average

from pandas import offsets


print(__doc__)
'''
Helper functions for pds lab tutorial w4, w5.
'''
# function for reading 2-D data from text file and save to list of tuples
def read_data_file(filename):
    dataset = [] # this is a python list
    f = None
    try:
        f = open(filename, 'r')

        while True:
            line = f.readline()
            if len(line) > 1: # skip empty lines
                break
        
        while True:
            line = line.replace('\n', '') # remove newline/return symbol
            cor = line.split(' ')
            dataset.append((float(cor[0]), float(cor[1])))
            line = f.readline()
            if len(line) == 0: # eof
                break

    except Exception as ex:
        print(ex.args)
    finally:
        if f:
            f.close()
    return dataset


# Question 2
def find_nearest_neighbour(sample_point, dataset):
    nearest_sample = [0]*2
    dist = float('inf')
    for x, y in dataset:
        temp = (x - sample_point[0])**2 + (y - sample_point[1])**2
        if temp < dist:
            dist = temp
            nearest_sample[0] = x
            nearest_sample[1] = y
    return nearest_sample

# Week 5
# Q8
def read_multi_dim_data(filename):
    result = []
    try:
        with open(filename, 'r') as file:
            # skip empty line at the beginning
            while True:
                raw_line = file.readline()
                if len(raw_line) > 1:
                    break
            count = 0
            # read lines and skip empty lines in between
            while True:
                raw_line = raw_line.replace('\n', '')
                items = raw_line.split(',')
                result.append(tuple([float(n) for n in items[:4]]))
                count += 1
                # print("add entry: #", count, end='\r')
                raw_line = file.readline()
                while len(raw_line) == 1:
                    raw_line = file.readline()
                # reach the end of file
                if len(raw_line) == 0:
                    # print("EOF")
                    break
        print("close file status:", file.closed)
    except Exception as e:
        print(e.args[0])
    return result


# Q9
PAR = 2*0.9
def disp_point(canvas, sample_list, radius, color, scaler):
  r = radius
  for sample in sample_list:
    # x = sample[0]*scaler - 4.3*scaler*0.9
    # y = sample[1]*scaler - 2.0*scaler*0.9
    x = sample[0]*scaler - PAR*scaler*2
    y = sample[1]*scaler - PAR*scaler
    canvas.create_oval(x - r, y - r, x + r, y + r, fill=color)

def disp_label(tkinker, canvas, sample_list, scaler):
    for i in range(3):
        x = sample_list[i][0]
        y = sample_list[i][1]
        label = "#" + str(i + 1) + " (" + str(x) + ", " + str(y) + ")"
        # x = x*scaler - 4.3*scaler*0.9
        # y = y*scaler - 2.0*scaler*0.9
        x = x*scaler - PAR*scaler*2
        y = y*scaler - PAR*scaler
        x2 = x - scaler*0.2
        y2 = y + scaler*0.7
        canvas.create_line(x, y, x2, y2)
        tkinker.Label(canvas, text=label, bg='gray').place(x=x2, y=y2)

# Week 6 Q1
def read_data_dict(filename):
    result = {}
    try:
        with open(filename, 'r') as f:
            key = NULL
            value = []
            count = 0
            while True:
                # skip empty line
                while True:
                    raw = f.readline()
                    if len(raw) == 1:
                        continue
                    else:
                        break
                # eof
                if len(raw) == 0:
                    result[key] = value
                    break
                raw = raw.replace('\n', '')
                line = raw.split(',')
                count += 1
                # store previous category if new category found
                if line[4] != key:
                    if len(value) > 0:
                        result[key] = value
                        value.clear()
                    key = line[4]
                # put new line into tuple list
                value.append(tuple(line[:4]))
        print("line read:", count)
    except Exception as e:
        print(e.args[0])
    print("file closed:", f.closed)
    return result

# Week 6 Q2
# 3, 4, 5
def dist2(p1, p2):
    result = (p1[0] - p2[0])**2 + (p1[1] - p2[1])**2
    return result

def find_nearest_centre(samples, centres, target):
    result = []
    for p in samples:
        d = Inf
        t = [0]*2
        for c in centres:
            if dist2(p, c) < d:
                d = dist2(p, c)
                t[0], t[1] = c[0], c[1]
        if t == list(target[:2]):
            result.append((p[0], p[1], t[0], t[1]))
    return result
# 6, 10
def draw_lines(pairs, canvas, scalar):
    for p in pairs:
        p[0], p[2] = [(i - PAR*2)*scalar for i in [p[0], p[2]]]
        p[1], p[3] = [(i - PAR)*scalar for i in [p[1], p[3]]]
        canvas.create_line(p[0], p[1], p[2], p[3])
# 7, 8, 9
def find_centre(samples):
    result = []
    d = Inf
    c, t = [0]*2, [0]*2
    c[0], c[1] = average([zip(i[0], i[1]) for i in samples])
    for p in samples:
        if dist2(p, c) < d:
            d = dist2(p, c)
            t[0], t[1] = p[0], p[1]
    for p in samples:
        result.append((p[0], p[1], t[0], t[1]))
    return result
# Week 6 Q3
