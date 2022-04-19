% Example of Creating a Simple Convolutional Neural Network (CNN) model
% for the MNIST Handwritten Digits dataset

close all;
clear all;
% clc;

%% Load training data
% Define file names
trainImageFilename = 'assets/train-images.idx3-ubyte';
trainLabelFilename = 'assets/train-labels.idx1-ubyte';

% Process files and store training image and label information
[Xtrain,LabelTrain] = processMNISTdata_for_CNN(trainImageFilename,trainLabelFilename);

%% Load the test data
testImageFilename = 'assets/t10k-images.idx3-ubyte';
testLabelFilename = 'assets/t10k-labels.idx1-ubyte';
[Xtest,LabelTest] = processMNISTdata_for_CNN(testImageFilename,testLabelFilename);

%% Define CNN Model
% Deep learning models contain a mix of convolutional, batch normalisation,
% ReLU, and pooling layers... Here's an example.
layers = [
    imageInputLayer([28 28 1])
	
    convolution2dLayer(3,16,'Padding',1)
    batchNormalizationLayer
    reluLayer
	
    maxPooling2dLayer(2,'Stride',2)
	
    convolution2dLayer(3,32,'Padding',1)
    batchNormalizationLayer
    reluLayer
	
    maxPooling2dLayer(2,'Stride',2)
	
    convolution2dLayer(3,64,'Padding',1)
    batchNormalizationLayer
    reluLayer
	
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];

%% Train the CNN model (aka training the network)
% Define training parameters
miniBatchSize = 1000;
options = trainingOptions( 'sgdm',...
    'MaxEpochs', 15,...
    'InitialLearnRate',0.01,...
    'MiniBatchSize', miniBatchSize,...
    'Plots', 'training-progress');

% Train the CNN
net = trainNetwork(Xtrain, LabelTrain, layers, options);

%% Test the accuracy of the trained model on the test data
predLabelsTest = net.classify(Xtest);
accuracy = sum(predLabelsTest == LabelTest) / numel(LabelTest);

% Show confusion matrix in figure
[m, order] = confusionmat(LabelTest, predLabelsTest);
figure(1);
cm = confusionchart(m, order);

%% Test on a sample image
% Set i to the index of the image choosen
i = 2;
curimg = Xtest(:, :, i);
% We will copy and resize the image for demonstration purposes 
figure(2);
imshow(imresize(curimg,10), [0 255]);
% Grab the ground truth and compare to our prediction, if correct the
% predicted label should be the same as the annotated one. 
groundTruth = LabelTest(i);
predLabel = net.classify(curimg);
disp(append('Predicted label = ', string(predLabel),' vs. Ground Truth = ', string(groundTruth))) 
