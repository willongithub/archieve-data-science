# !/usr/bin/env python3

# Programming for Data Science
# Assignment 1
# Classifier and Cluster Analysis in Data Science
# -----------------------------------------------
# Name:
# ID:

"""Tkinter GUI."""

import pds_asm1_meta as meta
import pds_asm1_util as util

import tkinter
from tkinter import ttk
from tkinter.messagebox import showinfo

class DataViewer(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.demo_var_1 = tkinter.StringVar(self)
        self.demo_var_2 = tkinter.StringVar(self)
        self.size_var = tkinter.StringVar(self)
        self.shape_var = tkinter.StringVar(self)
        self.neighbour_var = tkinter.StringVar(self)
        self.label_var = tkinter.StringVar(self)

        # Initial state toggle.
        self.init_state = True

        self.title("Data Viewer")
        self.resizable(False, False)
        self.iconbitmap('data_viewer.ico')

        # Calculates canvas size base on other widgets.
        self.canvas_width = meta.WIDTH - meta.PADDING*2 - meta.SIDEBAR
        self.canvas_height = meta.HEIGHT - meta.PADDING*2 - meta.TAB

        # Calculates location of screen centre to put the gui window.
        screen_width = self.winfo_screenwidth()
        screen_height = self.winfo_screenheight()
        center_x = int(screen_width/2 - meta.WIDTH/2)
        center_y = int(screen_height/2 - meta.HEIGHT/2)
        self.geometry(f'{meta.WIDTH}x{meta.HEIGHT}+{center_x}+{center_y}')

        notebook = ttk.Notebook(self)
        notebook.pack(padx=meta.PADDING, pady=meta.PADDING, expand=True)

        # Tab of Nearest Neighbour Classifier.
        self.tab_1 = ttk.Frame(
                    notebook,
                    width=meta.WIDTH - meta.PADDING*2,
                    height=meta.HEIGHT - meta.PADDING*2)
        self.tab_1.pack(fill = 'both', expand=True)
        notebook.add(self.tab_1, text='Nearest Neighbour Classifier')

        # Options panel for Nearest Neighbour Classifier.
        sidebar_1 = ttk.Frame(
                        self.tab_1,
                        width=meta.SIDEBAR,
                        height=meta.HEIGHT)
        sidebar_1.pack(fill = 'both', expand=True, side='left')

        # Widgets for NNC options.
        ttk.Label(
            sidebar_1,
            text='** Display Options **').pack()
        ttk.Separator(
            sidebar_1,
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')
        ttk.Label(
            sidebar_1,
            background='gray80',
            text='Demo dataset:').pack()
        ttk.OptionMenu(
            sidebar_1,
            self.demo_var_1,
            meta.DEMO_OPTION_1[0],
            *meta.DEMO_OPTION_1,
            command=lambda arg: self._demo_changed('1')
        ).pack()
        ttk.Separator(
            sidebar_1,
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')
        ttk.Label(
            sidebar_1,
            background='gray80',
            text='Marker size:').pack()
        ttk.OptionMenu(
            sidebar_1,
            self.size_var,
            meta.SIZE_OPTION[1],
            *meta.SIZE_OPTION,
            command=lambda arg: self._render_result(flag='1')
        ).pack()
        ttk.Separator(
            sidebar_1,
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')
        ttk.Label(
            sidebar_1,
            background='gray80',
            text='Marker shape:').pack()
        ttk.OptionMenu(
            sidebar_1,
            self.shape_var,
            meta.SHAPE_OPTION[1],
            *meta.SHAPE_OPTION,
            command=lambda arg: self._render_result(flag='1')
        ).pack()
        ttk.Separator(
            sidebar_1,
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')
        ttk.Label(
            sidebar_1,
            background='gray80',
            text='Show neighbours:').pack()
        ttk.OptionMenu(
            sidebar_1,
            self.neighbour_var,
            meta.NEIGHBOUR_TOGGLE[1],
            *meta.NEIGHBOUR_TOGGLE,
            command=lambda arg: self._render_result(flag='1')
        ).pack()
        ttk.Separator(sidebar_1, orient='horizontal').pack(fill='x')

        # Save and Exit buttons.
        ttk.Button(
            sidebar_1,
            text='Exit',
            command=lambda: self.destroy()
        ).pack(side='bottom')
        ttk.Button(
            sidebar_1,
            text='Save',
            command=lambda: self._save_output('1')
        ).pack(side='bottom')

        # Initialize canvas 1 for NNC.
        self._create_canvas('1')  

        # Tab of K-Means Clustering.
        self.tab_2 = ttk.Frame(
                    notebook,
                    width=meta.WIDTH - meta.PADDING*2,
                    height=meta.HEIGHT - meta.PADDING*2)     
        self.tab_2.pack(fill = 'both', expand=True)
        notebook.add(self.tab_2, text='K-Means Clustering')

        # Options panel for K-Means Clustering.
        sidebar_2 = ttk.Frame(
                        self.tab_2,
                        width=meta.SIDEBAR,
                        height=meta.HEIGHT)
        sidebar_2.pack(fill = 'both', expand=True, side='left')

        # Widgets for KMC options.
        ttk.Label(
            sidebar_2,
            text='** Display Options **').pack()
        ttk.Separator(
            sidebar_2,         
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')
        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Demo dataset:').pack()
        ttk.OptionMenu(
            sidebar_2,
            self.demo_var_2,
            meta.DEMO_OPTION_2[0],
            *meta.DEMO_OPTION_2,
            command=lambda arg:self._demo_changed('2')
        ).pack()
        ttk.Separator(
            sidebar_2,
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')
        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Marker size:').pack()
        ttk.OptionMenu(
            sidebar_2,
            self.size_var,
            meta.SIZE_OPTION[1],
            *meta.SIZE_OPTION,
            command=lambda args: self._render_result(flag='2')
        ).pack()
        ttk.Separator(
            sidebar_2,
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')
        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Marker shape:').pack()
        ttk.OptionMenu(
            sidebar_2,
            self.shape_var,
            meta.SHAPE_OPTION[1],
            *meta.SHAPE_OPTION,
            command=lambda args: self._render_result(flag='2')
        ).pack()
        ttk.Separator(
            sidebar_2,
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')
        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Show label:').pack()
        ttk.OptionMenu(
            sidebar_2,
            self.label_var,
            meta.LABEL_TOGGLE[1],
            *meta.LABEL_TOGGLE,
            command=lambda args: self._render_result(flag='2')
        ).pack()
        ttk.Separator(
            sidebar_2,
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')

        # Widget for select or enter threshold. 
        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Threshold:').pack()
        self.threshold_box = ttk.Combobox(
            sidebar_2,
            width=4,
            values=meta.THRESHOLD_OPTION
        )
        self.threshold_box.pack()
        self.threshold_box.current(3)
        self.threshold_var = float(self.threshold_box.get())
        self.threshold_box.bind('<<ComboboxSelected>>', self._threshold_changed)
        ttk.Separator(
            sidebar_2,
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')

        # Widget for select or enter number of clusters. 
        ttk.Label(
            sidebar_2,
            background='gray80',
            text='Clusters:').pack()
        self.cluster_box = ttk.Combobox(
            sidebar_2,
            width=1,
            values=meta.CLUSTER_OPTION
        )
        self.cluster_box.pack()
        k = self._get_kwargs('2')['k']
        k = 0 if k == 2 else 1 if k == 4 else 2
        self.cluster_box.current(k)
        self.cluster_var = int(self.cluster_box.get())
        self.cluster_box.bind('<<ComboboxSelected>>', self._cluster_changed)
        ttk.Separator(
            sidebar_2,
            orient='horizontal').pack(ipady=meta.PADDING, fill='x')

        # Save and Exit buttons.
        ttk.Button(
            sidebar_2,
            text='Exit',
            command=lambda: self.destroy()
        ).pack(side='bottom')
        ttk.Button(
            sidebar_2,
            text='Save',
            command=lambda: self._save_output('2')
        ).pack(side='bottom')

        # Initialize canvas 2 for KMC.
        self._create_canvas('2')
        
        self.result_1 = self._get_result(
            '1', self._get_kwargs('1'))
        self.result_2 = self._get_result(
            '2', self._get_kwargs('2')['input_dir'])

        self._render_result(flag='1')
        self._render_result(flag='2')

        self.init_state = False  

    def _create_canvas(self, flag):
        """Creates new canvas."""

        if flag == '1':
            self.canvas_1 = tkinter.Canvas(
            self.tab_1,
            bg='gray80',
            width=self.canvas_width,
            height=self.canvas_height)

        if flag == '2':
            self.canvas_2 = tkinter.Canvas(
            self.tab_2,
            bg='gray80',
            width=self.canvas_width,
            height=self.canvas_height)

    def _get_kwargs(self, flag) -> dict:
        """Get directories of the input files."""

        if flag == '1':
            if self.demo_var_1.get() == 'dataset_2d':
                return meta.DATASET_2D
            if self.demo_var_1.get() == 'dataset_4d':
                return meta.DATASET_4D
            if self.demo_var_1.get() == 'dataset_8d':
                return meta.DATASET_8D
        if flag == '2':
            if self.demo_var_2.get() == 'input_2c_2d':
                return meta.DATASET_2C_2D
            if self.demo_var_2.get() == 'input_2c_4d':
                return meta.DATASET_2C_4D
            if self.demo_var_2.get() == 'input_4c_2d':
                return meta.DATASET_4C_2D
            if self.demo_var_2.get() == 'input_4c_4d':
                return meta.DATASET_4C_4D
    
    def _cluster_changed(self, *args):
        """Callback function for cluster option."""

        value = int(self.cluster_box.get())
        if value > 1:
            self.cluster_var = value
            self._pop_notification(f'Number of clusters set to: {value}')
            kwargs = self._get_kwargs('2')['input_dir']
            try:
                self.result_2 = self._get_result('2', kwargs)
            except ZeroDivisionError as e:
                self._pop_notification(f'{value} clusters cannot converge.')
                print(e)
                return
            self._render_result(flag='2')
        else:
            self._pop_notification(f'Invalid value {value} entered.')
            return

    def _threshold_changed(self, *args):
        """Callback function for threshold option."""

        value = float(self.threshold_box.get())
        if value > 0:
            self.threshold_var = value
            self._pop_notification(f'Threshold set to: {value}')
            kwargs = self._get_kwargs('2')['input_dir']
            self.result_2 = self._get_result('2', kwargs)
            self._render_result(flag='2')
        else:
            self._pop_notification(f'Invalid value {value} entered.')
            return

    def _demo_changed(self, flag):
        """Callback function for selecting demo datasets."""

        kwargs = self._get_kwargs(flag)
        if flag == '1':
            self.result_1 = self._get_result(flag, kwargs)
        if flag == '2':
            k = self._get_kwargs('2')['k']
            self.cluster_box.set(k)
            self.cluster_var = k
            kwargs = kwargs['input_dir']
            self.result_2 = self._get_result(flag, kwargs)
        self._render_result(flag)

    def _get_result(self, flag, kwargs, *args):
        """Retrieve result from the two algorithms."""

        if flag == '1':
            # Question 1
            # Nearest Neighbour Classifier
            result = util.nearest_neighbour_classifier(
                        output_dir=meta.OUTPUT_DIR,
                        **kwargs)
            return result

        elif flag == '2':
            # Question 2
            # K-Means Clustering
            result = util.k_means_clustering(
                        input_dir=kwargs,
                        output_dir=meta.OUTPUT_DIR,
                        threshold=self.threshold_var,
                        cluster=self.cluster_var)
            return result

    def _render_result(
        self,
        flag,
        *args):
        """Plot on the tkinter canvas."""

        if self.size_var.get() == 'Small':
            size = meta.S
        elif self.size_var.get() == 'Medium':
            size = meta.M
        elif self.size_var.get() == 'Large':
            size = meta.L

        if flag == '1':
            if self.init_state == False:
                self.canvas_1.destroy()
                self._create_canvas('1')

            params = util.get_conversion_params(
                self.result_1,
                self.canvas_width,
                self.canvas_height)
            
            if self.neighbour_var.get() == 'True':
                self._show_neighbour(
                    size,
                    params,
                    list(self._get_kwargs(flag).values())[0:2])
            
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
            
            self.canvas_1.pack(side='left')


        if flag == '2':
            if self.init_state == False:
                # self.canvas_2.delete('all')
                self.canvas_2.destroy()
                self._create_canvas('2')
            
            dataset = self.result_2

            params = util.get_conversion_params(
                dataset[0],
                self.canvas_width,
                self.canvas_height)

            colour_dict = {}
            affiliates = []
            for sample, centre in zip(dataset[0], dataset[1]):
                sample = util.convert_coordinates(sample, params)
                centre = util.convert_coordinates(centre, params)
                affiliates.append(centre)

                if centre not in colour_dict.keys():
                    colour_dict[centre] = util.get_new_colour(centre)

                util.draw_sample(
                    sample,
                    self.canvas_2,
                    size=size,
                    shape=self.shape_var.get(),
                    colour=colour_dict[centre])
                util.draw_line(sample, centre, self.canvas_2)
            
            centres = list(colour_dict.keys())
            legends = []
            for c in centres:
                count = sum([True for a in affiliates if a == c])
                legends.append(f'{count} samples')
            
            if self.label_var.get() == 'True':
                util.show_labels(centres, legends, self.canvas_2)
        
            self.canvas_2.pack(side='left')


    def _show_neighbour(self, size, params, neighbour):
        """Display neighbours as in different classes."""

        class_a = util.read_data_file(neighbour[0])
        class_b = util.read_data_file(neighbour[1])

        for sample in class_a:
            sample = util.convert_coordinates(sample, params)
            util.draw_sample(
                sample,
                self.canvas_1,
                size=size - 2,
                shape=self.shape_var.get(),
                colour='deep sky blue')
        
        for sample in class_b:
            sample = util.convert_coordinates(sample, params)
            util.draw_sample(
                sample,
                self.canvas_1,
                size=size - 2,
                shape=self.shape_var.get(),
                colour='tomato')
    
    def _pop_notification(self, msg):
        """Pop up notification window."""

        self.attributes('-alpha', 0.9)
        showinfo(title='Note',
                 message=msg)
        self.attributes('-alpha', 1)

    def _save_output(self, flag):
        """Saves results to output file."""

        if flag == '1':
            output = self.result_1
            tag = f"nnc-{self.demo_var_1.get()}"
        if flag == '2':
            output = []
            for i, a in zip(self.result_2[0], self.result_2[1]):
                output.append((i, a))
            tag = f"kmc-{self.demo_var_2.get()}"
        try:
            util.write_result_file(meta.OUTPUT_DIR, output, tag, meta.FILENAME)
        except FileExistsError as e:
            print(e)
            self._pop_notification(e)
            return
        except Exception:
            raise
        else:
            self._pop_notification(f"Output saved at: /{meta.OUTPUT_DIR}"\
                f"(algo)-(data)-{meta.FILENAME}")


if __name__ == "__main__":
    app = DataViewer()
    app.mainloop()