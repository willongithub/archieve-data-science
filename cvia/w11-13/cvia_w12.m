% Computer Vision and Image Analysis Lab Week 12

%% Read Image Names
% training set
trainingImageNames = readtable("..\assets\train.txt", ...  
    "ReadVariableNames", false); 
trainingImageNames.Properties.VariableNames = ["index", "imageName"];

% validation set
validationImageNames = readtable("..\assets\validate.txt", ...  
    "ReadVariableNames", false); 
validationImageNames.Properties.VariableNames = ["index", "imageName"]; 

% test set
testImageNames = readtable("..\assets\test.txt", ...  
    "ReadVariableNames", false); 
testImageNames.Properties.VariableNames = ["index", "imageName"]; 

%% Read Image Classes
classNames = readtable("..\assets\CUB_200_2011_Subset20classes\classes.txt", ... 
    "ReadVariableNames", false); 
classNames.Properties.VariableNames = ["index", "className"]; 
 
imageClassLabels = readtable("..\assets\CUB_200_2011_Subset20classes\image_class_labels.txt", ... 
    "ReadVariableNames", false); 
imageClassLabels.Properties.VariableNames = ["index", "classLabel"]; 

%% Combine Info
% training set
trainingImageDS = imageDatastore(fullfile("..\assets\CUB_200_2011_Subset20classes\", "images", ... 
    trainingImageNames.imageName), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 
trainingLabels = arrayDatastore(trainingImageDS.Labels);

% validation set
validationImageDS = imageDatastore(fullfile("..\assets\CUB_200_2011_Subset20classes\", "images", ... 
    validationImageNames.imageName), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 
validationLabels = arrayDatastore(validationImageDS.Labels);

% test set
testImageDS = imageDatastore(fullfile("..\assets\CUB_200_2011_Subset20classes\", "images", ... 
    testImageNames.imageName), "labelSource", "foldernames", ... 
    "FileExtensions", ".jpg"); 
testLabels = arrayDatastore(testImageDS.Labels);

%% Transform the Image into Target Size
targetSize = [280, 280];  

% training set
trainingImageDS = transform(trainingImageDS, ... 
    @(x) imresize(x, targetSize)); 
trainingCDS = combine(trainingImageDS, trainingLabels);

% validation set
validationImageDS = transform(validationImageDS, ... 
    @(x) imresize(x, targetSize)); 
validationCDS = combine(validationImageDS, validationLabels);

% test set 
testImageDS = transform(testImageDS, ... 
    @(x) imresize(x, targetSize));
testCDS = combine(testImageDS, testLabels);

%% Display a Sample Image
figure(1);
imshow(trainingCDS.read{1});
title("Resized Sample Image")

%% Build Simple CNN Classifier
% network architecture
layers = [
    imageInputLayer([280 280 3])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(20)
    softmaxLayer
    classificationLayer];

% setup GPU
disp(gpuDevice(1))
device = gpuDevice(1);
reset(device);  % Clear previous values that might still be on the GPU

% training options
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.001, ...
    'MiniBatchSize', 20, ...
    'MaxEpochs',10, ...
    'Shuffle','every-epoch', ...
    'ValidationData',validationCDS, ...
    'VerboseFrequency', 1, ...
    'Verbose',true, ...
    'Plots','training-progress');

%% Train the Network
net = trainNetwork(trainingCDS, layers, options);

%% Display Result
YPred = classify(net,validationImageDS);
YValidation = validationImageDS.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)

figure
cm = confusionchart(YValidation,YPred);