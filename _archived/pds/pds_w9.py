# Programming for Data Science
# Week 9 Tutorial
# Vector Quantisation and Nearest Centroid Classifier

import pds_module

def main():
    cluster_list = [2, 3, 4]

    class_a_list = ['data/blue_2d.txt', 'data/blue_4d.txt', 
        'data/blue_8d.txt']
    class_b_list = ['data/red_2d.txt', 'data/red_4d.txt', 
        'data/red_8d.txt']
    input_list = ['data/unknown_2d.txt', 'data/unknown_4d.txt', 
        'data/unknown_8d.txt']

    for i in range(3):
        print(f'\nThis is result from input: {input_list[i]}')
        print(pds_module.nearest_centroid(
            cluster_list[i],
            class_a_list[i],
            class_b_list[i],
            input_list[i]))

if __name__ == '__main__':
    main()