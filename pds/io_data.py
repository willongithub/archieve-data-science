'''
Helper functions for PDS lab tutorial.
'''
from unittest import result
from numpy import Inf, average

# Week 4
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

# Q2
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
        print("file closed:", file.closed)
    except FileNotFoundError as e:
        print(e.args[0])
    return result

# Q9
def disp_point(canvas, sample_list, radius, color, scaler, param):
  r = radius
  for sample in sample_list:
    # x = sample[0]*scaler - 4.3*scaler*0.9
    # y = sample[1]*scaler - 2.0*scaler*0.9
    x = sample[0]*scaler - param*scaler
    y = sample[1]*scaler - param*scaler*0.5
    canvas.create_oval(x - r, y - r, x + r, y + r, fill=color, outline=color)

def disp_label(tkinker, canvas, sample_list, scaler, param, colour):
    for i in range(len(sample_list)):
        x = round(sample_list[i][0], 1)
        y = round(sample_list[i][1], 1)
        label = "#" + str(i + 1) + " (" + str(x) + ", " + str(y) + ")"
        # x = x*scaler - 4.3*scaler*0.9
        # y = y*scaler - 2.0*scaler*0.9
        x = x*scaler - param*scaler
        y = y*scaler - param*scaler*0.5
        x2 = x - scaler*0.3
        y2 = y + scaler*0.9
        canvas.create_line(x, y, x2, y2)
        tkinker.Label(canvas, text=label, bg=colour).place(x=x2, y=y2)


# Week 6
# Q1
def read_data_dict(filename):
    result = {}
    try:
        with open(filename, 'r') as f:
            key = None
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
        # print("line read:", count)
        print("file closed:", f.closed)
    except Exception as e:
        print(e.args[0])
    return result

# Week 6
# Q2
# 3, 4, 5
def dist2(p1, p2):
    result = 0
    for i in range(2):
        result += (p1[i] - p2[i])**2
    return result

def find_nearest_centre(samples, centres, target):
    result = []
    for p in samples:
        t = None
        d = Inf
        for c in centres:
            if dist2(p, c) < d:
                d = dist2(p, c)
                t = c
        if t[0:2] == target[:2]:
            result.append((p[0], p[1], t[0], t[1]))
    return result

# 6, 10
def draw_lines(samples, centre, canvas, scalar, param):
    c = [0]*2
    c[0] = (centre[0] - param)*scalar
    c[1] = (centre[1] - param*0.5)*scalar
    for p in samples:
        p = list(p)
        # p[0], p[2] = [(i - PAR*2)*scalar for i in [p[0], p[2]]]
        # p[1], p[3] = [(i - PAR)*scalar for i in [p[1], p[3]]]
        p[0] = (p[0] - param)*scalar
        p[1] = (p[1] - param*0.5)*scalar
        canvas.create_line(p[0], p[1], c[0], c[1])

# 7, 8, 9
def find_centre(samples):
    d = Inf
    c, t = [0]*2, [0]*2
    c[0] = average([i[0] for i in samples])
    c[1] = average([i[1] for i in samples])
    for p in samples:
        if dist2(p, c) < d:
            d = dist2(p, c)
            t[0], t[1] = p[0], p[1]
    result = t
    return result


# Week 7
def transform_data_for_canvas_display(
    dataset,
    index_x=0,
    index_y=1,
    width=800,
    height=600):
    """Transform data for  canvas."""

    max_w = max([d[index_x] for d in dataset])
    min_w = min([d[index_x] for d in dataset])
    max_h = max([d[index_y] for d in dataset])
    min_h = min([d[index_y] for d in dataset])

    PADDING = 1.05

    scale_w = width/(max_w - min_w)/PADDING
    scale_h = height/(max_h - min_h)/PADDING
    offset_w = -min_w*scale_w
    offset_h = -min_h*scale_h
    
    return(scale_w, scale_h, offset_w, offset_h)


def display_data(
    canvas,
    dataset,
    scale_x,
    scale_y,
    offset_x,
    offset_y,
    index_x=0,
    index_y=1,
    r=5,
    colour='black',
    shape='circle'):
    """Display data samples on the canvas."""

    for sample in dataset:
        x = sample[index_x]*scale_x + offset_x
        y = sample[index_y]*scale_y + offset_y
    
        if shape == 'square':
            canvas.create_rectangle(
                x - r, y - r, x + r, y + r,
                outline=colour, fill= colour)
        elif shape == 'triangle':
            canvas.create_polygon(
                x, y + r, x + 0.866*r, y - 0.5*r, x - 0.866*r, y - 0.5*r,
                outline=colour, fill= colour)
        elif shape == 'circle':
            canvas.create_oval(
                x - r, y - r, x + r, y + r,
                outline=colour, fill= colour)
        else:
            print("No match figure, default to 'circle'.")
            canvas.create_oval(
                x - r, y - r, x + r, y + r,
                outline=colour, fill= colour)