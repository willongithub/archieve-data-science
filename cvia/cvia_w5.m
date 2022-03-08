% CVIA Lab Week 5

%% 3
barImg = imread("assets/barcode.jpg");
% figure(1), imshow(barImg);
barGs = rgb2gray(barImg);
barEdge = edge(barGs, 'Sobel');

figure(2);
subplot(2,1,1); 
imshow(barGs); 
title("Monocolour Image");
subplot(2,1,2);
imshow(barEdge); 
title("Edge Detected");

[H, theta, rho] = hough(barEdge);

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

%% 6
rcImg = imread("assets/robocup_image1.jpeg");
% figure("Name","input");
% imshow(rcImg);

rcGsImg = rgb2gray(rcImg);
rcEdge = edge(rcGsImg, 'canny');
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

figure, imshow(rcImg), hold on
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

% @fl.m

%% 11
%% 12
%% 13