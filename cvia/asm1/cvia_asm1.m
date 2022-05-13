%% Computer Vision Concepts Implementation - Assignment 1 (8890 CVIA PG)
% Author: Data Man
% Date: 13/05/2022

%% Dataset Preparation
% Set path for dataset folder
path = "assets\CUB_200_2011\";

% Read image classes and labels
classNames = readtable(fullfile(path, "classes.txt"), ... 
    "ReadVariableNames", false); 
classNames.Properties.VariableNames = ["index", "className"]; 
 
imageClassLabels = readtable(fullfile(path, "image_class_labels.txt"), ... 
    "ReadVariableNames", false); 
imageClassLabels.Properties.VariableNames = ["index", "classLabel"]; 

% Read bounding box info
boundingBoxes = readtable(path + "bounding_boxes.txt", ... 
    'ReadVariableNames', false);
boundingBoxes.Properties.VariableNames = {'index', 'x', 'y', 'w', 'h'};

% Read image file paths
path_all = readtable(fullfile(path, "images.txt"), ...  
    "ReadVariableNames", false); 
path_all.Properties.VariableNames = ["index", "image_path"];

% Split dataset
data_size = height(path_all);

rng default;  % for reproducibility
index_all = randperm(data_size);  % shuffled index number

index_train = index_all(1:floor(data_size*0.6));
index_validate = index_all(floor(data_size*0.6) + 1:floor(data_size*0.8));
index_test = index_all(floor(data_size*0.8) + 1:end);

% 

%% Task 1: Classic Machine Learning Approach

%% Task 2: Deep Learning Approach

%% Experiment 1

%% Experiment 2

%% Experiment 3

%% Experiment 4

%% Experiment 5
