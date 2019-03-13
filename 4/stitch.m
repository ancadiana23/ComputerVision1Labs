I_left = imread('left.jpg');
I_right = imread('right.jpg');

Ia = rgb2gray(I_left);
Ib = rgb2gray(I_right);

figure(1), imshow(Ia);
figure(2), imshow(Ib);

P = 3;
N = 5000;

% transforming image2 so that it fits image1
transformed_image = transform_image(Ib, Ia, P, N);
figure(3), imshow(transformed_image);

[paramA, paramb, best_inlier_matrix, success_rates] = RANSAC(Ib, Ia, P, N);

tform1 = paramA;
tform1(3,3) = 1;
tform1 = affine2d(tform1');
transormed = imwarp(Ib, tform1);

figure(4), imshow(transormed);

[h_left w_left] = size(Ia);
[h_right w_right] = size(transormed);
% top_left, top_right, bottom_right, bottom_left 
new_corners = round((paramA * [1 1; w_right 1;  w_right h_right;  1 h_right]')' ...
                    + paramb')
     
y1 =  min(new_corners(:, 2));
y2 =  max(new_corners(:, 2));
x1 =  min(new_corners(:, 1));
x2 =  max(new_corners(:, 1));

width = max(x2,w_left) - min(x1,1) + 1;
height = max(y2,h_left) - min(y1,1) + 1;

I_new = zeros([height, width]);
I_new(y1:y1 + h_right-1, x1:x1+w_right-1) = transormed;
I_new(1:h_left, 1:w_left) = Ia;
figure(6), imshow(uint8(I_new));

