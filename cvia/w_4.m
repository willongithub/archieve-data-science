% CVIA Lab Week 4

%% 4
% Load imaged
bgImg = imread("assets/DINGO3_Background.jpeg");
ogImg = imread("assets/DINGO3_Frame0.jpeg");

% Subtraction
diffImg = ogImg - bgImg;

% Raw target
figure("Name","Raw"), imshow(diffImg);

% Grayscale
figure("Name","Grayscale");
gsImg = rgb2gray(diffImg);
imshow(gsImg);

% Threshold
figure("Name","Treshold");
thImg = imbinarize(rgb2gray(diffImg), 0.14);
imshow(thImg);

%% 5
% imdilate
figure("Name","Dilated");
se = strel('disk',4,4);
dilatedImg = imdilate(thImg,se);
imshowpair(thImg,dilatedImg,'montage');

%% 6
% imerode
figure("Name","Eroded");
erodedImg = imdilate(thImg,se);
imshowpair(thImg,erodedImg,'montage');

%% 7
% imclose
figure("Name","Combined");
combImg = imclose(thImg,se);
imshowpair(thImg,combImg,'montage');

%% 9
dimImg = size(ogImg);

maskedImg = ogImg;

for i = 1:dimImg(1)
    for j = 1:dimImg(2)
        if combImg(i, j) == 0
            maskedImg(i, j, :) = 0;
        end
    end
end

figure("Name","Masked");
imshowpair(ogImg, maskedImg, 'montage')

%% 10
% Load moved dingo
mdImg = imread("assets/DINGO3_Frame477.jpeg");
figure("Name","Moved Dingo");
imshow(mdImg);

%% 11
% @bgsub.m
[mask, result] = bgsub(mdImg, bgImg);

figure("Name","Result");
imshowpair(mask, result, 'montage');

%% 12

%% 16
barImg = imread('assets/barcode.jpg');
barGsImg = rgb2gray(barImg);
rsBar = edge(barGsImg, "canny");

[H, theta, rho] = hough(barGsImg);

%% 17
% Display the original image. 
subplot(2,1,1); 
imshow(barImg); 
title('Input Image'); 
 
% Display the Hough matrix. 
subplot(2,1,2); 
imshow(imadjust(mat2gray(H)),'XData',theta,'YData',rho, ...
    'InitialMagnification','fit'); 
title('Hough Transform of the Input Image'); 
xlabel('\theta'), ylabel('\rho'); 
axis on, axis normal, hold on; 
colormap(hot);

%%
% Homework

%% 1
rcImg = imread('assets/robocup_image1.jpg');
barImg = imread('assets/barcode.jpg');

rcGsImg = rgb2gray(rcImg);
[rcH, rcT, rcR] = hough(rcGsImg);

barGsImg = rgb2gray(barImg);
[barH, barT, barR] = hough(barGsImg);

%% 2
rotatedEdgeImg = imrotate(rcImg, 45);

%% 3

%% 4
% imfindcircles


