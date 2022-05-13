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
imageFiles = readtable(fullfile(path, "images.txt"), ...  
    "ReadVariableNames", false); 
imageFiles.Properties.VariableNames = ["index", "file"];

% Combine image and bounding box info
dataFiles = join(imageFiles, boundingBoxes);

% Split dataset
dataSize = height(dataFiles);

rng default;  % for reproducibility
indexAll = randperm(dataSize);  % shuffled index number

indexTrain = indexAll(1:floor(dataSize*0.6));
indexValidate = indexAll(floor(dataSize*0.6) + 1:floor(dataSize*0.8));
indexTest = indexAll(floor(dataSize*0.8) + 1:end);

% Create datastores
trainingDS = imageDatastore(fullfile(path, "images", ... 
    dataFiles(indexTrain, :).file), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 

validationDS = imageDatastore(fullfile(path, "images", ... 
    dataFiles(indexValidate, :).file), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 

testDS = imageDatastore(fullfile(path, "images", ... 
    dataFiles(indexTest, :).file), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 

% Resize and crop
% targetSize = [256, 256];
targetSize = [128, 128];

% training set
trainingCDS = transform(trainingCDS, ... 
    @(x) preprocessData(x, targetSize)); 

% validation set
validationCDS = transform(validationCDS, ... 
    @(x) preprocessData(x, targetSize)); 

% test set 
testCDS = transform(testCDS, ... 
    @(x) preprocessData(x, targetSize));

% Combine datastores and labels
trainingCDS = combine(trainingImageDS, trainingLabels);
validationCDS = combine(validationImageDS, validationLabels);
testCDS = combine(testImageDS, testLabels);

%% Task 1: Classic Machine Learning Approach

%% Task 2: Deep Learning Approach

%% Experiment 1

%% Experiment 2

%% Experiment 3

%% Experiment 4

%% Experiment 5
