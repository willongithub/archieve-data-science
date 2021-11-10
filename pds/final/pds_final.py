# Programming for Data Science
# Final Assessment
# ==============================================================================

# %%
# Question 1
# ==============================================================================
x = [[a*b+1 for b in range(2,6)] for a in range(3,9)]
y = x[1:4:2]
z = x[3][2:]
t = x[-2::-4]
u = x[-2][::2]

# Test output.
print('x =', x)
print('y =', y)
print('z =', z)
print('t =', t)
print('u =', u)


# %%
# Question 2
# ==============================================================================
def my_printing(number):
    try:
        if isinstance(number, (int, float)):
            # Let value of *.50 be floored.
            if number % 0.5 == 0:
                number //= 1
            number = round(number)
        else:
            raise TypeError
    except TypeError:
        print('only numbers are accepted')
    else:
        for n in range(number, 0, -1):
            for i in range(n, 0, -1):
                print(i, end=' ')
            print()

# Test output.
my_printing("4")
my_printing(3.50)
my_printing(3.51)
my_printing(5)


# %%
# Question 3
# ==============================================================================
def load_iris_dataset(filename):
    data = []
    target = []
    target_names = []
    target_index = 4
    
    try:
        with open(filename) as f:
            # Start from line 1 (second line).
            odd = False
            
            while True:
                raw = f.readline()
                
                # Skip empty lines.
                while raw == '\n':
                    raw = f.readline()
                
                # Check end of file and stop if so.
                if len(raw) == 0:
                    break
                
                # Read odd number lines.
                if odd:
                    raw = raw.strip().split(',')
                    data.append([float(item) for item in raw[:target_index]])
                    target.append(raw[target_index])
                    if raw[target_index] not in target_names:
                        target_names.append(raw[target_index])
                odd = not odd
            
            # Convert target to levels.
            for i in range(len(target)):
                for level, name in enumerate(target_names):
                    if target[i] == name: target[i] = level

        return data, target, target_names
    except FileNotFoundError:
        print('file not found')

# Test output.
X, y, class_labels = load_iris_dataset('iris.data')
print('X =', X)
print('y =', y)
print('class labels =', class_labels)


# %%
# Question 4
# ==============================================================================
def my_formula(rate, depth):
    pi = 3.1415926
    result = 4*rate/pi/depth**2
    return round(result, 3)

def q4():
    # Calculate the result.
    while True:
        try:
            # Read inputs.
            rate = float(input('''
                Enter the rate of water (in cubic meters/minutes): 
            '''))
            depth = float(input('''
                Enter the specific depth (in meters): 
            '''))

            result = my_formula(rate, depth)
            break
        except ValueError:
            print('Please enter numeric value')
        
    while True:    
        # Convert the result if needed.
        try:
            metric = input('''
                Do you wish the results using the International System of Units? 
            ''')
            if metric == 'Yes':
                unit = 'm/min'
            elif metric == 'no':
                result *= 3.28
                unit = 'ft/min'
            else:
                raise ValueError

            print(f'The water level is rising at about: {result} {unit}')
            break
        except ValueError:
            print ('Please enter Yes/no\n')

# Test output.
q4()


# %%
# Question 5
# ==============================================================================
import numpy as np
import matplotlib.pyplot as plt
from sklearn import datasets

def q5():
    iris = datasets.load_iris()
    X = np.empty([iris.data.shape[0], 2])

    while True:
        try:
            # Read inputs.
            a = int(input('''
                Enter first column to display (as x axis): 
            '''))
            b = int(input('''
                Enter second column to display (as y axis): 
            '''))

            # Check validity.
            if a not in range(4) or b not in range(4):
                raise ValueError

            # Select columns.
            X[:, 0] = iris.data[:, a]
            X[:, 1] = iris.data[:, b]
            break
        except ValueError:
            print('Please column number between 0~3')

    column_names = [
        'Sepal Length',
        'Sepal Width',
        'Petal Length',
        'Petal Width'
    ]

    # Assign axis labels.
    xlabel = column_names[a]
    ylabel = column_names[b]

    plt.scatter(X[:, 0], X[:, 1], label='iris', c='r', marker='o', s=30)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.title('Iris dataset')
    plt.legend()
    plt.show()

# Test output.
q5()


# %%
# Question 6
# ==============================================================================
import pandas as pd

def q6():
    data = pd.read_csv('mycsv.csv')
    output = 'myexcel.xls'
    
    cols = data[[
        'SIS User ID',
        'Submit Assignment 1 (57584)',
        'Submit Assignment 2 (57585)',
        'Submit Assignment 3 (57473)']].dropna()
    
    cols = cols.rename(columns = {
        'SIS User ID': 'ID',
        'Submit Assignment 1 (57584)': 'A1',
        'Submit Assignment 2 (57585)': 'A2',
        'Submit Assignment 3 (57473)': 'Exam'})

    cols = cols.astype({
        'A1': float,
        'A2': float,
        'Exam': float})
    
    sheet_uid = cols[cols['ID'].str.startswith('u')].sort_values('A1')
    sheet_sid = cols[cols['ID'].str.startswith('s')].sort_values('A1')

    try:
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            sheet_uid.to_excel(writer, sheet_name='UID', index=False)
            sheet_sid.to_excel(writer, sheet_name='SID', index=False)
    except Exception as e:
        print(e.args[1])

# Test output.
q6()


# %%
# Question 7
# ==============================================================================
def q7():
    uid_data = pd.read_excel('myexcel.xls', sheet_name='UID')
    sid_data = pd.read_excel('myexcel.xls', sheet_name='SID')
    output = 'question7.png'

    fig, axs = plt.subplots(2, 3, figsize=(24, 12))

    axs[0, 0].hist(uid_data['A1'])
    axs[0, 0].set_xlabel('Mark')
    axs[0, 0].set_ylabel('Number of students')
    axs[0, 0].set_title('UID A1')

    axs[0, 1].hist(uid_data['A2'])
    axs[0, 1].set_xlabel('Mark')
    axs[0, 1].set_ylabel('Number of students')
    axs[0, 1].set_title('UID A2')

    axs[0, 2].hist(uid_data['Exam'])
    axs[0, 2].set_xlabel('Mark')
    axs[0, 2].set_ylabel('Number of students')
    axs[0, 2].set_title('UID Exam')

    axs[1, 0].hist(sid_data['A1'])
    axs[1, 0].set_xlabel('Mark')
    axs[1, 0].set_ylabel('Number of students')
    axs[1, 0].set_title('SID A1')

    axs[1, 1].hist(sid_data['A2'])
    axs[1, 1].set_xlabel('Mark')
    axs[1, 1].set_ylabel('Number of students')
    axs[1, 1].set_title('SID A2')

    axs[1, 2].hist(sid_data['Exam'])
    axs[1, 2].set_xlabel('Mark')
    axs[1, 2].set_ylabel('Number of students')
    axs[1, 2].set_title('SID Exam')

    fig.savefig(output)

# Test output.
q7()


# %%
# Question 8
# ==============================================================================
from sklearn import neighbors
from sklearn.model_selection import train_test_split

def get_confusion_matrix(true_list, predicted_list, class_labels):
    matrix = pd.DataFrame(0, columns=class_labels, index=class_labels)

    for t, p in zip(true_list, predicted_list):
        matrix.iloc[t, p] += 1

    return matrix


def q8():
    dataset = datasets.load_iris()
    X = dataset.data
    y = dataset.target

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, 
        random_state=0)

    classifier = neighbors.KNeighborsClassifier(n_neighbors=3)
    classifier.fit(X_train, y_train)
    y_pred = classifier.predict(X_test)

    labels = ['Setosa', 'Versicolour', 'Virginica']
    confusion_matrix = get_confusion_matrix(y_pred, y_test, labels)
    print(confusion_matrix)

# Test output.
q8()


# %%
# Question 9
# ==============================================================================
import tkinter as tk

class DataDisplay(tk.Tk):

    def __init__(self):
        super().__init__()

        # Define canvas size.
        self.WIDTH = 1024
        self.HEIGHT = 768

        # Leave padding area around.
        self.PADDING = 50

        # Radio button options.
        self.selected = tk.StringVar()
        self.options = {
            'blue_2d': 'blue_2d.txt',
            'red_2d': 'red_2d.txt',
            'unknown_2d': 'unknown_2d.txt',
            'all': 'all'}

        self.title("Scatter Plots")

        for label, value in self.options.items():
            tk.Radiobutton(
                self,
                text=label,
                value=value,
                variable=self.selected,
                command=self._display_plots
            ).pack()
        
        # Initialize a empty canvas.
        self.canvas = tk.Canvas(
            self,
            background='gray80',
            height=self.HEIGHT,
            width=self.WIDTH)
        self.canvas.pack()

    
        
    def _display_plots(self):
        """Display plot selected."""
        
        # Clear canvas.
        self._clear_canvas()

        # Draw data points for individual dataset.
        if self.selected.get() != 'all':
            samples = self._load_data(self.selected.get())
            params = self._convert_coordinates(samples)
            self._draw_samples(samples, params)
        
        # Draw all datasets.
        if self.selected.get() == 'all':
            colours = ['blue', 'red', 'gray']
            files = list(self.options.values())[:3]
            for file, colour in zip(files, colours):
                samples = self._load_data(file)
                params = self._convert_coordinates(samples)
                self._draw_samples(samples, params, colour)

    def _draw_samples(self, samples, params, colour='black'):
        """Draws data points onto canvas."""
        
        # Oval size to draw.
        size = 5

        for sample in samples:
            x = sample[0]*params[0] + params[2]
            y = sample[1]*params[1] + params[3]
            self.canvas.create_oval(
                x - size,
                y - size,
                x + size,
                y + size,
                fill=colour,
                outline=colour)
    
    def _clear_canvas(self):
        """Clear canvas for new plot."""

        self.canvas.destroy()
        self.canvas = tk.Canvas(
            self,
            background='gray80',
            height=self.HEIGHT,
            width=self.WIDTH)
        self.canvas.pack()

    def _convert_coordinates(self, dataset):
        """Convert coordinates for canvas."""

        # Use the first two columns as drawing coordinates.
        index_x = 0
        index_y = 1

        max_w = max([d[index_x] for d in dataset])
        min_w = min([d[index_x] for d in dataset])
        max_h = max([d[index_y] for d in dataset])
        min_h = min([d[index_y] for d in dataset])

        scale_w = (self.WIDTH - 2*self.PADDING)/(max_w - min_w)
        scale_h = (self.HEIGHT - 2*self.PADDING)/(max_h - min_h)
        offset_w = [-self.PADDING if min_w > 0 else self.PADDING][0] - min_w*scale_w
        offset_h = [-self.PADDING if min_w > 0 else self.PADDING][0] - min_h*scale_h
        
        return tuple([scale_w, scale_h, offset_w, offset_h])

    def _load_data(self, dir):
        """Reads data samples from txt file."""

        result = []
        try:
            with open(dir) as f:
                count = 0
                while True:
                    raw = f.readline()
                    # Skip empty lines
                    while raw == '\n':
                        raw = f.readline()
                    # Check eof and stop if so
                    if len(raw) == 0:
                        break
                    raw = raw.strip()
                    sample = [float(item) for item in raw.split()]
                    result.append(tuple(sample))
                    count += 1

            return result
        except Exception as e:
            print(e.args[1])

# Test output.
DataDisplay().mainloop()
# %%
