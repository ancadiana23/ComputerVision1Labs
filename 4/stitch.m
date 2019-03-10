I_left = imread('left.jpg');
I_right = imread('right.jpg');

Ia = rgb2gray(I_left);
Ib = rgb2gray(I_right);

figure(1), imshow(Ia);
figure(2), imshow(Ib);


P = 5;
N = 5000;
% transforming image2 so that it fits image1
transformed_image = transform_image(Ia, Ib, P, N);
[paramA1, paramb1, best_inlier_matrix, success_rates] = RANSAC(Ia,Ib, 25, 250);
figure(3), imshow(transformed_image);

paramA1
tform1 = paramA1;
tform1(3,3) = 1;
tform1 = affine2d(tform1)

transformed_image_imwarp_1 = imwarp(Ib, tform1);
figure
imshow(transformed_image_imwarp_1);

size(Ia(43:end, 39:end))
size(Ib)
figure(3), plot_matches(Ia(43:end, 39:end),Ib);
