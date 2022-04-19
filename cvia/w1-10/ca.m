function [hue, saturation, value] = ca(input)
    % Colour Analysis function
    HSV = rgb2hsv(input);
    hue = HSV(:, :, 1);
    saturation = HSV(:, :, 2);
    value = HSV(:, :, 3);
end

