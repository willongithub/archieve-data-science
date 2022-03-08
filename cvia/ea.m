% Load, display and apply edge detector on rgb image
rcImg = imread("assets/robocup_image2.jpeg");
% figure("Name","input");
% imshow(rcImg);

rcGsImg = rgb2gray(rcImg);
rcEdge = edge(rcGsImg, 'sobel');
% rcEdge = edge(rcGsImg, 'canny');
% figure("Name","edge detected");
% imshow(rcEdge);

figure("Name","Robocup");
subplot(1,2,1); 
imshow(rcImg); 
title("Original Image");
subplot(1,2,2);
imshow(rcEdge); 
title("Edge Detected");