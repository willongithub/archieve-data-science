# Computer Vision and Image Analysis Lab Week 6

%% 1
% Load image
rcImg = imread("assets\robocup_image1.jpeg");
figure(1);
subplot(2, 4, 1);
imshow(rcImg);
title('Original Image');

%% 2
% Ball template
template = rcImg(406:451, 95:140, :);
subplot(2, 4, 2);
imshow(template);
title('Ball Template Image');