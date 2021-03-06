P = 25;
N = 250;

Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');
size(Ia)
size(Ib)
% Demo for matched keypoints
figure('Name','Keypoint matching')
plot_matches(Ia,Ib);

% Demo for the image transformation
P = 25;
N = 250;

% transforming image2 so that it fits image1
transformed_image = transform_image(Ia, Ib, P, N);

figure('Name','Using Nearest Neighbors to align image 2')
imshow(transformed_image);

% transforming image1 so that it fits image2
transformed_image = transform_image(Ib, Ia, P, N);

figure('Name','Using Nearest Neighbors to align image 1')
imshow(transformed_image);


% Using the imwarp method from matlab:

% transforming image2 so that it fits image1
[paramA1, paramb1, ~, ~] = RANSAC(Ia,Ib, 25, 250);
paramA1
tform1 = paramA1;
tform1(3,3) = 1;
tform1 = affine2d(tform1)

transformed_image_imwarp_1 = imwarp(Ib, tform1);
figure('Name','Using Matlabs imwarp-function to align image 2')
imshow(transformed_image_imwarp_1);


% transforming image1 so that it fits image2
[paramA2, paramb2, ~, ~] = RANSAC(Ib,Ia, 25, 250);

tform2 = paramA2;
tform2(3,3) = 1;
tform2 = affine2d(tform2)

transformed_image_imwarp_2 = imwarp(Ia, tform2);
figure('Name','Using Matlabs imwarp-function to align image 1')
imshow(transformed_image_imwarp_2);

%P = 3;
N = 30;
% Plot for figuring out how many iterations we need
[best_paramA, best_paramb, best_inlier_matrix, success_rates] = RANSAC(Ia,Ib,P,N);
sum_success_rates = success_rates
for iteration = 2:10
    [best_paramA, best_paramb, best_inlier_matrix, success_rates] = RANSAC(Ia,Ib,P,N);
    sum_success_rates = sum_success_rates + success_rates;
end
avg_success_rates=sum_success_rates/10;
figure('Name','Investigating the average iterations needed ')
plot(1:size(avg_success_rates,2),avg_success_rates);
title('Number of Iterations vs. Average Success Rate')
xlabel('Number of iterations') 
ylabel('Average Success Rate') 



%{
Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');

plot_matches(Ia,Ib);

[best_paramA, best_paramb, best_inlier_matrix, success_rates] = RANSAC(Ia,Ib,P,N);



% figuring out how many iterations we need
sum_success_rates = success_rates;
for iteration = 2:10
    [best_paramA, best_paramb, best_inlier_matrix, success_rates] = RANSAC(Ia,Ib,P,N);
    sum_success_rates = sum_success_rates + success_rates;
end
avg_success_rates=sum_success_rates/10;
plot(1:size(avg_success_rates,2),avg_success_rates);


% Demo for the image trasformation
%}
