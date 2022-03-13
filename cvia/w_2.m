% CVIA Lab Week 2

%% 
% Load image
ogImg = imread('chocolate_original.jpg');
% figure(1);
% imshow(ogImg), title("Original Image");

% Resize
resizedImg = imresize(ogImg, [480 640]);
% figure(2);
% imshow(resizedImg), title("Resized Image");

% Single color channel
redImg = resizedImg(:,:,1);
% figure(3);
% imshow(redImg), title("Red Only");

greenImg = resizedImg(:,:,2);
% figure(4);
% imshow(greenImg), title("Green Only");

blueImg = resizedImg(:,:,3);
% figure(5);
% imshow(blueImg), title("Blue Only");

% Grayscale
gsImg = im2gray(resizedImg);
% figure(6);
% imshow(gsImg), title("Grayscale Image");

% Binary image
levelScale = graythresh(gsImg);
bwImg = imbinarize(gsImg, levelScale);
% figure(7);
% imshow(bwImg), title("black-white Image");

% Threshold image 
% for iter = 0.0:0.01:1.0 
%     thImg = imbinarize(gsImg, iter); 
%     figure(8); 
%     imshow(thImg); 
%     pause(0.05); 
% end

% Hist of the image
% figure(9);
% imhist(blueImg);
th_low = 80;
th_high = 35;

% Find appropreate threshold
blueLowImg = imbinarize(blueImg, th_low/255);
% figure(10);
% imshow(blueLowImg);

blueHighImg = imbinarize(blueImg, th_high/255);
% figure(11);
% imshow(blueHighImg);

blueMidImg = blueHighImg - blueLowImg;
% figure(12);
% imshow(blueMidImg);

% Apply to grayscale image
gsOgImg = im2gray(ogImg);
gsLowImg = imbinarize(gsOgImg, th_low/255);
gsHighImg = imbinarize(gsOgImg, th_high/255);
gsMidImg = gsHighImg - gsLowImg;

figure(13);
imshow(gsMidImg);

figure(14);
imhist(gsMidImg);

% Homework
%% 
ogImg = imread('chocolate_original.jpg');
resizedImg = imresize(ogImg, [480 640]);
blueImg = resizedImg(:,:,3);
th_low = 80;
th_high = 35;

blueChannelBinaryMask = zeros([480 640]);
%% 
for i = 1:480
    for j = 1:640
        if blueImg(i, j) > 35 && blueImg(i, j) < 80
            blueChannelBinaryMask(i, j) = 1;
        else
            blueChannelBinaryMask(i, j) = 0;
        end
    end
end
%% 
rsImg = uint8(blueChannelBinaryMask).*blueImg;
figure(1);
imshow(rsImg);
figure(2);
imhist(rsImg);
%% 
heImg = histeq(blueImg);
imshowpair(blueImg, heImg, 'montage');
figure;
imhist(heImg);