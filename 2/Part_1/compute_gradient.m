function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)
sobel_x = [1 0 -1; 2 0 -2; 1 0 -1];
sobel_y = sobel_x';

Gx = double(imfilter(image, sobel_x));
Gy = double(imfilter(image, sobel_y));

im_magnitude = sqrt((Gx.^2 + Gy.^2));
im_direction = atand(Gy./Gx);

%{
% version that gives identical results to imgradient
Gx = double(conv2(image, sobel_x));
Gy = double(conv2(image, sobel_y));

Gx = Gx(2:end-1, 2:end-1);
Gy = Gy(2:end-1, 2:end-1);

im_magnitude = sqrt((Gx.^2 + Gy.^2));
im_direction = -atan2d(Gy, Gx);
%}

end

