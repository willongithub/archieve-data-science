function [outputData] = readImagesIntoDatastore(imageFile)
% This helper function defines the ReadFCN function for image datastores
% related to the CUB_200_2011 dataset.
% It takes a file name of an image file as input.
outputData = imread(imageFile);

% Check if image is RGB or grayscale
if size(outputData, 3) < 3
    outputData = cat(3, outputData, outputData, outputData);
end

end