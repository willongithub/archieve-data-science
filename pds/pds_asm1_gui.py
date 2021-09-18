# Programming for Data Science
# Assignment 1
# Classifier and Claster Analysis in Data Science
# -----------------------------------------------
# Name:
# ID:

"""Tkinter GUI for assignment 1."""

import pds_asm1_mata as mata
import pds_asm1_util as util

import tkinter
from tkinter import ttk
from tkinter.messagebox import showinfo

WIDTH = 1280
HEIGHT = 800
PADDING = 5
SIDEBAR = 200

class DataViwer(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.demo_option_1 = ('2D', '4D', '8D')
        self.demo_option_2 = ('2C_2D', '2C_4D', '4C_2D', '4C_4D')
        self.size_option = ('Small', 'Medium', 'Large')
        self.shape_option = ('triangle', 'dot', 'square')
        self.neighbour_option = ('True', 'False')
        self.label_option = ('True', 'False')

        self.demo_var_1 = tkinter.StringVar(self)
        self.demo_var_2 = tkinter.StringVar(self)
        self.size_var = tkinter.StringVar(self)
        self.shape_var = tkinter.StringVar(self)
        self.neighbour_var = tkinter.StringVar(self)
        self.label_var = tkinter.StringVar(self)

        self.threshold_var = tkinter.DoubleVar(self)

        self.canvas_width = WIDTH - PADDING*6
        self.canvas_height = HEIGHT - PADDING*6

        self.result_1 = self._get_result('1', self.demo_var_1.get())
        self.result_2 = self._get_result('2', self.demo_var_2.get())

        self.init_state = True

        self.title("Data Viwer")
        self.resizable(False, False)
        self.iconbitmap('data_viwer.ico')
        # window.attributes('-alpha', 0.9)

        screen_width = self.winfo_screenwidth()
        screen_height = self.winfo_screenheight()

        center_x = int(screen_width/2 - WIDTH/2)
        center_y = int(screen_height/2 - HEIGHT/2)

        self.geometry(f'{WIDTH}x{HEIGHT}+{center_x}+{center_y}')

        notebook = ttk.Notebook(self)
        notebook.pack(padx=PADDING, pady=PADDING, expand=True)

        # Tab of Nearest Neighbour Classifier
        tab_1 = ttk.Frame(
                    notebook,
                    width=WIDTH - PADDING*2,
                    height=HEIGHT - PADDING*2)
        tab_1.pack(fill = 'both', expand=True)
        notebook.add(tab_1, text='Nearest Neighbour Classifier')

        # Option panel for Nearest Neighbour Classifier
        sidebar_1 = ttk.Frame(
                        tab_1,
                        width=SIDEBAR,
                        height=HEIGHT)
        sidebar_1.pack(fill = 'both', expand=True, side='left')

        ttk.Label(
            sidebar_1,
            background='gray80',
            text='Demo dataset:').pack()
        ttk.OptionMenu(
            sidebar_1,
            self.demo_var_1,
            self.demo_option_1[1],
            *self.demo_option_1,
            command=self._demo_changed
        ).pack()
        ttk.Separator(sidebar_1, orient='horizontal').pack(fill='x')

        ttk.Label(
            sidebar_1,
            background='gray80',
            text='Marker size:').pack()
        ttk.OptionMenu(
            sidebar_1,
            self.size_var,
            self.size_option[1],
            *self.size_option,
            command=lambda args: self._render_result(flag='1')
        ).pack()
        ttk.Separator(sidebar_1, orient='horizontal').pack(fill='x')

        ttk.Label(
            sidebar_1,
            background='gray80',
            text='Marker shape:').pack()
        ttk.OptionMenu(
            sidebar_1,
            self.shape_var,
            self.shape_option[1],
            *self.shape_option,
            command=lambda args: self._render_result(flag='1')
        ).pack()
        ttk.Separator(sidebar_1, orient='horizontal').pack(fill='x')

        ttk.Label(
            sidebar_1,
            background='gray80',
            text='Show neighbour:').pack()
        ttk.OptionMenu(
            sidebar_1,
            self.neighbour_var,
            self.neighbour_option[1],
            *self.neighbour_option,
            command=lambda args: self._render_result(flag='1')
        ).pack()
        ttk.Separator(sidebar_1, orient='horizontal').pack(fill='x')

        ttk.Button(
            sidebar_1,
            text='Exit',
            command=lambda: self.destroy()
        ).pack(side='bottom')

        ttk.Button(
            sidebar_1,
            text='Save',
            command=self._save_output
        ).pack(side='bottom')

        self.canvas_1 = tkinter.Canvas(
            tab_1,
            bg='gray80',
            width=self.canvas_width,
            height=self.canvas_height)
        self._render_result(flag='1')     

        # Tab of K-Means Clustering
        tab_2 = ttk.Frame(
                    notebook,
                    width=WIDTH - PADDING*2,
                    height=HEIGHT - PADDING*2)     
        tab_2.pack(fill = 'both', expand=True)
        notebook.add(tab_2, text='K-Means Clustering')

        # Option panel for K-Means Clustering
        sidebar_2 = ttk.Frame(
                        tab_2,
                        width=SIDEBAR,
                        height=HEIGHT)
        sidebar_2.pack(fill = 'both', expand=True)

        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Demo dataset:').pack()
        ttk.OptionMenu(
            sidebar_2,
            self.demo_var_2,
            self.demo_option_2[1],
            *self.demo_option_2,
            command=self._demo_changed
        ).pack()
        ttk.Separator(sidebar_2, orient='horizontal').pack(fill='x')

        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Marker size:').pack()
        ttk.OptionMenu(
            sidebar_2,
            self.size_var,
            self.size_option[1],
            *self.size_option,
            command=lambda args: self._render_result(flag='2')
        ).pack()
        ttk.Separator(sidebar_2, orient='horizontal').pack(fill='x')

        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Marker shape:').pack()
        ttk.OptionMenu(
            sidebar_2,
            self.shape_var,
            self.shape_option[1],
            *self.shape_option,
            command=lambda args: self._render_result(flag='2')
        ).pack()
        ttk.Separator(sidebar_2, orient='horizontal').pack(fill='x')

        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Show label:').pack()
        ttk.OptionMenu(
            sidebar_2,
            self.label_var,
            self.label_option[1],
            *self.label_option,
            command=lambda args: self._render_result(flag='2')
        ).pack()
        ttk.Separator(sidebar_2, orient='horizontal').pack(fill='x')

        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Threshold:').pack()
        ttk.Scale(
            sidebar_2,
            from_=0.1,
            to=10,
            orient='horizontal',
            variable=self.threshold_var,
            command=lambda args: self._render_result(flag='2')
        ).pack()
        ttk.Separator(sidebar_2, orient='horizontal').pack(fill='x')

        ttk.Button(
            sidebar_2,
            text='Exit',
            command=lambda: self.destroy()
        ).pack(side='bottom')
        ttk.Button(
            sidebar_2,
            text='Save',
            command=self._save_output
        ).pack(side='bottom')

        self.canvas_2 = tkinter.Canvas(
            tab_2,
            bg='gray80',
            width=self.canvas_width,
            height=self.canvas_height)
        self._render_result(flag='2')

        self.init_state = False  


    def _demo_changed(self, flag, *args):
        """"""

        self._get_result(self, flag, self.demo_var.get())
        self._render_result(self, flag)

    def _get_result(self, flag, demo, *args):
        """Retrieve result."""

        if flag == '1':
            # Question 1
            # Nearest Neighbour Classifier
            result = util.nearest_neighbour_classifier(
                        mata.CLASS_A_DIR,
                        mata.CLASS_B_DIR,
                        mata.UNKNOWN_INPUT_DIR,
                        mata.OUTPUT_DIR)
            return result

        elif flag == '2':
            # Question 2
            # K-Means Clustering
            result = util.k_means_clustering(
                        mata.INPUT_DIR,
                        mata.CLUSTER,
                        mata.THRESHHOLD,
                        mata.OUTPUT_DIR)
            return result

    def _render_result(
        self,
        flag,
        *args):
        """Plot data samples."""

        if self.init_state == False:
            self.canvas_1.delete('all')

        if self.size_var.get() == 'Small':
            size = 4
        elif self.size_var.get() == 'Medium':
            size = 6
        elif self.size_var.get() == 'Large':
            size = 8

        if flag == '1':
            params = util.get_conversion_params(
                self.result_1,
                self.canvas_width,
                self.canvas_height)
            
            if self.neighbour_var.get() == 'True':
                self._show_neighbour(size, params)
            
            for sample in self.result_1:
                if sample[-1] == 'a':
                    sample = util.convert_coordinates(sample, params)
                    util.draw_sample(
                        sample,
                        self.canvas_1,
                        size=size,
                        shape=self.shape_var.get(),
                        colour='red3')
                    
                elif sample[-1] == 'b':
                    sample = util.convert_coordinates(sample, params)
                    util.draw_sample(
                        sample,
                        self.canvas_1,
                        size=size,
                        shape=self.shape_var.get(),
                        colour='blue')


        if flag == '2':
            print('!')

            # if self.label_var.get() == 'True':
            #     util.show_labels()
        
        self.canvas_1.pack(side='left')


    def _show_neighbour(self, size, params):
        class_a = util.read_data_file(mata.CLASS_A_DIR)
        class_b = util.read_data_file(mata.CLASS_B_DIR)

        for sample in class_a:
            sample = util.convert_coordinates(sample, params)
            util.draw_sample(
                sample,
                self.canvas_1,
                size=size,
                shape=self.shape_var.get(),
                colour='deep sky blue')
        
        for sample in class_b:
            sample = util.convert_coordinates(sample, params)
            util.draw_sample(
                sample,
                self.canvas_1,
                size=size,
                shape=self.shape_var.get(),
                colour='tomato')
    
    def _pop_notification(self, msg):
        """"""

        showinfo(title='Note',
                 message=msg)

    def _save_output(self):
        showinfo(title='Output',
                 message='Output saved at: ')


if __name__ == "__main__":
    app = DataViwer()
    app.mainloop()