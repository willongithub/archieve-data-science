% Computer Vision and Image Analysis Lab Week 10

%% Load the ground truth data from Image Labeler session
data = load('assets/birdGroundTruth.mat');

%% Create training data
trainingData = data.gTruth;
% trainingData.imageFilename = fullfile(toolboxdir('vision'),'visiondata', ...
%     trainingData.imageFilename);
% 
% % shuffle the data
% rng(0);
% shuffledIdx = randperm(height(trainingData));
% trainingData = trainingData(shuffledIdx,:);

%% Create data stora
% imds = imageDatastore(trainingData.imageFilename);
% blds = boxLabelDatastore(trainingData(:,2:end));
% 
% ds = combine(imds, blds);

lgraph = layerGraph(data.detector.Network);

%% Config the training options
options = trainingOptions('sgdm', ...
      'MiniBatchSize', 1, ...
      'InitialLearnRate', 1e-3, ...
      'MaxEpochs', 7, ...
      'VerboseFrequency', 200, ...
      'CheckpointPath', tempdir);

%% Train the detector
detector = trainFasterRCNNObjectDetector(ds, lgraph, options, ...
        'NegativeOverlapRange',[0 0.3], ...
        'PositiveOverlapRange',[0.6 1]);