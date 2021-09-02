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


# Question 8
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
                items = raw_line.split(',')
                line = line.replace('\n', '')
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


# Question 9
def disp_point(canvas, sample_list, radius, color):
  r = radius
  scale = 100
  shift = 100
  for sample in sample_list:
    x = sample[0]*scale + shift
    y = sample[1]*scale + shift
    canvas.create_oval(x - r, y - r, x + r, y + r, fill=color)

def disp_label(tkinker, canvas, sample_list):
    scale = 100
    shift = 100
    for i in range(3):
        x = sample_list[i][0]
        y = sample_list[i][1]
        label = "#" + str(i + 1) + " (" + str(x) + ", " + str(y) + ")"
        x = x*scale + shift
        y = y*scale + shift
        x2 = x - 50
        y2 = y + 150
        canvas.create_line(x, y, x2, y2)
        lb = tkinker.Label(canvas, text=label, bg='gray').place(x=x2, y=y2)