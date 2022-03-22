% Week 7 Base script for MNIST Handwritten Digits classification using
% different locally invariant image features.
% Based on openExample('vision/HOGDigitClassificationExample')
%
% Author: Roland Goecke
% Date created: 21/03/22

close all;
clear all;
clc;

% Load training and test data using |imageDatastore|. This (toy) example 
% uses synthetically generated samples for simplicity.
syntheticDir   = fullfile(toolboxdir('vision'),'visiondata','digits','synthetic');
handwrittenDir = fullfile(toolboxdir('vision'),'visiondata','digits','handwritten');

% |imageDatastore| recursively scans the directory tree containing the
% images. Folder names are automatically used as labels for each image.
trainingSet = imageDatastore(syntheticDir,'IncludeSubfolders',true,'LabelSource','foldernames');
testSet     = imageDatastore(handwrittenDir,'IncludeSubfolders',true,'LabelSource','foldernames');

% Use countEachLabel to tabulate the number of images associated with each 
% label. In this example, the training set consists of 101 images for each 
% of the 10 digits. The test set consists of 12 images per digit.
countEachLabel(trainingSet)
countEachLabel(testSet)

% Show a few of the training and test images
figure(1);
subplot(2,3,1);
imshow(trainingSet.Files{102});
subplot(2,3,2);
imshow(trainingSet.Files{304});
subplot(2,3,3);
imshow(trainingSet.Files{809});
subplot(2,3,4);
imshow(testSet.Files{13});
subplot(2,3,5);
imshow(testSet.Files{37});
subplot(2,3,6);
imshow(testSet.Files{97});

% Prior to training and testing a classifier, a pre-processing step is 
% applied to remove noise artifacts introduced while collecting the image 
% samples. This provides better feature vectors for training the classifier.
exTestImage = readimage(testSet,37);
processedImage = imbinarize(im2gray(exTestImage));

figure(2);
subplot(1,2,1)
imshow(exTestImage)
subplot(1,2,2)
imshow(processedImage)

% Using HOG features
img = readimage(trainingSet, 206);

% Extract HOG features and HOG visualization
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);

% Show the original image
figure(3);
subplot(2,3,1:3); imshow(img);

% Visualize the HOG features
subplot(2,3,4);  
plot(vis2x2); 
title({'CellSize = [2 2]'; ['Length = ' num2str(length(hog_2x2))]});
subplot(2,3,5);
plot(vis4x4); 
title({'CellSize = [4 4]'; ['Length = ' num2str(length(hog_4x4))]});
subplot(2,3,6);
plot(vis8x8); 
title({'CellSize = [8 8]'; ['Length = ' num2str(length(hog_8x8))]});

% Select best cell size; 2x2 too little information, 8x8 too much info
cellSize = [4 4];
hogFeatureSize = length(hog_4x4);

% Train a Digit Classifier:
% Digit classification is a multiclass classification problem, where you 
% have to classify an image into one out of the ten possible digit classes. 
% In this example, the fitcecoc function from the Statistics and Machine 
% Learning Toolbox is used to create a multiclass classifier using binary 
% Support Vector Machines (SVMs).

% Start by extracting HOG features from the training set. These features 
% will be used to train the classifier.
% Loop over the trainingSet and extract HOG features from each image. A
% similar procedure will be used to extract features from the testSet.
numImages = numel(trainingSet.Files);
trainingFeatures = zeros(numImages,hogFeatureSize,'single');
for i = 1:numImages
    img = readimage(trainingSet,i);
    
    img = im2gray(img); % ensure images are grayscale
    
    % Apply pre-processing steps - binarize images
    img = imbinarize(img);
    
    trainingFeatures(i, :) = extractHOGFeatures(img,'CellSize',cellSize);  
end

% Get labels for each image.
trainingLabels = trainingSet.Labels;

% Next, train a classifier using the extracted features
% fitcecoc uses multiple SVM learners and a 'One-vs-One' encoding scheme.
classifier = fitcecoc(trainingFeatures, trainingLabels);

%
% Evaluate (test) the classifier on data that was not used during training
%

% Extract HOG features from the test set. The procedure is similar to what
% was shown earlier and is encapsulated as a helper function for brevity.
[testFeatures, testLabels] = ...
    helperExtractHOGFeaturesFromImageSet(testSet, hogFeatureSize, cellSize);

% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);
helperDisplayConfusionMatrix(confMat)
figure(4);  % Display confusion matrix in figure
confusionchart(confMat);