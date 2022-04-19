function [features, setLabels] = helperExtractSIFTFeaturesFromImageSet(imds, size, max)
% Extract SIFT features from an imageDatastore.

setLabels = imds.Labels;
numImages = numel(imds.Files);
FeatureSize = size*max;
features  = zeros(numImages,FeatureSize,'single');

% Process each image and extract features
for i = 1:numImages
    img = readimage(imds,i);
    
    img = im2gray(img); % ensure images are grayscale
    
    % Apply pre-processing steps - binarize images
    img = imbinarize(img);

    % Extract features.
    sift = detectSIFTFeatures(img);
    [~, points] = extractFeatures(img, sift);
    points = points.selectStrongest(max);

    if ~isempty(points) 
        for p = 0:length(points)-1  
            l = points(p+1).Location; 
            features(i, (p*size)+1) = l(1);
            features(i, (p*size)+2) = l(2);
            features(i, (p*size)+3) = points(p+1).Scale;  
            features(i, (p*size)+4) = points(p+1).Octave;
            features(i, (p*size)+5) = points(p+1).Orientation;
            features(i, (p*size)+6) = points(p+1).Metric;
            features(i, (p*size)+7) = points(p+1).Layer;
        end 
    end

end % end of function