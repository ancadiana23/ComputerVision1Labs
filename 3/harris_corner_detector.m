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

%{
corner_points = imregionalmax(H);
corner_points = double(H) .* double(corner_points);

figure, imshow(corner_points > 200);
%}

[h, w] = size(H)
new_corner_points = zeros(h, w);
padded_H = padarray(H, [1, 1]);
r = [];
c = [];
for i = 1:h
    for j = 1:w
        if padded_H(i + 1, j + 1) > 200
            new_corner_points(i, j) = sum(sum(padded_H(i:i+2, j:j+2) > padded_H(i + 1, j + 1))) == 0;
            r = [r, i];
            c = [c, j];
        end 
    end
end
figure, imshow(new_corner_points);
size(r)
size(c)
end






