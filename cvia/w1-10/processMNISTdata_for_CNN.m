function [X,L] = processMNISTdata_for_CNN(imageFileName,labelFileName)

[fileID,errmsg] = fopen(imageFileName,'r','b');
if fileID < 0
    error(errmsg);
end
%%
% First read the magic number. This number is 2051 for image data, and
% 2049 for label data
magicNum = fread(fileID,1,'int32',0,'b');
if magicNum == 2051
    fprintf('\nRead MNIST image data...\n')
end
%%
% Then read the number of images, number of rows, and number of columns
numImages = fread(fileID,1,'int32',0,'b');
fprintf('Number of images in the dataset: %6d ...\n',numImages);
numRows = fread(fileID,1,'int32',0,'b');
numCols = fread(fileID,1,'int32',0,'b');
fprintf('Each image is of %2d by %2d pixels...\n',numRows,numCols);
%%
% Read the image data
RawImgData = fread(fileID,inf,'unsigned char');
%%
% Reshape the data to array X
RawImgData = reshape(RawImgData,[numRows,numCols,numImages]);
RawImgData = permute(cat(4, RawImgData),[2 1 4 3]);
%%
% Then flatten each image data into a 1 by (numRows*numCols) vector, and 
% store all the image data into a numImages by (numRows*numCols) array.
X = uint8(RawImgData);
fprintf(['The image data is read to a matrix of dimensions: %3d x %3d x %3d x %6d...\n',...
    'End of reading image data.\n'],size(X,1),size(X,2),size(X,3),size(X,4));
%%
% Close the file
fclose(fileID);
%%
% Similarly, read the label data.
[fileID,errmsg] = fopen(labelFileName,'r','b');
if fileID < 0
    error(errmsg);
end
magicNum = fread(fileID,1,'int32',0,'b');
if magicNum == 2049
    fprintf('\nRead MNIST label data...\n')
end
numItems = fread(fileID,1,'int32',0,'b');
fprintf('Number of labels in the dataset: %6d ...\n',numItems);

L = fread(fileID,inf,'unsigned char');
%L = permute(L, [2 1]);
L = categorical(uint8(L));
fprintf(['The label data is read to a matrix of dimensions: %6d by %2d...\n',...
    'End of reading label data.\n'],size(L,1),size(L,2));
fclose(fileID);