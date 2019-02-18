function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb

[R, G, B] = getColorChannels(input_image);

N_R = R./(R+G+B);
N_G = G./(R+G+B);
N_B = B./(R+G+B);

output_image = cat(3, N_R, N_G, N_B);
end

