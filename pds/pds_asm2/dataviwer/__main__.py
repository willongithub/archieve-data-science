print(__doc__)

"""Entry point."""

import helpers

def main():
    data_bunch = helpers.get_data()
    clf = helpers.Classifier(data_bunch, 'knn')

if __name__ == '__main__':
    main()