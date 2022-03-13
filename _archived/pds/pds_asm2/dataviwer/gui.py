# Programming for Data Science
# Assignment 2 - Classification in Data Science
# ==============================================================================
"""GUI components."""

import tkinter as tk
from tkinter import ttk
from tkinter.scrolledtext import ScrolledText
from tkinter.messagebox import askokcancel, showinfo, WARNING
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk

WIDTH = 1280
HEIGHT = 800
SIDEBAR = 200
SHELL = 600
PADDING = 5

class DataViewer(tk.Tk):
    """Data viewer GUI."""

    def __init__(self, **classifiers):
        super().__init__()

        self.dataset_knn = tk.StringVar(self)
        self.partition_knn = tk.DoubleVar(self)
        self.fold_knn = tk.IntVar(self)
        self.k = tk.StringVar(self)

        self.dataset_svc = tk.StringVar(self)
        self.partition_svc = tk.DoubleVar(self)
        self.fold_svc = tk.IntVar(self)
        self.gamma = tk.StringVar(self)
        self.c = tk.StringVar(self)

        self.canvas_plot = tk.Canvas()

        self.dataset_options = ('iris', 'cancer', 'wine')
        self.k_options = ('auto', '3', '5', '7', '9')
        self.gamma_options = (
            'auto', '0.001', '0.01', '0.1', '1.0', '10.0', '100.0')
        self.c_options = (
            'auto', '0.001', '0.01', '0.1', '1.0', '10.0', '100.0')

        # self.classifier_knn = Classifier('knn')
        # self.classifier_svc = Classifier('svc')
        self.classifier_knn = classifiers['knn']
        self.classifier_svc = classifiers['svc']
    
        self.title("Data Viewer")
        self.resizable(False, False)
        self.iconbitmap('dataviwer/assets/data_viewer.ico')
        style = ttk.Style(self)
        style.theme_use('clam')

        # Calculates location of screen centre to put the window.
        screen_width = self.winfo_screenwidth()
        screen_height = self.winfo_screenheight()
        center_x = int(screen_width/2 - WIDTH/2)
        center_y = int(screen_height/2 - HEIGHT/2)

        self.geometry(f'{WIDTH}x{HEIGHT}+{center_x}+{center_y}')


        # Widgets (top level)
        sidebar_options = {
            'side': 'left', 'fill': 'both',
             'padx': PADDING, 'pady': PADDING}

        self.notebook = ttk.Notebook(self)
        self.notebook.pack(padx=PADDING, pady=PADDING, side='left')

        self.shell = ScrolledText(
            self,
            bg='gray20',
            fg='lime green',
            height=HEIGHT
        )
        self.shell.pack(side='left')


        # Widgets (knn).
        self.tab_knn = ttk.Frame(
            self.notebook,
            width=WIDTH-SHELL,
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
        self.frame_dataset_knn.pack(padx=PADDING, pady=PADDING)
        ttk.OptionMenu(
            self.frame_dataset_knn,
            self.dataset_knn,
            self.dataset_options[0],
            *self.dataset_options,
        ).pack()

        self.frame_k_knn = ttk.LabelFrame(
            self.sidebar_knn,
            text='K-Neighbor:',
        )
        self.frame_k_knn.pack(padx=PADDING, pady=PADDING)
        ttk.OptionMenu(
            self.frame_k_knn,
            self.k,
            self.k_options[0],
            *self.k_options,
        ).pack()

        self.frame_partition_knn = ttk.LabelFrame(
            self.sidebar_knn,
            text='Test partition:',
        )
        self.frame_partition_knn.pack(padx=PADDING, pady=PADDING)
        self.partition_knn.set(0.2)
        tk.Scale(
            self.frame_partition_knn,
            variable=self.partition_knn,
            from_=0.1,
            to=0.9,
            digit=2,
            resolution=0.05,
            orient=tk.HORIZONTAL
        ).pack()

        self.frame_fold_knn = ttk.LabelFrame(
            self.sidebar_knn,
            text='K-fold:',
        )
        self.frame_fold_knn.pack(padx=PADDING, pady=PADDING)
        self.fold_knn.set(5)
        tk.Scale(
            self.frame_fold_knn,
            variable=self.fold_knn,
            from_=1,
            to=10,
            resolution=1,
            orient=tk.HORIZONTAL
        ).pack()
        
        
        # Plotting area.
        self.plots_knn = ttk.Notebook(
            self.tab_knn,
            width=WIDTH-SHELL,
            height=HEIGHT
        )
        self.plots_knn.pack(padx=PADDING, pady=PADDING, side='left')
        self.tab_params_cv_knn = ttk.Frame(
            self.plots_knn,
            width=WIDTH-SHELL,
            height=HEIGHT
        )
        self.tab_params_cv_knn.pack(side='left', fill='y')
        self.plots_knn.add(self.tab_params_cv_knn, text='Cross-Validation Parameters')
        self.tab_confusion_matrix_knn = ttk.Frame(
            self.plots_knn,
            width=WIDTH-SHELL,
            height=HEIGHT
        )
        self.tab_confusion_matrix_knn.pack(side='left', fill='y')
        self.plots_knn.add(self.tab_confusion_matrix_knn, text='Confusion Matrix')


        # Run and Exit buttons (knn).
        ttk.Button(
            self.sidebar_knn,
            text='Exit',
            command=self._exit
        ).pack(padx=PADDING, pady=PADDING, side='bottom')
        ttk.Button(
            self.sidebar_knn,
            text='Clear',
            command=lambda: self._clear_shell()
        ).pack(padx=PADDING, pady=PADDING, side='bottom')
        ttk.Button(
            self.sidebar_knn,
            text='Run',
            command=lambda: self._update_content('knn')
        ).pack(padx=PADDING, pady=PADDING, side='bottom')
        

        # Widgets (svc).
        self.tab_svc = ttk.Frame(
            self.notebook,
            width=WIDTH-SHELL,
            height=HEIGHT)
        self.tab_svc.pack(fill='both', expand=True)
        self.notebook.add(self.tab_svc, text='Support Vector Classifier')

        self.sidebar_svc = ttk.LabelFrame(
            self.tab_svc,
            text='OPTIONS',
        )
        self.sidebar_svc.pack(**sidebar_options)
        
        self.frame_dataset_svc = ttk.LabelFrame(
            self.sidebar_svc,
            text='Demo dataset:',
        )
        self.frame_dataset_svc.pack(padx=PADDING)
        ttk.OptionMenu(
            self.frame_dataset_svc,
            self.dataset_svc,
            self.dataset_options[0],
            *self.dataset_options,
        ).pack()

        self.frame_gamma_svc = ttk.LabelFrame(
            self.sidebar_svc,
            text='Gamma:',
        )
        self.frame_gamma_svc.pack(padx=PADDING, pady=PADDING)
        ttk.OptionMenu(
            self.frame_gamma_svc,
            self.gamma,
            self.gamma_options[0],
            *self.gamma_options,
        ).pack()

        self.frame_c_svc = ttk.LabelFrame(
            self.sidebar_svc,
            text='C:',
        )
        self.frame_c_svc.pack(padx=PADDING, pady=PADDING)
        ttk.OptionMenu(
            self.frame_c_svc,
            self.c,
            self.c_options[0],
            *self.c_options,
        ).pack()

        self.frame_partition_svc = ttk.LabelFrame(
            self.sidebar_svc,
            text='Test partition:',
        )
        self.frame_partition_svc.pack(padx=PADDING, pady=PADDING)
        self.partition_svc.set(0.2)
        tk.Scale(
            self.frame_partition_svc,
            variable=self.partition_svc,
            from_=0.1,
            to=0.9,
            digit=2,
            resolution=0.05,
            orient=tk.HORIZONTAL
        ).pack()

        self.frame_fold_svc = ttk.LabelFrame(
            self.sidebar_svc,
            text='K-fold:',
        )
        self.frame_fold_svc.pack(padx=PADDING, pady=PADDING)
        self.fold_svc.set(5)
        tk.Scale(
            self.frame_fold_svc,
            variable=self.fold_svc,
            from_=1,
            to=10,
            resolution=1,
            orient=tk.HORIZONTAL
        ).pack()


        # Plotting area.
        self.plots_svc = ttk.Notebook(
            self.tab_svc,
            width=WIDTH-SHELL,
            height=HEIGHT
        )
        self.plots_svc.pack(padx=PADDING, pady=PADDING, side='left')
        self.tab_params_cv_svc = ttk.Frame(
            self.plots_svc,
            width=WIDTH-SHELL,
            height=HEIGHT
        )
        self.tab_params_cv_svc.pack(side='left', fill='y')
        self.plots_svc.add(self.tab_params_cv_svc, text='Cross-Validation Parameters')
        self.tab_confusion_matrix_svc = ttk.Frame(
            self.plots_svc,
            width=WIDTH-SHELL,
            height=HEIGHT
        )
        self.tab_confusion_matrix_svc.pack(side='left', fill='y')
        self.plots_svc.add(self.tab_confusion_matrix_svc, text='Confusion Matrix')


        # Run and Exit buttons (svc).
        ttk.Button(
            self.sidebar_svc,
            text='Exit',
            command=self._exit
        ).pack(padx=PADDING, pady=PADDING, side='bottom')
        ttk.Button(
            self.sidebar_svc,
            text='Clear',
            command=lambda: self._clear_shell()
        ).pack(padx=PADDING, pady=PADDING, side='bottom')
        ttk.Button(
            self.sidebar_svc,
            text='Run',
            command=lambda: self._update_content('svc')
        ).pack(padx=PADDING, pady=PADDING, side='bottom')
        

    # Draw plot on canvas.
    def _update_content(self, tab):
        if tab == 'knn':
            self.classifier_knn.dataset_name = self.dataset_knn.get()
            self.classifier_knn.partition = self.partition_knn.get()
            self.classifier_knn.fold = self.fold_knn.get()
            if self.k.get() != 'auto':
                self.classifier_knn.set_params(
                    flag='k', k=int(self.k.get()))
            else:
                self.classifier_knn.set_params(flag='auto')

            result = self.classifier_knn.get_result()
            info = self.classifier_knn.info
            self._insert_shell('=========================')
            for item in info:
                self._insert_shell(item)
            self._insert_shell('=========================')
            report = self.classifier_knn.get_report(result)
            self._insert_shell(report)
            output = self.classifier_knn.get_output(result)
            for item in output:
                self._insert_shell(item)
            self._insert_shell('\n\n')

            plot = self.classifier_knn.get_confusion_matrix_plot(result)
            self._render_plot(self.tab_confusion_matrix_knn, plot)

            plot = self.classifier_knn.get_params_cv_plot(result)
            self._render_plot(self.tab_params_cv_knn, plot)

        if tab == 'svc':
            self.classifier_svc.dataset_name = self.dataset_svc.get()
            self.classifier_svc.partition = self.partition_svc.get()
            self.classifier_svc.fold = self.fold_svc.get()
            if self.gamma.get() != 'auto':
                self.classifier_svc.set_params(
                    flag='g', g=float(self.gamma.get()))
            else:
                self.classifier_svc.set_params(flag='auto_g')
            if self.c.get() != 'auto':
                self.classifier_svc.set_params(
                    flag='c', c=float(self.c.get()))
            else:
                self.classifier_svc.set_params(flag='auto_c')

            result = self.classifier_svc.get_result()
            info = self.classifier_svc.info
            self._insert_shell('=========================')
            for item in info:
                self._insert_shell(item)
            self._insert_shell('=========================')
            report = self.classifier_svc.get_report(result)
            self._insert_shell(report)
            output = self.classifier_svc.get_output(result)
            for item in output:
                self._insert_shell(item)
            self._insert_shell('\n\n')

            plot = self.classifier_svc.get_confusion_matrix_plot(result)
            self._render_plot(self.tab_confusion_matrix_svc, plot)

            plot = self.classifier_svc.get_params_cv_plot(result)
            self._render_plot(self.tab_params_cv_svc, plot)

    def _insert_shell(self, output):
        self.shell.insert(tk.INSERT, f'> {output}\n')
        self.shell.see("end")

    def _clear_shell(self):
        answer = askokcancel(
            title='Confirmation',
            message='CLI outout will be removed.',
            icon=WARNING
        )
        if answer:
            self.shell.delete('1.0', tk.END)
            showinfo(
                title='Status',
                message='CLI output all clear.'
            )

    def _render_plot(self, widget, plot):
        if self.canvas_plot:
            for child in widget.winfo_children():
                child.destroy()
        self.canvas_plot = FigureCanvasTkAgg(plot, widget)
        self.canvas_plot.draw()

        toolbar = NavigationToolbar2Tk(self.canvas_plot, widget)
        toolbar.update()

        self.canvas_plot.get_tk_widget().pack(expand=True)

    def _exit(self):
        answer = askokcancel(
            title='Confirmation',
            message='Are you sure?',
            icon=WARNING
        )
        if answer:
            exit()
