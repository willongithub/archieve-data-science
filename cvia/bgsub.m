% Background subtraction function for Dingo example
function [binMaskImg, cutOutImg] =  bgsub(inputImg, backgroundImg)
    diffImg = inputImg - backgroundImg;
    gsImg = rgb2gray(diffImg);
    thImg = imbinarize(gsImg, 0.14);
    se = strel('disk',4,4);
    binMaskImg = imclose(thImg,se);

    dimImg = size(inputImg);

    cutOutImg = inputImg;
    
    for i = 1:dimImg(1)
        for j = 1:dimImg(2)
            if binMaskImg(i, j) == 0
                cutOutImg(i, j, :) = 0;
            end
        end
    end

end