function [features, setLabels] = helperExtractHOGFeaturesFromImageSet(imds, hogFeatureSize, cellSize)
% Extract HOG features from an imageDatastore.

setLabels = imds.Labels;
numImages = numel(imds.Files);
features  = zeros(numImages,hogFeatureSize,'single');

% Process each image and extract features
for j = 1:numImages
    img = readimage(imds,j);
    img = im2gray(img);
    
    % Apply pre-processing steps
    img = imbinarize(img);
    
    features(j, :) = extractHOGFeatures(img,'CellSize',cellSize);
end

end % end of function