# Programming for Data Science
# Assignment 1
# Classifier and Claster Analysis in Data Science
# -----------------------------------------------
# Name:
# ID:

"""Implementation of functions for assignment 1."""

import tkinter as tk

def _get_dist(start: tuple, end: tuple) -> float:
    """Computes euclidean distance between start point and end point."""

    # Check if the inputs are valid data samples
    if len(start) != len(end):
        raise ValueError('Two samples have different dimensions.')
    if len(start) == 1:
        raise ValueError('Require data dimension > 1, 1-D given.')
    
    result = 0
    for u, v in zip(start, end):
        result += (u - v)**2
    return result**0.5


def read_data_file(dir: str) -> list:
    """Reads data samples from txt file."""

    result = []
    try:
        with open(dir, 'r') as f:
            count = 0
            while True:
                raw = f.readline()
                # Skip empty lines
                while raw == '\n':
                    raw = f.readline()
                # Check eof and stop if so
                if len(raw) == 0:
                    break
                raw = raw.strip()
                sample = [float(item) for item in raw.split()]
                result.append(tuple(sample))
                count += 1
        # print(f"Data samples read: {count}")
        # print("File closed:", f.closed)
    except Exception:
        raise
    return result


def write_result_file(dir: str, result: list):
    """Write the result to a file."""

    output = dir + "result.data"

    try:
        with open(output, 'x') as f:
            for item in result:
                f.write(item + '\n')
        print(f"Result store at {output}.")
        print("File closed:", f.closed)
    except Exception:
        raise


def draw_sample(
    sample: tuple,
    canvas: object,
    shape: str='dot',
    size: float=7,
    colour: str='black'):
    """"""

    if shape == 'square':
        canvas.create_rectangle(
            sample[0] - size,
            sample[1] - size,
            sample[0] + size,
            sample[1] + size,
            fill=colour,
            outline=colour)
    elif shape == 'triangle':
        canvas.create_polygon(
            sample[0],
            sample[1] + size,
            sample[0] + size*0.866,
            sample[1] - size*0.5,
            sample[0] - size*0.866,
            sample[1] - size*0.5,
            fill=colour,
            outline=colour)
    else:
        canvas.create_oval(
            sample[0] - size,
            sample[1] - size,
            sample[0] + size,
            sample[1] + size,
            fill = colour,
            outline=colour)


def draw_line(
    start: tuple,
    end: tuple,
    canvas: object):
    """"""

    canvas.create_line(
        start[0],
        start[1],
        end[0],
        end[1],
    )


def show_labels(
    coordinates: list,
    legends: list,
    canvas: object,
    size: int=5,
    offset: float=100):
    """"""

    offset_x = -offset
    offset_y = offset

    for c, l in zip(coordinates, legends):
        canvas.create_line(
            c[0],
            c[1],
            c[0] + offset_x,
            c[1] + offset_y)
        canvas.create_oval(
            c[0] - size,
            c[1] - size,
            c[0] + size,
            c[1] + size,
            fill='black')
        tk.Label(
            canvas, 
            text=l,
            bg='gray').place(
                x = c[0] + offset_x,
                y = c[1] + offset_y)


def convert_coordinates(
    sample: tuple,
    params: tuple,
    index_x: int=0,
    index_y: int=1) -> tuple:
    """"""

    scale = params[0:2]
    offset = params[2:4]
    point = (sample[index_x], sample[index_y])

    result = [p*s + o for p, s, o in zip(point, scale, offset)]

    return tuple(result)


def get_conversion_params(
    dataset: list,
    width: float=800,
    height: float=600,
    index_x: int=0,
    index_y: int=1,
    padding: float=30) -> tuple:
    """"""

    max_w = max([d[index_x] for d in dataset])
    min_w = min([d[index_x] for d in dataset])
    max_h = max([d[index_y] for d in dataset])
    min_h = min([d[index_y] for d in dataset])

    scale_w = (width - 2*padding)/(max_w - min_w)
    scale_h = (height - 2*padding)/(max_h - min_h)
    offset_w = [-padding if min_w > 0 else padding][0] - min_w*scale_w
    offset_h = [-padding if min_w > 0 else padding][0] - min_h*scale_h

    result = (scale_w, scale_h, offset_w, offset_h)
    
    return result


# TODO(Liam) Deal with datasets with different dimensions.
# def _check_data_dim(*datasets):
#     """"""
#
#     if :
#         print('Datasets have different dimensions, \
#             so truncated to match lowest one.\n')
#         print(f'{d}-D in progress.')


def _get_init_centres(dataset: list, cluster: int) -> list:
    """"""

    features = []
    step = int(len(dataset)/(cluster + 1))

    for i in range(len(dataset[0])):
        temp = sorted([sample[i] for sample in dataset])
        features.append(temp[step::step])

    result = [tuple([j[i] for j in features]) for i in range(cluster)]
    
    return result


def _get_nearest_centres(dataset: list, centres: list) -> list:
    """"""

    result = []
    for d in dataset:
        dist = float('inf')
        for c in centres:
            if _get_dist(d, c) < dist:
                dist = _get_dist(d, c)
                centre = c
        result.append(centre)

    return result


def _get_new_centres(
    dataset: list,
    affliates: list,
    centres: list) -> list:
    """"""

    result = []
    for c in centres:
        group = [d for d, a in zip(dataset, affliates) if a == c]
        new_centre = []
        for i in range(len(dataset[0])):
            dim = [g[i] for g in group]
            new_centre.append(sum(dim)/len(dim))
        result.append(tuple(new_centre))
    
    return result


def _get_new_colour(seed):
    """"""

    colour = '#'
    for i in range(3):
        temp = hash(colour + f'{seed}')%100
        if temp > 66:
            temp = temp
        elif temp > 33:
            temp = temp + 100
        else:
            temp = temp + 200
        colour += f'{temp:02x}'

    return colour


def show_result(
    dataset: list,
    flag: str,
    width: float,
    height: float):
    """"""

    try:
        if flag == '1':
            window = tk.Tk()
            window.title('Data Viwer')
            window.resizable(False, False)
            window.iconbitmap('data_viwer.ico')

            tk.Label(window, text='Nearest Neighbour Classifier').pack()

            canvas = tk.Canvas(window, width=width, height=height)

            params = get_conversion_params(dataset, width, height)

            for sample in dataset:
                if sample[-1] == 'a':
                    sample = convert_coordinates(sample, params)
                    draw_sample(sample, canvas, colour='red')
                    
                elif sample[-1] == 'b':
                    sample = convert_coordinates(sample, params)
                    draw_sample(sample, canvas, colour='blue')

            canvas.pack()
            window.mainloop()
        
        elif flag == '2':
            window = tk.Tk()
            window.title('Data Viwer')
            window.resizable(False, False)
            window.iconbitmap('data_viwer.ico')

            tk.Label(window, text='K-Means Clustering').pack()

            canvas = tk.Canvas(window, width=width, height=height)

            params = get_conversion_params(dataset[0], width, height)

            colour_dict = {}
            affliates = []
            for sample, centre in zip(dataset[0], dataset[1]):
                sample = convert_coordinates(sample, params)
                centre = convert_coordinates(centre, params)
                affliates.append(centre)

                if centre not in colour_dict.keys():
                    colour_dict[centre] = _get_new_colour(centre)

                draw_sample(sample, canvas, colour=colour_dict[centre])
                draw_line(sample, centre, canvas)
            
            centres = list(colour_dict.keys())
            legends = []
            for c in centres:
                count = sum([True for a in affliates if a == c])
                legends.append(f'{count} samples')
            show_labels(centres, legends, canvas)
            
            canvas.pack()
            window.mainloop()
        
        else:
            print(f"flag {flag} is unidentified.")
            raise ValueError
    except Exception:
        raise


def nearest_neighbour_classifier(
    class_a_dir: str,
    class_b_dir: str,
    input_dir: str,
    output_dir: str,
    output: bool=False) -> list:
    """Implements Nearest Neighbour Classifier.

    This will output all unknown samples with their class labels to screen
    and a file.

    Usage: 

    Args:
        red_dir: Directory to data samples of class one in txt file.
        green_dir: Directory to data samples of class two in txt file.
        input_dir: Directory to unknown data samples txt file.
        output_dir: Directory to dump output.
    """

    class_a = read_data_file(class_a_dir)
    class_b = read_data_file(class_b_dir)
    input = read_data_file(input_dir)
    # _check_data_dim(class_a, class_b, input)

    class_a_count = 0
    class_b_count = 0

    result = []
    for sample in input:
        dist = [float('inf')]*2
        for target in class_a:
            if _get_dist(sample, target) < dist[0]:
                dist[0] = _get_dist(sample, target)
        for target in class_b:
            if _get_dist(sample, target) < dist[1]:
                dist[1] = _get_dist(sample, target)
        if dist[0] >= dist[1]:
            result.append(sample + ('a',))
            class_a_count += 1
        else:
            result.append(sample + ('b',))
            class_b_count += 1
    
    print(result)
    print(f'{len(result)} unknown samples classified into:')
    print(f' Class A - {class_a_count} samples')
    print(f' Class B - {class_b_count} samples')

    if output:
        write_result_file(output_dir, result)
    
    return result


def k_means_clustering(
    input_dir: str,
    cluster: int,
    threshold: float,
    output_dir: str,
    output: bool=False) -> object:
    """Implements K-Means Clustering.

    This will output the clustering result on canvas of tkinter.

    Usage:
    
    Args:
        data_dir: Directory to data txt file.
        cluster: Number of clusters.
        dim: Number of dimensions.
        num: Number of data samples.

    Returns:
        result:
    """

    input = read_data_file(input_dir)

    sum_dist = float('inf')
    new_centres = _get_init_centres(input, cluster)

    while sum_dist > threshold:
        temp = 0
        centres = new_centres
        affliates = _get_nearest_centres(input, centres)
        new_centres = _get_new_centres(input, affliates, centres)
        
        for new, old in zip(new_centres, centres):
            temp += _get_dist(new, old)
        
        if temp < sum_dist:
            sum_dist = temp

    result = input, affliates

    print(f'{len(input)} samples clustered into {cluster} group:')
    for c in centres:
        count = sum([True for a in affliates if a == c])
        print(f' Centre{c} - {count} samples')
    print(f'Threshhold - {threshold}')

    if output:
        out = zip(result)
        write_result_file(output_dir, list(out))
    
    return result
