function [outputData] = readImagesIntoDatastoreBB(imageFile, imageNames, boundingBox)
% This helper function defines the ReadFCN function for image datastores
% related to the CUB_200_2011 dataset.
% It takes a file name of an image file as input.

% Read image file
outputData = imread(imageFile);

% Check if image is RGB or grayscale
if size(outputData, 3) < 3
    outputData = cat(3, outputData, outputData, outputData);
end

% Find index corresponding to image file name
index = 1;
findFilename = split(imageFile, "\");
imageFileName = findFilename(end);
for index = 1:height(imageNames)
    if strfind(imageNames(index, 2).imageName{1}, imageFileName{1})
        break;
    end
end

x = table2array(boundingBox(index, 'x'));
y = table2array(boundingBox(index, 'y'));
w = table2array(boundingBox(index, 'w'));
h = table2array(boundingBox(index, 'h'));

outputData = imcrop(outputData, [x, y, w, h]);

end