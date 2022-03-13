% Entry point to run background subtraction for all images in the folder.
path = "/Users/lw/Documents/Workspace/archieve-data-science/cvia/bgs/assets";
files = dir([path '*.jpg']); 
count = size(files);

for i = 1:count(1) 
    files(i).name 
 
    % Load input image 
    input = imread([path files(i).name]); 

    % Load background image
 
    % Call background subtraction function
    [mask, result] = bgs(input, background);

    figure("Name","Result");
    imshowpair(mask, result, 'montage');
end 