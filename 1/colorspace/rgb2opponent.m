function [output_image] = rgb2opponent(input_image)
% converts an RGB image into opponent color space
[R, G, B] = getColorChannels(input_image);

O_1 = (R-G)./sqrt(2);
O_2 = (R+G-2.*B)./sqrt(6);
O_3 = (R+G+B)./sqrt(3);

output_image = cat(3, O_1, O_2, O_3);

end

