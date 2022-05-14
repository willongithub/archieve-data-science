%% Computer Vision Concepts Implementation - Assignment 1 (8890 CVIA PG)
% Author: Data Man
% Date: 13/05/2022

%% Dataset Preparation
% Set path for dataset folder
% path = "assets\CUB_200_2011\";
path = "..\assets\CUB_200_2011_Subset20classes\";

% % Read image classes and labels
% classNames = readtable(fullfile(path, "classes.txt"), ... 
%     "ReadVariableNames", false); 
% classNames.Properties.VariableNames = ["index", "className"]; 
 
labels = readtable(fullfile(path, "image_class_labels.txt"), ... 
    "ReadVariableNames", false); 
labels.Properties.VariableNames = ["index", "label"]; 

% Read image file paths
images = readtable(fullfile(path, "images.txt"), ...  
    "ReadVariableNames", false); 
images.Properties.VariableNames = ["index", "file"];

% Read bounding box info
bboxes = readtable(path + "bounding_boxes.txt", ... 
    'ReadVariableNames', false);
bboxes.Properties.VariableNames = {'index', 'x', 'y', 'w', 'h'};

imds = imageDatastore(fullfile(path, "images", images.file));
imds = shuffle(imds);
bbds = arrayDatastore(bboxes(:, 2:5));
bbds = shuffle(bbds);

data = combine(imds, bbds);
data = transform(data, @cropImages);

%%
a = readall(data);
%% 
% Split dataset
dataSize = height(dataFiles);

rng default;  % for reproducibility
indexAll = randperm(dataSize);  % shuffled index number

indexTrain = indexAll(1:floor(dataSize*0.6));
indexValidate = indexAll(floor(dataSize*0.6) + 1:floor(dataSize*0.8));
indexTest = indexAll(floor(dataSize*0.8) + 1:end);

% Create image datastores
trainingDS = imageDatastore(fullfile(path, "images", ... 
    dataFiles(indexTrain, :).file), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 

validationDS = imageDatastore(fullfile(path, "images", ... 
    dataFiles(indexValidate, :).file), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 

testDS = imageDatastore(fullfile(path, "images", ... 
    dataFiles(indexTest, :).file), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 

% % Combine datastores and labels
% trainingCDS = combine(trainingDS, arrayDatastore(trainingDS.Labels));
% validationCDS = combine(validationDS, arrayDatastore(validationDS.Labels));
% testCDS = combine(testDS, arrayDatastore(testDS.Labels));

% Combine datastores and bounding box
trainingCDS = combine(trainingDS, arrayDatastore(dataFiles(indexTrain, 3:6)));
validationCDS = combine(validationDS, arrayDatastore(dataFiles(indexValidate, 3:6)));
testCDS = combine(testDS, arrayDatastore(dataFiles(indexTest, 3:6)));

% Resize and crop input image
% targetSize = [256, 256];
targetSize = [128, 128];

% Whole image
trainingWholeCDS = transform(trainingCDS, ... 
    @(x) preprocessData(x, targetSize)); 

validationWholeCDS = transform(validationCDS, ... 
    @(x) preprocessData(x, targetSize)); 

testWholeCDS = transform(testCDS, ... 
    @(x) preprocessData(x, targetSize));

% Image within bounding box only
% trainingBox = arrayDatastore(dataFiles(indexTrain, 3:6));
trainingBoxCDS = transform(trainingCDS, trainingBox, @(img, box) ... 
    preprocessData(img, targetSize, box)); 

% validationBox = arrayDatastore(dataFiles(indexValidate, 3:6));
validationBoxCDS = transform(validationCDS, validationBox, @(img, box) ... 
    preprocessData(img, targetSize, box)); 

% testBox = arrayDatastore(dataFiles(indexTest, 3:6));
testBoxCDS = transform(testCDS, testBox, @(img, box) ... 
    preprocessData(img, targetSize, box)).UnderlyingDatastores{1, 1}; 

% Combine datastores and labels
trainingWholeCDS = combine(trainingWholeCDS, arrayDatastore(trainingDS.Labels));
validationWholeCDS = combine(validationWholeCDS, arrayDatastore(validationDS.Labels));
testWholeCDS = combine(testWholeCDS, arrayDatastore(testDS.Labels));

%% Task 1: Classic Machine Learning Approach

%% Task 2: Deep Learning Approach
% Setup GPU
if (gpuDeviceCount() > 0)
    device = gpuDevice(1);
    reset(device);
end

% Network layers
layers = [
    imageInputLayer([targetSize 3])
    
    convolution2dLayer(3, 8, 'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 16, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3, 64, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3, 128, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(200)
    softmaxLayer
    classificationLayer];

%% Experiment 1
% Training options
options = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.001, ...
    'MiniBatchSize', 20, ...
    'MaxEpochs', 10, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', validationWholeCDS, ...
    'VerboseFrequency', 1, ...
    'Verbose', true, ...
    'Plots', 'training-progress');

% Train the model
model = trainNetwork(trainingCDS, layers, options);

% Display test results
YPred = classify(model, testCDS);
YTest = testDS.Labels;

accuracy = sum(YPred == YTest)/numel(YTest)

% [m, order] = confusionmat(YTest, YPred);
% figure("Name", "Test Set Result");
% confusionchart(m, order, ...
%     'ColumnSummary','column-normalized', ...
%     'RowSummary','row-normalized');
% title("Overall Accuracy: "+ string(round(accuracy*100, 1)) +"%");

%% Experiment 2
figure
imshow(trainingWholeCDS.read{1});
title("Resized Sample Image")
%% Experiment 3
% Training options
options = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.001, ...
    'MiniBatchSize', 20, ...
    'MaxEpochs', 10, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', validationBoxCDS, ...
    'VerboseFrequency', 1, ...
    'Verbose', true, ...
    'Plots', 'training-progress');

% Train the model
model = trainNetwork(trainingBoxCDS, layers, options);

% Display test results
YPred = classify(model, testBoxCDS);
YTest = testDS.Labels;

accuracy = sum(YPred == YTest)/numel(YTest)

% [m, order] = confusionmat(YTest, YPred);
% figure("Name", "Test Set Result");
% confusionchart(m, order, ...
%     'ColumnSummary','column-normalized', ...
%     'RowSummary','row-normalized');
% title("Overall Accuracy: "+ string(round(accuracy*100, 1)) +"%");

%% Experiment 4

%% Experiment 5

%% Helper functions
% function output = preprocessData(input, targetSize, crop)
function output = preprocessData(input, targetSize, varargin)

    if nargin == 3
        x = varargin{1}(1, 1);
        y = varargin{1}(1, 2);
        w = varargin{1}(1, 3);
        h = varargin{1}(1, 4);
        output{1} = imcrop(input{1}, [x, y, w, h]);
    end

    output{1} = imresize(input{1}, targetSize(1:2));
    output{2} = input{2};
    
    if size(input{1}, 3) < 3
        output{1} = cat(3, output{1}, output{1}, output{1});
    end
end

function out = cropImages(in)
    x = table2array(in{2}(1, 1));
    disp(in{2}(1, 1));
    y = table2array(in{2}(1, 2));
    w = table2array(in{2}(1, 3));
    h = table2array(in{2}(1, 4));

    if size(in{1}, 3) < 3
        out = cat(3, in{1}, in{1}, in{1});
    else
        out = in{1};
    end

    if x > size(out, 2) || y > size(out, 1)
        disp("error")
        disp([x, y, w, h])
    else
        out = imcrop(out, [x, y, w, h]);
    end
end