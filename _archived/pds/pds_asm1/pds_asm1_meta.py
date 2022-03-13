# Programming for Data Science
# Assignment 1
# Classifier and Cluster Analysis in Data Science
# -----------------------------------------------
# Name:
# ID:

"""CONST values for util, gui."""

"""
Global parameters.
Default value set here, modify as desired.
"""
# Directories for output file, default to working directory:
OUTPUT_DIR = 'output/'
FILENAME = 'output.data'

"""Tkinter window geometries."""
WIDTH = 1280
HEIGHT = 800
PADDING = 5
SIDEBAR = 120
TAB = 30

"""
CLI parameters.
Default value set here, modify for different input.
"""
# Directories for Nearest Neighbour Classifier:
CLASS_A_DIR = 'assets/blue_2d.txt'
CLASS_B_DIR = 'assets/red_2d.txt'
UNKNOWN_INPUT_DIR = 'assets/unknown_2d.txt'

# Directories for K-Means Clustering:
INPUT_DIR = 'assets/data_4c_2d.txt'

# Cluster number and threshold value should be modified accordingly.
CLUSTER = 4
THRESHHOLD = 0.5

"""
GUI parameters.
Default value set here, modify for different input.
"""
# Directories for Nearest Neighbour Classifier:
DATASET_2D = {
    'class_a_dir': 'assets/blue_2d.txt',  # Neighbour class A dir.
    'class_b_dir': 'assets/red_2d.txt',  # Neighbour class B dir.
    'input_dir': 'assets/unknown_2d.txt'  # Unknown input dir.
}
DATASET_4D = {
    'class_a_dir': 'assets/blue_4d.txt',  # Neighbour class A dir.
    'class_b_dir': 'assets/red_4d.txt',  # Neighbour class B dir.
    'input_dir': 'assets/unknown_4d.txt'  # Unknown input dir.
}
DATASET_8D = {
    'class_a_dir': 'assets/blue_8d.txt',  # Neighbour class A dir.
    'class_b_dir': 'assets/red_8d.txt',  # Neighbour class B dir.
    'input_dir': 'assets/unknown_8d.txt'  # Unknown input dir.
}

# Directories and other params for K-Means Clustering:
DATASET_2C_2D = {
    'input_dir': 'assets/data_2c_2d.txt',  # Input dataset dir.
    'k': 2,  # Number of clusters.
}
DATASET_2C_4D = {
    'input_dir': 'assets/data_2c_4d.txt',  # Input dataset dir.
    'k': 2,  # Number of clusters.
}
DATASET_4C_2D = {
    'input_dir': 'assets/data_4c_2d.txt',  # Input dataset dir.
    'k': 4,  # Number of clusters.
}
DATASET_4C_4D = {
    'input_dir': 'assets/data_4c_4d.txt',  # Input dataset dir.
    'k': 4,  # Number of clusters.
}

# Options for Nearest Neighbour Classifier demo:
DEMO_OPTION_1 = (
    'dataset_2d',
    'dataset_4d',
    'dataset_8d')

# Options for K-Means Clustering demo:
DEMO_OPTION_2 = (
    'input_2c_2d',
    'input_4c_2d',
    'input_2c_4d',
    'input_4c_4d')

# Options for display in GUI:
SIZE_OPTION = ('Small', 'Medium', 'Large')
SHAPE_OPTION = ('triangle', 'dot', 'square')
NEIGHBOUR_TOGGLE = ('True', 'False')
LABEL_TOGGLE = ('True', 'False')
THRESHOLD_OPTION = (0.01, 0.05, 0.10, 0.30, 0.50, 0.70, 1.00, 3.00, 7.00, 10.00)
CLUSTER_OPTION = (2, 4, 8)

# Marker size value.
S = 5
M = 7
L = 9

# Prompt info for CLI.
PROMPT = """
> Default to proceed in GUI:
    0) DataViewer
> or stay in CLI:
    1) Nearest Neighbour Classifier
    2) K-Means Clustering
> print output on CLI and save result in file
    3) Nearest Neighbour Classifier (with output)
    4) K-Means Clustering (with output)
> Quit:
    e) Exit
\nEnter your choice [0/1/2/3/4/e]: """

