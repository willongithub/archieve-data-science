% Week 7 MNIST Handwritten Digits classification using SIFT

%%
syntheticDir   = fullfile(toolboxdir('vision'),'visiondata','digits','synthetic');
handwrittenDir = fullfile(toolboxdir('vision'),'visiondata','digits','handwritten');

trainingSet = imageDatastore(syntheticDir,'IncludeSubfolders',true,'LabelSource','foldernames');
testSet     = imageDatastore(handwrittenDir,'IncludeSubfolders',true,'LabelSource','foldernames');

%%
countEachLabel(trainingSet)
countEachLabel(testSet)

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

%%
% Remove noise
exTestImage = readimage(testSet,37);
processedImage = imbinarize(im2gray(exTestImage));

figure(2);
subplot(1,2,1)
imshow(exTestImage)
subplot(1,2,2)
imshow(processedImage)

%%
% Using SIFT features
img = im2gray(readimage(trainingSet, 206));

% Extract SIFT features
sift = detectSIFTFeatures(img);
[features, ~] = extractFeatures(img, sift);

% Show the original image
figure(3);
subplot(2,3,1:3); imshow(img);

% Visualize the SIFT features
hold on;
plot(sift.selectStrongest(50));
hold off;

%%
numImages = numel(trainingSet.Files);
dim = size(features);
trainingFeatures = zeros(numImages,dim(1),dim(2));
for i = 1:numImages
    img = readimage(trainingSet,i);
    
    img = im2gray(img); % ensure images are grayscale
    
    % Apply pre-processing steps - binarize images
    img = imbinarize(img);

    % Extract features.
    sift = detectSIFTFeatures(img);
    [features, ~] = extractFeatures(img, sift);
    
    trainingFeatures(i, :) = features;
end

% Get labels for each image.
trainingLabels = trainingSet.Labels;

% Next, train a classifier using the extracted features
% fitcecoc uses multiple SVM learners and a 'One-vs-One' encoding scheme.
classifier = fitcecoc(trainingFeatures, trainingLabels);

%%
%
% Evaluate (test) the classifier on data that was not used during training
%

[testFeatures, testLabels] = ...
    helperExtractSIFTFeaturesFromImageSet(testSet, hogFeatureSize, cellSize);

% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);
helperDisplayConfusionMatrix(confMat)
figure(4);  % Display confusion matrix in figure
confusionchart(confMat);