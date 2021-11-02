# Programming for Data Science
# Assignment 2 - Classification in Data Science
# ==============================================================================
"""Entry point."""

from dataviwer.gui import DataViewer
from dataviwer.utils import Classifier

def main():
    """Initialize classifiers and GUI."""

    DataViewer(
        knn = Classifier('knn'),
        svc = Classifier('svc')
    ).mainloop()

if __name__ == '__main__':
    main()