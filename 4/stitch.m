I_left = imread('left.jpg');
I_right = imread('right.jpg');

Ia = rgb2gray(I_left);
Ib = rgb2gray(I_right);

figure(1), imshow(Ia);
figure(2), imshow(Ib);


P = 3;
N = 1000;
% transforming image2 so that it fits image1
transformed_image = transform_image(Ia, Ib, P, N);
figure(3), imshow(transformed_image);

[paramA1, paramb1, best_inlier_matrix, success_rates] = RANSAC(Ib,Ia, P, N);
best_inlier_matrix
paramA1 = paramA1'
tform1 = paramA1;
tform1(3,3) = 1;
tform1 = affine2d(tform1);

transformed_image_imwarp_1 = imwarp(Ib, tform1);

figure(4), imshow(transformed_image_imwarp_1);

start = max([size(Ia, 1), size(transformed_image_imwarp_1, 1)]) - ....
        min([size(Ia, 1), size(transformed_image_imwarp_1, 1)]) + 1
stop = min([size(Ia, 2), size(transformed_image_imwarp_1, 2)])
size(Ia(start:end, 1:stop))
size(transformed_image_imwarp_1(:, 1:stop))
figure(5), plot_matches(Ia(start:end, 1:stop),transformed_image_imwarp_1(:, 1:stop));

%[matched_a, matched_b] = keypoint_matching(Ia, transformed_image_imwarp_1);
[h_left, w_left] = size(Ia);
[h_right, w_right] = size(transformed_image_imwarp_1);

%filter_matches = (w_left - matched_a(2, :) + matched_b(2, :)) < 300;
%matched_a = matched_a(:, filter_matches);
%matched_b = matched_b(:, filter_matches);

[x_diff, y_diff] = RANSAC_stitch(Ia, transformed_image_imwarp_1, P, N);
%x_diff = round(sum((w_left - matched_a(1, :) + matched_b(1, :))) / size(matched_a, 2))
%y_diff = round(sum((matched_a(2, :) - matched_b(2, :))) / size(matched_a, 2))

Ib_new = zeros(size(Ia));
if y_diff > 0
    aux = min([h_right + y_diff - 1, h_left]);
    aux2 = aux - y_diff + 1;
    Ib_new(y_diff:aux, 1:w_right - x_diff + 1) = transformed_image_imwarp_1(1:aux2, x_diff:end);
else
    Ib_new(1:h_right + y_diff + 1, 1:w_right - x_diff + 1) = transformed_image_imwarp_1(-y_diff:end, x_diff:end);
end


size(Ib_new)
size(Ia)
figure(6), montage([Ia Ib_new])


