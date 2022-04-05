% MNIST Handwritten Digits Database - Example of training linear classifier
% Adapted from https://au.mathworks.com/help/stats/workflow-for-feature-extraction.html

close all;
clear all;
clc;

% Load training data
trainImageFilename = 'assets/train-images.idx3-ubyte';
trainLabelFilename = 'assets/train-labels.idx1-ubyte';

% Process files
[Xtrain,LabelTrain] = processMNISTdata(trainImageFilename,trainLabelFilename);

% View a few example images
rng('default') % For reproducibility
numrows = size(Xtrain,1);
ims = randi(numrows,4,1);
imgs = Xtrain(ims,:);
for i = 1:4
    pp{i} = reshape(imgs(i,:),28,28);
end
ppf = [pp{1},pp{2};pp{3},pp{4}];
imshow(ppf);

% Choose a feature dimension 
q = 100;

%% Feature Extraction
% There are two feature extraction functions, sparsefilt and rica. Begin 
% with the sparsefilt function. Set the number of iterations to 10 so that 
% the extraction does not take too long.
% Note: You may get a warning that the solver LBFGS was not able to
% cconverge to a solution. We can increase the iteration limit but it is
% fine for now.
Mdl = sparsefilt(Xtrain,q,'IterationLimit',10);

%% Create Classifier
% Transform data into new representation
NewX = transform(Mdl,Xtrain);

% Train a linear classifier
% Note 1: The function fitcecoc fits multi-class models to support vector
% machines or other classifiers.
% Note 2: The code will run 40 iterations to optimise the model fit.
t = templateLinear('Solver','lbfgs');
options = struct('UseParallel',true); % This ensures the GPU use!
Cmdl = fitcecoc(NewX,LabelTrain,'Learners',t, ...
    'OptimizeHyperparameters',{'Lambda'}, ...
    'HyperparameterOptimizationOptions',options);

%% Evaluate Classifier
% Load the test data
testImageFilename = 'assets/t10k-images.idx3-ubyte';
testLabelFilename = 'assets/t10k-labels.idx1-ubyte';
[Xtest,LabelTest] = processMNISTdata(testImageFilename,testLabelFilename);

% Calculate the classification loss when applying the trained model to the
% test data
TestX = transform(Mdl,Xtest);
Loss = loss(Cmdl,TestX,LabelTest)

% Compare to the classification loss trained on the original data 
% (i.e. not the new representation we were using)
Omdl = fitcecoc(Xtrain,LabelTrain,'Learners',t, ...
    'OptimizeHyperparameters',{'Lambda'}, ...
    'HyperparameterOptimizationOptions',options);
Losso = loss(Omdl,Xtest,LabelTest)
