% Computer Vision and Image Analysis Lab Week 13

existing_GUIs = findall(0);
if length(existing_GUIs) > 1
    delete(existing_GUIs);
end
%% Set Dataset Folder Path
path = "..\assets\CUB_200_2011_Subset20classes\";
%% Read Image Names
% training set
trainingImageNames = readtable(fullfile(path, "train.txt"), ...  
    "ReadVariableNames", false); 
trainingImageNames.Properties.VariableNames = ["index", "imageName"];

% validation set
validationImageNames = readtable(fullfile(path, "validate.txt"), ...  
    "ReadVariableNames", false); 
validationImageNames.Properties.VariableNames = ["index", "imageName"]; 

% test set
testImageNames = readtable(fullfile(path, "test.txt"), ...  
    "ReadVariableNames", false); 
testImageNames.Properties.VariableNames = ["index", "imageName"]; 

%% Read Image Classes
classNames = readtable(fullfile(path, "classes.txt"), ... 
    "ReadVariableNames", false); 
classNames.Properties.VariableNames = ["index", "className"]; 
 
imageClassLabels = readtable(fullfile(path, "image_class_labels.txt"), ... 
    "ReadVariableNames", false); 
imageClassLabels.Properties.VariableNames = ["index", "classLabel"]; 

%% Read Bounding Box Info
% data structure: image index, x-coordinate top-left corner, y-coordinate top-left corner, width, height.
boundingBoxes = readtable(path + "bounding_boxes.txt", ... 
    'ReadVariableNames', false);
boundingBoxes.Properties.VariableNames = {'index', 'x', 'y', 'w', 'h'};

% Map bounding box information to the respective image file name
train_image_box_map = returnMapping(trainingImageNames, boundingBoxes);
validate_image_box_map = returnMapping(validationImageNames, boundingBoxes);
test_image_box_map = returnMapping(testImageNames, boundingBoxes);
%% Create Datatores
% training set
trainingImageDS = imageDatastore(fullfile(path, "images", ... 
    trainingImageNames.imageName), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 
trainingImageDS.ReadFcn = @(filename) readImagesIntoDatastoreBB(filename, ...
    train_image_box_map);
trainingLabels = arrayDatastore(trainingImageDS.Labels);

% validation set
validationImageDS = imageDatastore(fullfile(path, "images", ... 
    validationImageNames.imageName), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 
validationImageDS.ReadFcn = @(filename) readImagesIntoDatastoreBB(filename, ...
    validate_image_box_map);
validationLabels = arrayDatastore(validationImageDS.Labels);

% test set
testImageDS = imageDatastore(fullfile(path, "images", ... 
    testImageNames.imageName), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 
testImageDS.ReadFcn = @(filename) readImagesIntoDatastoreBB(filename, ...
    test_image_box_map);
testLabels = arrayDatastore(testImageDS.Labels);

%% Combine Datastores and Labels
trainingCDS = combine(trainingImageDS, trainingLabels);
validationCDS = combine(validationImageDS, validationLabels);
testCDS = combine(testImageDS, testLabels);

%% Transform the Image into Target Size
% targetSize = [280, 280];
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

%% Display a Sample Image
figure
imshow(trainingCDS.read{1});
title("Resized Sample Image")

%% Build Simple CNN Classifier
% network architecture
layers = [
%     imageInputLayer([280 280 3])
    imageInputLayer([128 128 3])
    
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
    
    fullyConnectedLayer(20)
    softmaxLayer
    classificationLayer];

% setup GPU
% disp(gpuDevice(1))
device = gpuDevice(1);
reset(device);  % Clear previous values that might still be on the GPU

% training options
options = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.001, ...
    'MiniBatchSize', 20, ...
    'MaxEpochs', 10, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', validationCDS, ...
    'VerboseFrequency', 1, ...
    'Verbose', true, ...
    'Plots', 'training-progress');

%% Train the Network
net = trainNetwork(trainingCDS, layers, options);

%% Display Test Results
YPred = classify(net, testCDS);
YTest = testImageDS.Labels;

accuracy = sum(YPred == YTest)/numel(YTest);

[m, order] = confusionmat(YTest, YPred);
figure("Name", "Test Set Result");
confusionchart(m, order, ...
    'ColumnSummary','column-normalized', ...
    'RowSummary','row-normalized');
title("Overall Accuracy: "+ string(round(accuracy*100, 1)) +"%");
