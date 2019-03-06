function [H, r, c] = harris_corner_detector(image)

gauss_kernel = fspecial('gaussian', [3, 3], 0.7);
[Gx,Gy] = gradient(gauss_kernel);

I = rgb2gray(image);
Ix = imfilter(I, Gx);
Iy = imfilter(I, Gy);

%figure, imshow(Ix);
%figure, imshow(Iy);
%drawnow

A = imgaussfilt(Ix .^ 2);
B = imgaussfilt(Ix .* Iy);
C = imgaussfilt(Iy .^ 2);

H = (A .* C - B.^2 ) - 0.04 * (A + C).^2;

threshold = 220;

%corner_points = imregionalmax(H);
%corner_points = double(H) .* double(corner_points);

[h, w] = size(H);
window_size = 5;
offset = floor(window_size / 2)
new_corner_points = zeros(h, w);
padded_H = padarray(H, [offset, offset]);
size(H)
size(padded_H)
for i = 1:h
    for j = 1:w
        i2 = i + window_size - 1;
        j2 = j + window_size - 1;
        
        new_corner_points(i, j) = sum(sum(padded_H(i:i2, j:j2) > H(i, j))) == 0;
        new_corner_points(i, j) = new_corner_points(i, j) * padded_H(i + 1, j + 1);
    end 
end

[r, c] = find(new_corner_points > threshold);

figure, imshow(image);
hold on
plot(c, r, 'o');
hold off
drawnow


end






