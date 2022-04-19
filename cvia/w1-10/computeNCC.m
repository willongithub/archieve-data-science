% Function to compute the SAD similarity measure 
function NCC_values = computeNCC(inputImg, tmpImg) 
    NCC_values = normxcorr2(tmpImg, inputImg);

    figure;
    surf(NCC_values), shading flat
    
    [ypeak,xpeak] = find(NCC_values==max(NCC_values(:)));
    yoffSet = ypeak-size(tmpImg,1);
    xoffSet = xpeak-size(tmpImg,2);
    figure;
    imshow(inputImg)
    drawrectangle( ...
        gca,'Position', ...
        [xoffSet,yoffSet,size(tmpImg,2),size(tmpImg,1)], ...
        'FaceAlpha',0 ...
    );
end