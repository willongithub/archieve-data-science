% Computer Vision and Image Analysis Lab Week 6

%% 1
% Load image
rcImg1 = imread("assets/robocup_image1.jpeg");
figure(1);
subplot(2, 4, 1);
imshow(rcImg1);
title('Original Image');

% 4
% Ball template
temp = rcImg1(406:451, 95:140, :);
subplot(2, 4, 2);
imshow(temp);
title('Template Image');

rcGsImg1 = rgb2gray(rcImg1);
tempGs = rcGsImg(406:451, 95:140);
subplot(2, 4, 5);
imshow(rcGsImg1);
title('Grayscale Image');
subplot(2, 4, 6);
imshow(tempGs);
title('Template Grayscale Image');

%% 6
% Use SAD values 
locateTarget(rcGsImg, tempGs, "SAD");

%% 7
rcImg2 = imread("assets/robocup_image2.jpeg");
figure(2);
subplot(2, 4, 1);
imshow(rcImg2);
title('Original Image 2');

rcGsImg2 = rgb2gray(rcImg2);
subplot(2, 4, 5);
imshow(rcGsImg2);
title('Grayscale Image 2');
subplot(2, 4, 6);
imshow(tempGs);
title('Template Grayscale Image');

%%
locateTarget(rcGsImg2, tempGs, "SAD");

%% 8
% Use SAD values 
locateTarget(rcGsImg, tempGs, "SSD");

%% 10
% @computeNCC.m

%% 11
% Find ball in image 1
computeNCC(rcGsImg1, tempGs);

%%
% Find ball in image 2
computeNCC(rcGsImg2, tempGs);


%% 13 ~ 16 Digit Classification Using HOG Features
% Load training and test data using |imageDatastore|.
syntheticDir   = fullfile(toolboxdir('vision'),'visiondata','digits','synthetic');
handwrittenDir = fullfile(toolboxdir('vision'),'visiondata','digits','handwritten');

% |imageDatastore| recursively scans the directory tree containing the
% images. Folder names are automatically used as labels for each image.
trainingSet = imageDatastore(syntheticDir,'IncludeSubfolders',true,'LabelSource','foldernames');
testSet     = imageDatastore(handwrittenDir,'IncludeSubfolders',true,'LabelSource','foldernames');
%%
countEachLabel(trainingSet)
%%
countEachLabel(testSet)
%%
figure;

subplot(2,3,1);
imshow(trainingSet.Files{111});

subplot(2,3,2);
imshow(trainingSet.Files{333});

subplot(2,3,3);
imshow(trainingSet.Files{777});

subplot(2,3,4);
imshow(testSet.Files{11});

subplot(2,3,5);
imshow(testSet.Files{33});

subplot(2,3,6);
imshow(testSet.Files{99});

%% Show pre-processing results
exTestImage = readimage(testSet,33);
processedImage = imbinarize(im2gray(exTestImage));

figure;

subplot(1,2,1)
imshow(exTestImage)

subplot(1,2,2)
imshow(processedImage)

%% Using HOG Features
img = readimage(trainingSet, 206);

% Extract HOG features and HOG visualization
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);

% Show the original image
figure; 
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
%%
cellSize = [4 4];
hogFeatureSize = length(hog_4x4);

%% Digit Classification Using HOG Features
% Loop over the trainingSet and extract HOG features from each image. A
% similar procedure will be used to extract features from the testSet.

numImages = numel(trainingSet.Files);
trainingFeatures = zeros(numImages,hogFeatureSize,'single');

for i = 1:numImages
    img = readimage(trainingSet,i);
    
    img = im2gray(img);
    
    % Apply pre-processing steps
    img = imbinarize(img);
    
    trainingFeatures(i, :) = extractHOGFeatures(img,'CellSize',cellSize);  
end

% Get labels for each image.
trainingLabels = trainingSet.Labels;
%%
% fitcecoc uses SVM learners and a 'One-vs-One' encoding scheme.
classifier = fitcecoc(trainingFeatures, trainingLabels);

%% Evaluate the Digit Classifier
% Extract HOG features from the test set. The procedure is similar to what
% was shown earlier and is encapsulated as a helper function for brevity.
[testFeatures, testLabels] = helperExtractHOGFeaturesFromImageSet(testSet, hogFeatureSize, cellSize);

% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

helperDisplayConfusionMatrix(confMat)
