% Helper function mapping image names to bounding boxes and vice versa
function image_box_map = returnMapping(ImageNames, boundingBoxes)
    image_box_map = containers.Map;
    for i = 1:size(ImageNames, 1) 
        fn = ImageNames{i,2}{1};
        fn = split(fn, "\");
        fn = split(fn, "/");
        image_box_map(fn{end}) = [boundingBoxes{ImageNames{i,1}, 2:5}];
    end
end