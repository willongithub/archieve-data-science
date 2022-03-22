% Computer Vision and Image Analysis Lab Week 7

%% 1
% Load image
rcImg = imread("assets/robocup_image1.jpeg");
% figure;
% imshow(rcImg1);
% title('Original Image');

%% 2
rcGray = rgb2gray(rcImg);
% figure;
% imshow(rcGray1);
% title('Grayscale Image');

%% 3
figure;
subplot(2, 3, 1);
imshow(rcImg);
title('Original Image');
subplot(2, 3, 4);
imshow(rcGray);
title('Grayscale Image');

%% 4 Harris Corners
hrsConr = detectHarrisFeatures(rcGray);
subplot(2, 3, 2);
imshow(rcGray);
hold on;
plot(hrsConr.selectStrongest(50));
hold off;

%% 6 HOG
[~, hogVis] = extractHOGFeatures(rcGray, 'CellSize', [16 16]);
subplot(2, 3, 3);
imshow(rcGray);
hold on;
plot(hogVis);
hold off;

%% 7 SIFT
siftPoints = detectSIFTFeatures(rcGray);
subplot(2, 3, 5);
imshow(rcGray);
hold on;
plot(siftPoints.selectstrongest(50));
hold off;

%% 8 SURF
surfPoints = detectSURFFeatures(rcGray);
subplot(2, 3, 6);
imshow(rcGray);
hold on;
plot(surfPoints.selectstrongest(50));
hold off;

%% 10

%% 12