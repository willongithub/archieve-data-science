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
        flag = input(PROMPT)
    
        if flag == '1':
            # Question 1
            # Nearest Neighbour Classifier
            result = ut.nearest_neighbour_classifier()
            break

        elif flag == '2':
            # Question 2
            # K-Means Clustering
            result = ut.k_means_clustering(cluster=2)
            break

        else:
            print('Please give valid input.')
    
    ut.show_result(result, flag, WIDTH, HEIGHT)
    
    print('End of Process')

if __name__ == '__main__':
    main()