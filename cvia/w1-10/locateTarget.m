function locateTarget(input, target, method)
    if method == "SAD"
        [values, tmpHeightHalf, tmpWidthHalf, imgSize] = ... 
        computeSAD(input, target);
    elseif method == "SSD"
        [values, tmpHeightHalf, tmpWidthHalf, imgSize] = ... 
        computeSSD(input, target);
    end

    maxValues = max(max(values));
    
    [min_Val, min_Col] = ... 
        min(min(values(tmpHeightHalf : imgSize(1)-tmpHeightHalf, ... 
                           tmpWidthHalf : imgSize(2)-tmpWidthHalf))); 
    
    [min_Val, min_Row] = ... 
        min(values(tmpHeightHalf : imgSize(1)-tmpHeightHalf, ... 
                       min_Col+tmpWidthHalf-1)); 
    
    disp([min_Row min_Col min_Val]);
end