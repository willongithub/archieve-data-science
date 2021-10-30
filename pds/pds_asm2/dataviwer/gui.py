# Programming for Data Science
# Assignment 2 - Classification in Data Science
# ==============================================================================
"""GUI components."""

from util import Classifier

import tkinter as tk
from tkinter import ttk
from tkinter.scrolledtext import ScrolledText
from tkinter.messagebox import showinfo, askokcancel
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk

WIDTH = 1280
HEIGHT = 800
SIDEBAR = 200
SHELL = 500
PADDING = 5

class DataViewer(tk.Tk):

    def __init__(self):
        super().__init__()

        self.dataset_knn = tk.StringVar(self)
        self.ratio_knn = tk.DoubleVar(self)
        self.k_fold_knn = tk.IntVar(self)
        self.neighbor_step_knn = tk.IntVar(self)
        self.neighbor_min_knn = tk.IntVar(self)
        self.neighbor_max_knn = tk.IntVar(self)

        self.dataset_svm = tk.StringVar(self)
        self.ratio_svm = tk.DoubleVar(self)
        self.k_fold_svm = tk.IntVar(self)
        self.gamma_step_svm = tk.DoubleVar(self)
        self.gamma_min_svm = tk.DoubleVar(self)
        self.gamma_max_svm = tk.DoubleVar(self)
        self.c_step_svm = tk.DoubleVar(self)
        self.c_min_svm = tk.DoubleVar(self)
        self.c_max_svm = tk.DoubleVar(self)

        self.dataset_option = ('iris', 'cancer', 'wine')

        self.classifier_knn = Classifier('knn', 'iris')
    
        self.title("Data Viewer")
        # self.resizable(False, False)
        self.resizable(True, True)
        self.iconbitmap('dataviwer/assets/data_viewer.ico')

        # self.columnconfigure(0, weight=1)
        # self.rowconfigure(0, weight=1)

        # create the sizegrip
        # sg = ttk.Sizegrip(self)
        # sg.grid(row=1, sticky=tk.SE)

        # Calculates location of screen centre to put the window.
        screen_width = self.winfo_screenwidth()
        screen_height = self.winfo_screenheight()
        center_x = int(screen_width/2 - WIDTH/2)
        center_y = int(screen_height/2 - HEIGHT/2)

        self.geometry(f'{WIDTH}x{HEIGHT}+{center_x}+{center_y}')

        sidebar_options = {'side': 'left', 'padx': PADDING, 'pady': PADDING, 'fill': 'both'}
        separator_options = {'pady': PADDING, 'fill': 'x'}

        self.notebook = ttk.Notebook(self)
        self.notebook.pack(padx=PADDING, pady=PADDING, expand=True)

        self.tab_knn = ttk.Frame(
            self.notebook,
            width=WIDTH,
            height=HEIGHT)
        self.tab_knn.pack(fill='both', expand=True)
        self.notebook.add(self.tab_knn, text='K-Neighbors Classifier')

        self.sidebar_knn = ttk.LabelFrame(
            self.tab_knn,
            text='OPTIONS',
        )
        self.sidebar_knn.pack(**sidebar_options)
        
        self.frame_dataset_knn = ttk.LabelFrame(
            self.sidebar_knn,
            text='Demo dataset:',
        )
        self.frame_dataset_knn.pack(padx=PADDING)
        ttk.OptionMenu(
            self.frame_dataset_knn,
            self.dataset_knn,
            self.dataset_option[0],
            *self.dataset_option,
            command=lambda arg: self._dataset_changed()
        ).pack()

        self.content_knn = ttk.Frame(
            self.tab_knn
        )
        self.content_knn.pack(side='left')
        self.plot_knn = ttk.Frame(
            self.content_knn,
            width=WIDTH-SHELL
        )
        self.canvas_knn.pack(side='left', fill='x')
        self.shell_knn = ScrolledText(
            self.content_knn,
            bg='gray20',
            fg='lime green',
            height=HEIGHT
        )
        # self.shell_knn.configure(state ='disabled')
        self.shell_knn.pack(side='left')
        



        # self.tab_2 = ttk.Frame(
        #     self.notebook,
        #     width=WIDTH,
        #     height=HEIGHT)
        # self.tab_2.pack(fill='both', expand=True)
        # self.notebook.add(self.tab_2, text='Support Vector Classifier')

        # self.sidebar_2 = ttk.LabelFrame(
        #     self.tab_2,
        #     text='OPTIONS',
        #     width=SIDEBAR,
        #     height=HEIGHT
        # )
        # self.sidebar_2.pack(**sidebar_options)

        # self.canvas_2 = tk.Canvas(
        #     self.notebook,
        #     bg='gray80',
        #     width=WIDTH - SIDEBAR,
        #     height=HEIGHT
        # )
        # self.canvas_2.pack(side='left')
        
    
    def _dataset_changed(self):
        output = self.classifier_knn.get_result()
        self.shell_knn.insert(tk.INSERT, f'{output}\n')
        # self.shell_knn.configure(state ='disabled')
        # self.shell_knn.pack(side='top')

    def _clear_shell(self):
        self.shell_knn.delete('1.0', tk.END)

    def _display_plot(self):
        plot = self.classifier_knn.get_result()
        canvas = FigureCanvasTkAgg(plot, self.plot_knn)
    
    def _ratio_changed():
        return
    
    def _kfold_changed():
        return

    def _param_changed():
        return
    
    def _run():
        return
