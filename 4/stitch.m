I_left = imread('left.jpg');
I_right = imread('right.jpg');

Ia = rgb2gray(I_left);
Ib = rgb2gray(I_right);

figure(1), imshow(Ia);
figure(2), imshow(Ib);

P = 5;
N = 5000;

% transforming image2 so that it fits image1
transformed = transform_image(I_left, I_right, P, N);
figure(3), imshow(transformed);

% get the image transformation prameters
[paramA, paramb, best_inlier_matrix, success_rates] = RANSAC(Ib, Ia, P, N);

% get the sizes of the different images
[h_left w_left, c] = size(I_left);
[h_right w_right, c] = size(I_right);
[h_t w_t, c] = size(transformed);

% compute the transformation of the following corners
% top_left, top_right, bottom_right, bottom_left 
new_corners = round((paramA * [1 1; w_right 1;  w_right h_right;  1 h_right]')' ...
                    + paramb')

% get the extremities of the transformed corners
y1 =  min(new_corners(:, 2));
y2 =  max(new_corners(:, 2));
x1 =  min(new_corners(:, 1));
x2 =  max(new_corners(:, 1));

% compute the size of the new image
% on each axis take the difference between the highest and lowest points
% in either the left image or the new transformd right image
width = max(x2,w_left) - min(x1,1) + 1;
height = max(y2,h_left) - min(y1,1) + 1;

% create the new image
I_new = zeros([height, width, c]);
% multiply the values of the pixels i the transformed image with 255 
% in oreder to be on the same scale as I_left
I_new(y1:y1 + h_t-1, x1:x1+w_t-1, :) = transformed * 255;
I_new(1:h_left, 1:w_left, :) = I_left;
figure(6), imshow(uint8(I_new));

