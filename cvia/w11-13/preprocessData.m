% Helper function for resizing images in transform
function data_out = preprocessData(data, targetSize)
    try
        data_out{1} = imresize(data{1}, targetSize(1:2)); % Resize images
        data_out{2} = data{2};  % Keep labels as they are
    catch e
        % This is solely for debugging
        disp(e) 
    end
end
