% Example of fasterRCNN model based classifier for a subset of the
% BirdCameraTrap data containing only four classes:
% 1) Wedge Tailed Eagle
% 2) Dingo
% 3) White-necked Heron
% 4) Torresian Crow
% Training uses ground truth labels and bounding boxes from the supplied
% .mat file "WanyaEastSubset_GroundTruth.mat" and the 
% "Wanya_East_181115_to_091215_DM_Subset" dataset of 43 images.


close all;
clear;
% clc;

%% 
% Load the ground truth data
load('WanyaEastSubset_GroundTruth.mat');

%% 
% Change file paths in the ground truth as the labelling was done on a different computer
alternativePaths = ["/Users/s423738/Dropbox/UC/Teaching/8890_CVIA_PG/2022/Data/Wanya_East_181115_to_091215_DM_Subset" "D:\Dev\archieve-data-science\cvia\assets\"];
% alternativePaths = ["/Users/s423738/Dropbox/UC/Teaching/8890_CVIA_PG/2022/Data/Wanya_East_181115_to_091215_DM_Subset" "assets/"];

unresolvedPaths = changeFilePaths(gTruth, alternativePaths);

%% 
% For the labelled ground truth data, get the image data store and bounding box information.
[imds, blds] = objectDetectorTrainingData(gTruth);

%% 
% Combine the two datastores
cds = combine(imds, blds);

%% 
% Check if we have a GPU available and clear any old data from it
% disp('GPU count')
% disp(gpuDeviceCount())
% disp(gpuDevice(1))
% device = gpuDevice(1);
% reset(device);  % Clear previous values that might still be on the GPU

%% 
% Set the training options
options = trainingOptions('sgdm', ...
        'InitialLearnRate', 0.001, ...
        'MiniBatchSize', 4, ...
        'MaxEpochs', 8, ...
        'Verbose', true, ...
        'Shuffle', 'every-epoch', ...
        'VerboseFrequency', 1);

%% 
% Prepare the fasterRCNN training. To keep things simple, we use
%  alexnet as the network model architecture. Our data has 4 classes and we
%  set the default image size to 227x227 pixels. These are RGB images.
inputImageSize =  [227 227 3];
numClasses = 4;

% We use the AlexNet architecture without pretrained weigths as the CNN
% feature extractor.
featureExtractionNetwork = layerGraph(alexnet('Weights', 'none'));
featureLayer = 'relu5';

preprocessedTrainingData = ...
    transform(cds, @(da) preprocessData(da, inputImageSize)); 

numAnchors = 3;
anchorBoxes = estimateAnchorBoxes(preprocessedTrainingData, numAnchors);

lgraph = fasterRCNNLayers(inputImageSize, numClasses, anchorBoxes, ...
                          featureExtractionNetwork, featureLayer);

%% 
% Train the fasterRCNN object detector model
[detector, info] = ...
    trainFasterRCNNObjectDetector(preprocessedTrainingData, lgraph, options, ...
                    'FreezeBatchNormalization', false, ...
                    'NegativeOverlapRange',[0 0.3], ...
                    'PositiveOverlapRange',[0.6 1]);

%% 
% Now, let's test the object detector
fname = imds.Files{40};     % Pick an image
% fname = preprocessedTrainingData.UnderlyingDatastores{1, 1}.UnderlyingDatastores{1, 1}.Files{40};
img = imread(fname);
[bboxes, scores] = detect(detector, img);   % Detect objects

% Check results
whos bboxes scores

% Show results
if (~isempty(bboxes))   % If any known objects found, overlay bounding box
    img = insertObjectAnnotation(img, 'rectangle', bboxes, scores);
end

figure
imshow(img);     % Display image and detected objects

%% 
% Helper function - Preprocessing the training data to fit the target 
%  image size. If we resize the input images, we must also resize the
%  bounding box(es) that belong to the images.
function data = preprocessData(data, targetSize)
    scale = targetSize(1:2)./size(data{1}, [1 2]);
    data{1} = imresize(data{1}, targetSize(1:2));
    bboxes = round(data{2});
    data{2} = bboxresize(bboxes, scale);
end
