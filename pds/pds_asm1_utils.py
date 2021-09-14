# Programming for Data Science
# Assignment 1
# Classifier and Claster Analysis in Data Science
# -----------------------------------------------
# Name:
# ID:

"""Provides implementation of functions for assignment 1."""

import tkinter

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


def _read_data_file(dir: str) -> list:
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
        print("data samples read:", count)
        print("file closed:", f.closed)
    except Exception as argument:
        print(argument)
    return result


def _write_result_file(dir: str, result: list):
    """Write the result to a file."""

    try:
        with open(dir + "result.txt", 'x') as f:
            for item in result:
                f.write(item + '\n')
        print("file closed:", f.closed)
    except Exception as argument:
        print(argument)


def _draw_samples(
    canvas: object,
    dataset: list,
    radius: int,
    color: str):
    """"""

    for sample in dataset:
        canvas.create_oval(
            sample[0] - radius,
            sample[1] - radius,
            sample[0] + radius,
            sample[1] + radius,
            fill = color,
        )


def _draw_lines(
    canvas: object,
    start: tuple,
    end: tuple):
    """"""

    canvas.create_line(
        start[0],
        start[1],
        end[0],
        end[1],
    )

def _draw_labels(canvas: object, dataset: list):
    """"""

    for sample in dataset:
        canvas.create_line(
            sample[0],
            sample[1],
            sample[0] - offset,
            sample[1] + offset,
        )
        label.config(text = "")
        label.place(
            sample[0] - offset,
            sample[1] + offset,
        )


def _convert_coordinates(
    height: int,
    width: int,
    dataset: list,
    ) -> list:
    """"""
    return result


def show_result(
    height: int = 768,
    width: int = 1024,
    dataset: list):
    """"""

    window = tkinter.Tk()
    window.title("Data Viwer")
    canvas = tkinter.Canvas(window, height=height, width=width)
    _draw_samples(canvas, dataset, 5, 'red')
    canvas.pack()
    window.mainloop()


def nearest_neighbour_classifier(
    canvas: object,
    class_a_dir: str,
    class_b_dir: str,
    input_dir: str,
    output_dir: str):
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

    class_a = _read_data_file(class_a_dir)
    class_b = _read_data_file(class_b_dir)
    input = _read_data_file(input_dir)
    result = []

    for sample in input:
        dist = float('inf')*2
        for target in class_a:
            if _get_dist(sample, target) < dist[0]:
                dist[0] = _get_dist(sample, target)
        for target in class_b:
            if _get_dist(sample, target) < dist[1]:
                dist[1] = _get_dist(sample, target)
        if dist[0] >= dist[1]:
            result.append(sample + ('a',))
        else:
            result.append(sample + ('b',))
    
    _write_result_file(output_dir, result)


def k_means_clustering(
    tkinter,
    data_dir: str,
    cluster: int,
    dim: int = 0,
    len: int = 0):
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
    return