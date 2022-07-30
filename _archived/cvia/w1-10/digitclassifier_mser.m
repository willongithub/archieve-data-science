% Week 7 MNIST Handwritten Digits classification using MSER

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
img = im2gray(readimage(trainingSet, 206));

% Extract MSER features
mser = detectMSERFeatures(img);
[~, points] = extractFeatures(img, mser, "Upright", true);

% Show the original image
figure(3);
imshow(img);

% Set feature size
size = 6;
max = 10;

% Visualize the MSER features
hold on;
plot(points.selectStrongest(max),"ShowOrientation",true);
hold off;

%%
numImages = numel(trainingSet.Files);
FeatureSize = size*max;
trainingFeatures = zeros(numImages,FeatureSize,'single');

for i = 1:numImages
    img = readimage(trainingSet,i);
    
    img = im2gray(img); % ensure images are grayscale
    
    % Apply pre-processing steps - binarize images
    img = imbinarize(img);

    % Extract features.
    mser = detectMSERFeatures(img);
    [~, points] = extractFeatures(img, mser);
    points = points.selectStrongest(max);

    if ~isempty(points) 
        for p = 0:length(points)-1  
            l = points(p+1).Location; 
            trainingFeatures(i, (p*size)+1) = l(1);
            trainingFeatures(i, (p*size)+2) = l(2);
            trainingFeatures(i, (p*size)+3) = points(p+1).Scale;  
            trainingFeatures(i, (p*size)+4) = points(p+1).SignOfLaplacian;
            trainingFeatures(i, (p*size)+5) = points(p+1).Orientation;
            trainingFeatures(i, (p*size)+6) = points(p+1).Metric;
        end 
    end
    
end

% Get labels for each image.
trainingLabels = trainingSet.Labels;

% Next, train a classifier using the extracted features
% fitcecoc uses multiple SVM learners and a 'One-vs-One' encoding scheme.
classifier = fitcecoc(trainingFeatures, trainingLabels);

%%
% Evaluate (test) the classifier on data that was not used during training

[testFeatures, testLabels] = ...
    helperExtractMSERFeaturesFromImageSet(testSet, size, max);

% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);
helperDisplayConfusionMatrix(confMat)
figure(4);  % Display confusion matrix in figure
confusionchart(confMat);