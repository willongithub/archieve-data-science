function [outputData] = readImagesIntoDatastoreBB(imageFile, image_box_map)
% function [outputData] = readImagesIntoDatastoreBB(imageFile, imageNames, boundingBox)
% This helper function defines the ReadFCN function for image datastores
% related to the CUB_200_2011 dataset.
% It takes a file name of an image file as input.

% Read image file
if isfile(imageFile)
    outputData = imread(imageFile);
else
    disp(imageFile)
end

% Check if image is RGB or grayscale
if size(outputData, 3) < 3
    outputData = cat(3, outputData, outputData, outputData);
end

% Find index corresponding to image file name
Filename = split(imageFile, "\");
Filename = split(Filename, "\"); 
xywh_BB = image_box_map(Filename{end}); 

x = xywh_BB(1);
y = xywh_BB(2);
w = xywh_BB(3);
h = xywh_BB(4);

% imageFileName = findFilename(end);
% for index = 1:height(imageNames)
%     if strfind(imageNames(index, 2).imageName{1}, imageFileName{1})
%         break;
%     end
% end
% 
% x = table2array(boundingBox(index, 'x'));
% y = table2array(boundingBox(index, 'y'));
% w = table2array(boundingBox(index, 'w'));
% h = table2array(boundingBox(index, 'h'));
% 
% outputData = imcrop(outputData, [x, y, w, h]);

if x > size(outputData, 2) || y > size(outputData, 1)   
        disp("error")
        disp([index, x, y, w, h])
else
    outputData = imcrop(outputData, [x, y, w, h]);
end 

end