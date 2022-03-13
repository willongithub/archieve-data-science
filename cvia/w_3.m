% CVIA Lab Week 3

%% 2
% Load image
ogImg = imread('barcode_cropped.jpg');
% figure(1);
% imshow(ogImg), title("Original Image");

% Single color channel
redImg = ogImg(:,:,1);
% figure(2);
% imshow(redImg), title("Red Only");

greenImg = ogImg(:,:,2);
% figure(3);
% imshow(greenImg), title("Green Only");

blueImg = ogImg(:,:,3);
% figure(4);
% imshow(blueImg), title("Blue Only");

% Grayscale
gsImg = rgb2gray(ogImg);
% figure(5);
% imshow(gsImg), title("Grayscale Image");

%% 3
heBlueImg = histeq(blueImg);
% figure("Name", "Blue Channel Pic");
imshowpair(blueImg, heBlueImg, 'montage');
% figure("Name", "Blue Channel Hist");
imhist(heBlueImg);

heGreenImg = histeq(greenImg);
% figure("Name", "Green Channel Pic");
imshowpair(greenImg, heGreenImg, 'montage');
%figure("Name", "Green Channel Hist");
imhist(heGreenImg);

heRedImg = histeq(redImg);
% figure("Name", "Red Channel Pic");
imshowpair(redImg, heRedImg, 'montage');
% figure("Name", "Red Channel Hist");
imhist(heRedImg);

heGsImg = histeq(gsImg);
% figure("Name", "GreyScale Channel Pic");
imshowpair(gsImg, heGsImg, 'montage');
% figure("Name", "GreyScale Channel Hist");
imhist(heGsImg);

%% 4
pic3 = uint8(zeros([688 446 3]));
pic3(:,:,1) = heRedImg;
pic3(:,:,2) = heGreenImg;
pic3(:,:,3) = heBlueImg;

figure("Name", "Combined Image")
imshow(pic3);

%% 7
% Load images
barImg = imread('barcode_cropped.jpg');
chocoImg = imread('chocolate_original.jpg');

% Display images
figure("Name","Barcode Image"), imshow(barImg);
figure("Name","Chocolete Image"), imshow(chocoImg);

% Convert to greyscale
barGsImg = rgb2gray(barImg);
chocoGsImg = rgb2gray(chocoImg);

%% 8
% Apply Sobel method
rsBar = edge(barGsImg, "sobel");
rsChoco = edge(chocoGsImg, "sobel");

% Display results
figure("Name","Barcode Image"), imshow(rsBar);
figure("Name","Chocolete Image"), imshow(rsChoco);

%% 9
% Apply Canny method
rsBar = edge(barGsImg, "canny");
rsChoco = edge(chocoGsImg, "canny");

% Display results
figure("Name","Barcode Image"), imshow(rsBar);
figure("Name","Chocolete Image"), imshow(rsChoco);

%% 10
blueChocoImg = chocoImg(:, :, 3);

blueChannelBinaryMask = zeros([2448 3264]);

for i = 1:2448
    for j = 1:3264
        if blueChocoImg(i, j) > 35 && blueChocoImg(i, j) < 80
            blueChannelBinaryMask(i, j) = 1;
        else
            blueChannelBinaryMask(i, j) = 0;
        end
    end
end

ftImg = uint8(blueChannelBinaryMask).*blueChocoImg;
% ftImg = histeq(blueChocoImg);

% Apply edge detection
rsChocoSobel = edge(ftImg, "sobel");
rsChocoCanny = edge(ftImg, "canny");

% Display results
figure("Name","Chocolete (Sobel)"), imshow(rsChocoSobel);
figure("Name","Chocolete (Canny)"), imshow(rsChocoCanny);

% Homework
%% 2
% Load imaged
bgImg = imread("DINGO3_Background.jpeg");
fgImg = imread("DINGO3_Frame0.jpeg");

% Display images
figure("Name","Background"), imshow(bgImg);
figure("Name","Original"), imshow(fgImg);

%% 3
diffImg = fgImg - bgImg;

%% 5
overallMin = min(min(diffImg));
overallMax = max(max(diffImg));

%% 6
% Remap

%% 7
figure("Name","Result"), imshow(diffImg);

