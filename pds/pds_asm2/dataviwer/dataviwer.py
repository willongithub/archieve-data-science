'''GUI components.'''

import tkinter as tk
from tkinter import ttk
from tkinter.messagebox import showinfo, askokcancel

WIDTH = 1280
HEIGHT = 800
SIDEBAR = 20
PADDING = 5

class DatasetOption(ttk.LabelFrame):
    options = (
        'iris',
        'cancer',
        'wine'
    )

    def __init__(self, cls, container):
        super.__init__(container)

        self.var = tk.StringVar(self)

        self.config(title='Choose Dataset:')

        ttk.OptionMenu(
            self,
            variable=self.var,
            default=cls.options[0],
            values=cls.options,
        ).pack()

    def get_var(self):
        return self.var

class RatioOption(ttk.LabelFrame):
    def __init__(self, container):
        super.__init__(container)

        self.var = tk.DoubleVar(self)

        self.config(title='Train/Test Ratio:')

        ttk.Scale(
            self,
            from_=0.1,
            to=0.9,
            variable=self.var,
        ).pack()
    
    def get_var(self):
        return self.var

class KFoldOption(ttk.LabelFrame):
    options = (
        ('3-folds', 3),
        ('5-folds', 5),
        ('7-folds', 7),
        ('9-folds', 9)
    )

    def __init__(self, cls, container):
        super.__init__(container)

        self.var = tk.IntVar(self)

        self.config(title='Cross-Validation Folds')

        for item in cls.options:
            ttk.Radiobutton(
                container,
                text=item[0],
                value=item[1],
                variable=self.var).pack()
    
    def get_var(self):
        return self.var

class ParamOption(tk.Toplevel):
    def __init__(self, container, param_name ,min, max):
        super.__init__(container)

        self.var_min = tk.DoubleVar(self)
        self.var_max = tk.DoubleVar(self)
        self.var_step = tk.DoubleVar(self)

        self.title('Parameter search range')
        self.resizable(False, False)
        self.geometry('300x200')

        frame = ttk.LabelFrame(
            self,
            text=param_name
        )

        ttk.Spinbox(
            frame,
            from_=min,
            to=max,
            textvariable=self.var_min,
            wrap=False
        ).pack()
        ttk.Separator(
            frame,         
            orient='horizontal').pack(ipady=PADDING, fill='x')
    
    def _check_range(self):
        pass
        
    def get_var(self):
        return self.var

class ParamGridButton(ttk.Button):
    def __init__(self, container):
        super.__init__(container)

class RunButton(ttk.Button):
    def __init__(self, container):
        super.__init__(container)

class ClearButton(ttk.Button):
    def __init__(self, container):
        super.__init__(container)

class TabView(ttk.Frame):
    def __init__(self, container):
        super.__init__(container)

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
    
        self.title("Data Viewer")
        # self.resizable(False, False)
        self.resizable(True, True)
        self.iconbitmap('data_viewer.ico')

        self.columnconfigure(0, weight=1)
        self.rowconfigure(0, weight=1)

        # create the sizegrip
        sg = ttk.Sizegrip(self)
        sg.grid(row=1, sticky=tk.SE)

        # Calculates canvas size base on other widgets.
        self.canvas_width = WIDTH - PADDING*2
        self.canvas_height = HEIGHT - PADDING*2

        # Calculates location of screen centre to put the gui window.
        screen_width = self.winfo_screenwidth()
        screen_height = self.winfo_screenheight()
        center_x = int(screen_width/2 - WIDTH/2)
        center_y = int(screen_height/2 - HEIGHT/2)
        self.geometry(f'{WIDTH}x{HEIGHT}+{center_x}+{center_y}')

        notebook = ttk.Notebook(self)
        notebook.pack(padx=PADDING, pady=PADDING, expand=True)

        self.tab_knn = TabView('knn')
        self.tab_svm = TabView('svm')
    
    def _dataset_changed():
        return
    
    def _ratio_changed():
        return
    
    def _kfold_changed():
        return

    def _param_changed():
        return
    
    def _run():
        return
