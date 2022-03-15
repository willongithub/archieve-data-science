% Computer Vision and Image Analysis Lab Week 6

%% 1
% Load image
rcImg = imread("assets/robocup_image1.jpeg");
figure(1);
subplot(2, 4, 1);
imshow(rcImg);
title('Original Image');

%% 2


%% 3
% @simi_mesu.m

%% 4
% Ball template
temp = rcImg(406:451, 95:140, :);
subplot(2, 4, 2);
imshow(temp);
title('Template Image');

rcGsImg = rgb2gray(rcImg);
tempGs = rcGsImg(406:451, 95:140);
subplot(2, 4, 5);
imshow(rcGsImg);
title('Grayscale Image');
subplot(2, 4, 6);
imshow(tempGs);
title('Template Grayscale Image');

%% 5


%% 6
% Compute SAD values 
[SAD_values, tmpHeightHalf, tmpWidthHalf, imgSize] = ... 
    computeSAD(robocupGrayImg, templateBallGrayImg); 
maxSAD = max(max(SAD_values)); % Need this for scaling of the values 
[minSAD_Val, minSAD_Col] = ... % Determine column of best match 
    min(min(SAD_values(tmpHeightHalf : imgSize(1)-tmpHeightHalf, ... 
                       tmpWidthHalf : imgSize(2)-tmpWidthHalf))); 
[minSAD_Val, minSAD_Row] = ... % Determine row of best match 
    min(SAD_values(tmpHeightHalf : imgSize(1)-tmpHeightHalf, ... 
                   minSAD_Col+tmpWidthHalf-1)); 
% Top-left corner coordinates of best fitting location 
disp([minSAD_Row minSAD_Col minSAD_Val]);

%% 7