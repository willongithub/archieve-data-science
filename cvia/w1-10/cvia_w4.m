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
% @runbgs.m

%% 16
barImg = imread("assets/barcode.jpg");
% figure(1), imshow(barImg);
barGsImg = rgb2gray(barImg);
rsBar = edge(barGsImg, 'Sobel');

figure(2);
subplot(2,1,1); 
imshow(barGsImg); 
title("Monocolour Image");
subplot(2,1,2);
imshow(rsBar); 
title("Edge Detected");

[H, theta, rho] = hough(rsBar);

%% 17
% Display the original image. 
subplot(2,1,1); 
imshow(barImg); 
title("Input Image"); 

% Display the Hough matrix. 
subplot(2,1,2); 
imshow(imadjust(mat2gray(H)),'XData',theta,'YData',rho, ...
    'InitialMagnification','fit'); 
title("Hough Transform of the Input Image"); 
xlabel('\theta'), ylabel('\rho'); 
axis on, axis normal, hold on; 
colormap(hot);

%%
% Homework

%% 1
rcImg = imread("assets/robocup_image1.jpg");
figure("Name","input");
imshow(rcImg);
% barImg = imread("assets/barcode.jpg");

%% 2
rcRotated = imrotate(rcImg, 45);
figure("Name","rotated");
imshow(rcRotated);
% barRotated = imrotate(barImg, 45);

%% 3
rcGsImg = rgb2gray(rcRotated);
rcEdge = edge(rcGsImg, 'Sobel');
figure("Name","edge detected");
imshow(rcEdge);
[rcH, rcT, rcR] = hough(rcEdge);

% barGsImg = rgb2gray(barImg);
% barEdge = edge(barGsImg, 'Sobel');
% [barH, barT, barR] = hough(barEdge);

%% 4
% Find circles
[centers, radii, metric] = imfindcircles(rcGsImg, [15 30]);

centersStrong5 = centers(1:5,:); 
radiiStrong5 = radii(1:5);
metricStrong5 = metric(1:5);

viscircles(centersStrong5, radiiStrong5,'EdgeColor','y');

%% 5
% Help with colour

