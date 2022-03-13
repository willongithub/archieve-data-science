# !/usr/bin/env python3

# Programming for Data Science
# Assignment 1
# Classifier and Cluster Analysis in Data Science
# -----------------------------------------------
# Name:
# ID:

"""Main function of assignment 1."""

import pds_asm1_meta as meta
import pds_asm1_util as util
import pds_asm1_gui as gui

def main():
    """Entry point for the programme."""

    while True:
        # Select algorithm to run in cli
        flag = input(meta.PROMPT)

        # Toggle output to cli and file
        output = True if flag in ('3', '4') else False
    
        if flag in ('1', '3'):
            # Question 1
            # Nearest Neighbour Classifier
            result = util.nearest_neighbour_classifier(
                        meta.CLASS_A_DIR,
                        meta.CLASS_B_DIR,
                        meta.UNKNOWN_INPUT_DIR,
                        meta.OUTPUT_DIR,
                        output)
            util.show_result(result, flag, meta.WIDTH, meta.HEIGHT)

        elif flag in ('2', '4'):
            # Question 2
            # K-Means Clustering
            result = util.k_means_clustering(
                        meta.INPUT_DIR,
                        meta.CLUSTER,
                        meta.THRESHHOLD,
                        meta.OUTPUT_DIR,
                        output)
            util.show_result(result, flag, meta.WIDTH, meta.HEIGHT)

        elif flag == 'e':
            break

        else:
            # Open GUI with empty, 0 or other input
            app = gui.DataViewer()
            app.mainloop()
            break
    
    print('\nEnd of Process')

if __name__ == '__main__':
    main()