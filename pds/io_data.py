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

            while True:
                raw_line = file.readline()
                if len(raw_line) > 1:
                    break
            
            while True:
                items = raw_line.split(',')
                print(len(items))
                print(items[2])
                result.append(tuple(items[0:4]))
                raw_line = file.readline()
                if len(raw_line) == 1:
                    raw_line = file.readline()
                    continue
                if len(raw_line) == 0:
                    break
        print("File close status: ", file.closed)
    except Exception as e:
        print(e.args[0])

    return result