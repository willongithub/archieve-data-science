% CVIA Lab Week 5

%% 3
barImg = imread("assets/barcode.jpg");
% figure(1), imshow(barImg);
barGs = rgb2gray(barImg);
barEdge = edge(barGs, 'Sobel');
% barEdge = edge(barGs, 'Canny');

figure(2);
subplot(2,1,1); 
imshow(barGs); 
title("Monocolour Image");
subplot(2,1,2);
imshow(barEdge); 
title("Edge Detected");

% [H, theta, rho] = hough(barEdge);
[H, theta, rho] = hough( ...
    barEdge, ...
    'RhoResolution', 0.7, ...
    'Theta', -90:0.5:89);

%% 4
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

P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');

%%
lines = houghlines(barEdge,theta,rho,P,'FillGap',5,'MinLength',7);

figure, imshow(barImg), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');

%% 6
% @ea.m
rcImg = imread("assets/robocup_image1.jpeg");
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

%% 7
[H, theta, rho] = hough(rcEdge);

figure
imshow(imadjust(rescale(H)),[],...
       'XData',theta,...
       'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal 
hold on
colormap(gca,hot)

P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');

%%
lines = houghlines(rcEdge,theta,rho,P,'FillGap',5,'MinLength',7);

figure, imshow(rcEdge), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');

%% 8


%% 9
% @ca.m

%% 10
[h, s, v] = ca(rcImg);

figure("Name","HSV Separated");
subplot(1,3,1); 
imshow(h); 
title("Hue");
subplot(1,3,2);
imshow(s); 
title("Saturation");
subplot(1,3,3);
imshow(v); 
title("Value");

% @fl.m

%% 11
rcImg = imread("assets/robocup_image2.jpeg");
figure("Name","Input"), imshow(rcImg);
rcGs = rgb2gray(rcImg);

[h, s, v] = ca(rcImg);
figure("Name","Hue"), imshow(h);

%% 12
[centers, radii, metric] = imfindcircles(h, [6 20]);

centersStrong = centers(1:3,:); 
radiiStrong = radii(1:3);
metricStrong = metric(1:3);

imshow(rcGs);
viscircles(centersStrong, radiiStrong,'EdgeColor','y');

%% 13
% @fb.m
rcBw = rcImg(:,:,1);
% figure("Name","green channel"), imshow(rcBw);
% figure("Name","green channel distribution"), imhist(rcBw);

% figure("Name","Threshold"); 
% for i = 0.0:0.05:1.0 
%     thImg = imbinarize(rcBw, i);   
%     imshow(thImg); 
%     pause(0.05); 
% end

th = 160;

rcBall = imbinarize(rcBw, th/255);
figure("Name","find ball"), imshow(rcBall);

%%
th_h = 160;
th_l = 200;
rcBwH = imbinarize(rcBw, th_h/255);
rcBwL = imbinarize(rcBw, th_l/255);
rcBall = rcBwH - rcBwL;
figure("Name","thresholded"), imshow(rcBall);

%%
rcGs = im2gray(rcImg);
rcGsH = imbinarize(rcGs, th_h/255);
rcGsL = imbinarize(rcGs, th_l/255);
rcBall = rcGsH - rcGsL;
figure("Name","thresholded"), imshow(rcBall);