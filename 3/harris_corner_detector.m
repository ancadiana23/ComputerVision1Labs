function [H, r, c] = harris_corner_detector(image)

gauss_kernel = fspecial('gaussian', [3, 3], 0.7);
[Gx,Gy] = gradient(gauss_kernel);

I = rgb2gray(image);
Ix = imfilter(I, Gx);
Iy = imfilter(I, Gy);

figure, imshow(Ix);
figure, imshow(Iy);
drawnow

A = imgaussfilt(Ix .^ 2);
B = imgaussfilt(Ix .* Iy);
C = imgaussfilt(Iy .^ 2);

H = (A .* C - B.^2 ) - 0.04 * (A + C).^2;

threshold = 220;

corner_points = imregionalmax(H);
corner_points = double(H) .* double(corner_points);

[r, c] = find(H > threshold);

figure, imshow(image);
hold on
plot(c, r, 'o');
hold off
drawnow


end






