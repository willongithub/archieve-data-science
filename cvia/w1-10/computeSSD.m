% Function to compute the SAD similarity measure 
function [SSD_values, tmpHeightHalf, tmpWidthHalf, imgSize] = ... 
    computeSSD(inputImg, tmpImg)

    % Determine size of input image and template image 
    imgSize = size(inputImg); 
    tmpSize = size(tmpImg); 
    tmpHeightHalf = tmpSize(1)/2; 
    tmpWidthHalf = tmpSize(2)/2; 
    SSD_values = zeros(imgSize);
     
    for iRow = tmpHeightHalf : imgSize(1)-tmpHeightHalf 
      for iCol = tmpWidthHalf : imgSize(2)-tmpWidthHalf 
        SSD_values(iRow, iCol) = ... 
          sum((inputImg(1+iRow-tmpHeightHalf:iRow+tmpHeightHalf, ... 
                           1+iCol-tmpWidthHalf:iCol+tmpWidthHalf) ... 
                  - tmpImg)^2, 'all'); 
      end 
    end

end