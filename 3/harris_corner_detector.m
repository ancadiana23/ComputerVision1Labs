function [H, r, c] = harris_corner_detector(image)

gauss_kernel = fspecial('gaussian', [3, 3], 0.8);
[Gx,Gy] = gradient(gauss_kernel);

I = rgb2gray(image);
Ix = imfilter(I, Gx);
Iy = imfilter(I, Gy);

A = imgaussfilt(Ix .^ 2);
B = imgaussfilt(Ix .* Iy);
C = imgaussfilt(Iy .^ 2);

H = (A .* C - B.^2 ) - 0.04 * (A + C).^2;

threshold = 100;

%{
% Choosing the local maxima can be done with builtin functions
corner_points = imregionalmax(H);
corner_points = double(H) .* double(corner_points);

[r, c] = find(H > threshold);
%}


[h, w] = size(H);
new_corner_points = zeros(h, w);
padded_H = padarray(H, [1, 1]);
for i = 1:h
    for j = 1:w
        if padded_H(i + 1, j + 1) > 200
            new_corner_points(i, j) = sum(sum(padded_H(i:i+2, j:j+2) > padded_H(i + 1, j + 1))) == 0;
        end 
    end
end

new_corner_points = double(H) .* double(new_corner_points);
[r, c] = find(new_corner_points > threshold);

end






