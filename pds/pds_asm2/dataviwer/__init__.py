'''Entry point.'''

import helpers

data_bunch = helpers.get_data()
clf = helpers.Classifier(data_bunch, 'knn')