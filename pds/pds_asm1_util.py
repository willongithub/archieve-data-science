# Programming for Data Science
# Assignment 1
# Classifier and Cluster Analysis in Data Science
# -----------------------------------------------
# Name:
# ID:

"""Algorithm implementations."""

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


def read_data_file(dir: str, output: bool=False) -> list:
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

        dim = len(result[0])
        if output:
            print(f'\nData samples read: N = {count}')
            print(f'Sample dimensions: D = {dim}')
            # print(f'File closed: {f.closed}')
    except Exception:
        raise
    return result


def write_result_file(
    dir: str,
    result: list,
    tag: str='',
    name: str='result.data'):
    """Writes the result to a file."""

    # Format file name with path
    if tag != '':
        tag = f'{tag}-'
    output = f"{dir}{tag}{name}"

    try:
        with open(output, 'x') as f:
            for item in result:
                f.write(f'{item}\n')
        print(f"\nOutput saved at /{output}")
        # print("File closed:", f.closed)
    except Exception:
        raise


def draw_sample(
    sample: tuple,
    canvas: object,
    shape: str='dot',
    size: float=7,
    colour: str='black'):
    """Draws data samples to canvas."""

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
    """Draws line linking data points."""

    canvas.create_line(
        start[0],
        start[1],
        end[0],
        end[1],
        fill='gray50')


def show_labels(
    coordinates: list,
    legends: list,
    canvas: object,
    size: int=7,
    offset: float=100):
    """Displays legend labels at desired locations."""

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
    """Converts data sample coordinates according to window size."""

    scale = params[0:2]
    offset = params[2:4]
    point = (sample[index_x], sample[index_y])

    result = [p*s + o for p, s, o in zip(point, scale, offset)]

    return tuple(result)


def get_conversion_params(
    dataset: list,
    width: float,
    height: float,
    index_x: int=0,
    index_y: int=1,
    padding: float=30) -> tuple:
    """Calculates params for convert_coordinates()."""

    max_w = max([d[index_x] for d in dataset])
    min_w = min([d[index_x] for d in dataset])
    max_h = max([d[index_y] for d in dataset])
    min_h = min([d[index_y] for d in dataset])

    scale_w = (width - 2*padding)/(max_w - min_w)
    scale_h = (height - 2*padding)/(max_h - min_h)
    offset_w = [-padding if min_w > 0 else padding][0] - min_w*scale_w
    offset_h = [-padding if min_w > 0 else padding][0] - min_h*scale_h

    result = scale_w, scale_h, offset_w, offset_h
    
    return tuple(result)


# TODO(Liam) Deal with datasets with different dimensions.
# def _check_data_dim(*datasets):
#     """"""
#
#     if :
#         print('Datasets have different dimensions.')


def _get_init_centres(dataset: list, cluster: int) -> list:
    """Generates initial cluster centres."""

    # Calculates the values so that the centres spread evenly on each dimension 
    values = []
    # Get the unit index to retrieve values
    step = int(len(dataset)/(cluster + 1))

    # For each dimension, retrieve corresponding values on the sorted list
    # using the indexes.
    for i in range(len(dataset[0])):
        temp = sorted([sample[i] for sample in dataset])
        # Get the values on one dimension: ....*....*....*....
        values.append(temp[step::step])

    # Restructure the data to one centre per tuple in the list
    result = [tuple([j[i] for j in values]) for i in range(cluster)]
    
    return result


def _get_nearest_centres(dataset: list, centres: list) -> list:
    """Calculates the nearest centre for each data sample."""

    # Return the centres to which corresponding samples affiliate with.
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
    affiliates: list,
    centres: list) -> list:
    """Calculates new centres for each current cluster."""

    result = []
    for c in centres:
        # Get lists of samples for different group according to affiliate list
        group = [d for d, a in zip(dataset, affiliates) if a == c]
        new_centre = []
        for i in range(len(dataset[0])):
            dim = [g[i] for g in group]
            # Calculates centroids for each dimension
            new_centre.append(sum(dim)/len(dim))
        result.append(tuple(new_centre))
    
    return result


def get_new_colour(seed):
    """Generates random colour for tkinter canvas."""

    colour = '#'
    for i in range(3):
        # Use hash() to generate pseudo random number.
        temp = hash(colour + f'{seed}')%100
        # Generates colour in rgb(255, 255, 255).
        if temp > 66:
            temp = temp
        elif temp > 33:
            temp = temp + 100
        else:
            temp = temp + 200
        # Then convert to tkinter compatible hex format.
        colour += f'{temp:02x}'

    return colour


def show_result(
    dataset: list,
    flag: str,
    width: float,
    height: float):
    """Displays the results on tkinter canvas."""

    try:
        if flag in ('1', '3'):
            window = tk.Tk()
            window.title('Data Viewer')
            window.resizable(False, False)
            window.iconbitmap('data_viewer.ico')

            tk.Label(window, text='Nearest Neighbour Classifier').pack()
            canvas = tk.Canvas(window, width=width, height=height)
            
            params = get_conversion_params(dataset, width, height)
            for sample in dataset:
                # Divides the data samples using result labels.
                if sample[-1] == 'a':
                    sample = convert_coordinates(sample, params)
                    draw_sample(sample, canvas, colour='red')
                elif sample[-1] == 'b':
                    sample = convert_coordinates(sample, params)
                    draw_sample(sample, canvas, colour='blue')

            canvas.pack()
            window.mainloop()
        
        elif flag in ('2', '4'):
            window = tk.Tk()
            window.title('Data Viewer')
            window.resizable(False, False)
            window.iconbitmap('data_viewer.ico')

            tk.Label(window, text='K-Means Clustering').pack()
            canvas = tk.Canvas(window, width=width, height=height)

            params = get_conversion_params(dataset[0], width, height)
            colour_dict = {}
            affiliates = []
            for sample, centre in zip(dataset[0], dataset[1]):
                sample = convert_coordinates(sample, params)
                centre = convert_coordinates(centre, params)
                affiliates.append(centre)

                # Genrerates dict {centre: colour} as colour for each centre.
                if centre not in colour_dict.keys():
                    colour_dict[centre] = get_new_colour(centre)

                draw_sample(sample, canvas, colour=colour_dict[centre])
                draw_line(sample, centre, canvas)
            
            centres = list(colour_dict.keys())
            legends = []
            # Count samples to each cluster centre.
            for c in centres:
                count = sum([True for a in affiliates if a == c])
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

    This will output all unknown samples with their class labels to screen,
    cli and a output file.

    Args:
        class_a_dir: Directory to data samples of class A txt file.
        class_b_dir: Directory to data samples of class B txt file.
        input_dir: Directory to unknown input data samples txt file.
        output_dir: Directory to dump output.
        output: Toggle for providing cli and file output or not.
    """

    class_a = read_data_file(class_a_dir, output)
    class_b = read_data_file(class_b_dir, output)
    input = read_data_file(input_dir, output)
    # _check_data_dim(class_a, class_b, input).

    class_a_count = 0
    class_b_count = 0

    result = []
    for sample in input:
        dist = [float('inf')]*2
        # Calculate nearest distance of samples to each group of neighbours.
        for target in class_a:
            if _get_dist(sample, target) < dist[0]:
                dist[0] = _get_dist(sample, target)
        for target in class_b:
            if _get_dist(sample, target) < dist[1]:
                dist[1] = _get_dist(sample, target)
        # Decide to which group this sample belongs and add a label.
        if dist[0] >= dist[1]:
            result.append(sample + ('a',))
            class_a_count += 1
        else:
            result.append(sample + ('b',))
            class_b_count += 1
    
    if output:
        print('')
        for r in result:
            print(f'{r}')
        print(f'\n{len(result)} input samples classified into:')
        print(f'  Class A - {class_a_count} samples')
        print(f'  Class B - {class_b_count} samples')
        
        try:
            # If file with same name existed, raise error but continue.
            write_result_file(output_dir, result)
        except FileExistsError as e:
            print(f'\n>>> {e}')
            print('File not saved, continue.')
    
    return result


def k_means_clustering(
    input_dir: str,
    cluster: int,
    threshold: float,
    output_dir: str,
    output: bool=False) -> object:
    """Implements K-Means Clustering.

    This will output the clustering result on tkinter canvas and to file.
    
    Args:
        input_dir: Directory to input data samples txt file.
        cluster: Number of clusters trying to converge.
        threshold: calculation threshold value.
        output_dir: Directory to dump output.
        output: Toggle for providing cli and file output or not.
    """
    
    input = read_data_file(input_dir, output)

    sum_dist = float('inf')
    new_centres = _get_init_centres(input, cluster)

    while sum_dist > threshold:
        # Temporary sum of distance.
        temp = 0
        centres = new_centres
        affiliates = _get_nearest_centres(input, centres)
        try:
            # Catch error if clustering did not converge.
            new_centres = _get_new_centres(input, affiliates, centres)
        except Exception:
            raise
        
        # Sum of distance between old and new centres.
        for new, old in zip(new_centres, centres):
            temp += _get_dist(new, old)
        
        if temp < sum_dist:
            sum_dist = temp

    result = input, affiliates

    if output:
        print(f'\n{len(input)} input samples clustered into:')
        for i, c in enumerate(centres):
            count = sum([True for a in affiliates if a == c])
            print(f'  Cluster {i}: {c} - {count} samples')
        print(f'\nClusters: K = {cluster}')
        print(f'Threshold: {threshold}')

        out = []
        for i, a in zip(input, affiliates):
            out.append((i, a))
        try:
            # If file with same name existed, raise error but continue.
            write_result_file(output_dir, out)
        except FileExistsError as e:
            print(f'\n>>> {e}')
            print('File not saved, continue.')
    
    return result
