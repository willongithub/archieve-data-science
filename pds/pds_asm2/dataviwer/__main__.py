# Programming for Data Science
# Assignment 2 - Classification in Data Science
# ==============================================================================
"""Entry point."""

from util import Classifier
from gui import DataViewer

def main():

    knn = Classifier('knn', 'iris')
    knn.get_result()
    # knn.info
    
    # app = DataViewer()
    # app.mainloop()

if __name__ == '__main__':
    main()