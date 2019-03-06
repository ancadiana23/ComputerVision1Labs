function [H, r, c] = harris_corner_detector(image)

sigma = 0.8;

I = rgb2gray(image);
I = double(I);
I = imgaussfilt(I, sigma);

gauss_kernel = fspecial('gaussian', [9, 9], 1.5);
[Gx,Gy] = gradient(gauss_kernel);

%Gy = [1 0 -1; 2 0 -2; 1 0 -1];
%Gx = [1 2 1; 0 0 0; -1 -2 -1];

Ix = imfilter(I, Gx, 'replicate', 'same', 'conv');
Iy = imfilter(I, Gy, 'replicate', 'same', 'conv');

figure, imshow(uint8(Ix));
figure, imshow(uint8(Iy));
drawnow

A = imgaussfilt(Ix .^ 2, sigma);
B = imgaussfilt(Ix .* Iy, sigma);
C = imgaussfilt(Iy .^ 2, sigma);

H = (A .* C - B.^2 ) - 0.04 * ((A + C).^2);
H = H ./ max(max(H));

% use build-in function to find the local maxima
%corner_points = imregionalmax(H,8);
%corner_points = H .* corner_points;


[h, w] = size(H);
window_size = 6;
offset = floor(window_size / 2);
corner_points = zeros(h, w);
padded_H = padarray(H, [offset, offset]);
for i = 1:h
    for j = 1:w
        i2 = i + window_size - 1;
        j2 = j + window_size - 1;
        
        corner_points(i, j) = sum(sum(padded_H(i:i2, j:j2) > H(i, j))) == 0;
        corner_points(i, j) = corner_points(i, j) * H(i, j);
    end 
end


threshold = 100 * mean(mean(corner_points))
[r, c] = find(corner_points > threshold);

figure, imshow(image);
hold on
plot(c, r, 'yo', 'LineWidth',1.5,...
    'MarkerSize',8);
hold off
drawnow


end






