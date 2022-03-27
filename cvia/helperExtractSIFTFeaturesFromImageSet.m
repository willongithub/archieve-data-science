function [features, setLabels] = helperExtractSIFTFeaturesFromImageSet(imds, hogFeatureSize, cellSize)
% Extract HOG features from an imageDatastore.

setLabels = imds.Labels;
numImages = numel(imds.Files);
features  = zeros(numImages,size(sift),'single');

% Process each image and extract features
for j = 1:numImages
    img = readimage(imds,j);
    img = im2gray(img);
    
    % Apply pre-processing steps
    img = imbinarize(img);
    
    features(j, :) = detectSIFTFeatures(img);
end

end % end of function