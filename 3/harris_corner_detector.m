function [H, r, c] = harris_corner_detector(image)

sigma = 0.8;

% use the graysclace of the image and cast it to double
I = rgb2gray(image);
I = double(I);

% apply a smoothing gaussian filter
I = imgaussfilt(I, sigma);

% take the gradient of the gaussing filter
% the result is the derivatives, with respect to the x and y axis, of the gaussian 
gauss_kernel = fspecial('gaussian', [9, 9], 1.5);
[Gx,Gy] = gradient(gauss_kernel);


% compute the convolution between the derivatives of the gaussian and the 
% grayscale image 
Ix = imfilter(I, Gx, 'replicate', 'same', 'conv');
Iy = imfilter(I, Gy, 'replicate', 'same', 'conv');

% show the two results
figure, imshow(uint8(Ix));
figure, imshow(uint8(Iy));
drawnow

% compute the elemets ofthe Q matrix and apply a gaussian filter to each of
% them
A = imgaussfilt(Ix .^ 2, sigma);
B = imgaussfilt(Ix .* Iy, sigma);
C = imgaussfilt(Iy .^ 2, sigma);

% compute the cornerness of the image by eq (12)
H = (A .* C - B.^2 ) - 0.04 * ((A + C).^2);
H = H ./ max(max(H));

% use build-in function to find the local maxima
%corner_points = imregionalmax(H,8);
%corner_points = H .* corner_points;

[h, w] = size(H);

% select the local maxima from every predefined window 
window_size = 6;
offset = floor(window_size / 2);
corner_points = zeros(h, w);
% pad the matrix so all the values (including the ones on the first and 
% last rows/columns) can be handled in the same way
padded_H = padarray(H, [offset, offset]);
for i = 1:h
    for j = 1:w
        i2 = i + window_size - 1;
        j2 = j + window_size - 1;
        
        % compare the elements in the window with the current element 
        % (center of the window); if there are any higher elements set the 
        % corner_point to zeros, otherwise set it to the value from H
        corner_points(i, j) = sum(sum(padded_H(i:i2, j:j2) > H(i, j))) == 0;
        corner_points(i, j) = corner_points(i, j) * H(i, j);
    end 
end

% find all the corner elements from the ones selected above that are
% above a threshold and return their positions
threshold = 100 * mean(mean(corner_points))
[r, c] = find(corner_points > threshold);

% plot the positions of the corners on the original image
figure, imshow(image);
hold on
plot(c, r, 'yo', 'LineWidth',1.5,...
    'MarkerSize',8);
hold off
drawnow


end






