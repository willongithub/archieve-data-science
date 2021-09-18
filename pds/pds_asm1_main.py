# !/usr/bin/env python3

# Programming for Data Science
# Assignment 1
# Classifier and Claster Analysis in Data Science
# -----------------------------------------------
# Name:
# ID:

"""Main function of assignment 1."""

import pds_asm1_mata as mata
import pds_asm1_util as util
import pds_asm1_gui as gui

def main():
    """Entry point for the programme."""

    while True:
        flag = input(mata.PROMPT)
    
        if flag == '1':
            # Question 1
            # Nearest Neighbour Classifier
            result = util.nearest_neighbour_classifier(
                        mata.CLASS_A_DIR,
                        mata.CLASS_B_DIR,
                        mata.UNKNOWN_INPUT_DIR,
                        mata.OUTPUT_DIR)
            util.show_result(result, flag, mata.WIDTH, mata.HEIGHT)

        elif flag == '2':
            # Question 2
            # K-Means Clustering
            result = util.k_means_clustering(
                        mata.INPUT_DIR,
                        mata.CLUSTER,
                        mata.THRESHHOLD,
                        mata.OUTPUT_DIR)
            util.show_result(result, flag, mata.WIDTH, mata.HEIGHT)

        elif flag == 'e':
            break

        else:
            app = gui.DataViwer()
            app.mainloop()
            break
    
    print('End of Process')

if __name__ == '__main__':
    main()