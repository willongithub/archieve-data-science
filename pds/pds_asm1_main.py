# !/usr/bin/env python3

# Programming for Data Science
# Assignment 1
# Classifier and Claster Analysis in Data Science
# -----------------------------------------------
# Name:
# ID:

"""Main function of assignment 1."""

import pds_asm1_utils as ut

WIDTH = 1280
HEIGHT = 800

PROMPT = """
> Q1 Nearest Neighbour Classifier
> Q2 K-Means Clustering
\nEnter your choice (1/2): """

def main():
    """Entry point for the programme."""

    while True:
        flag = int(input(PROMPT))
        if flag == 1:
            flag = 'nnc'
            break
        elif flag == 2:
            flag = 'kmc'
            break
        else:
            print('Please give valid input.')
    
    if flag == 'nnc':
        # Question 1
        # Nearest Neighbour Classifier
        result = ut.nearest_neighbour_classifier()

    elif flag == 'kmc':
        # Question 2
        # K-Means Clustering
        result = ut.k_means_clustering()

    else:
        raise ValueError('Invalid argument provided.')
    
    ut.show_result(result, flag, WIDTH, HEIGHT)
    
    print('End')

if __name__ == '__main__':
    main()