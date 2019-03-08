P = 3;
N = 100;

Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');

% Demo for matched keypoints
figure
plot_matches(Ia,Ib);

% Demo for the image transformation

% transforming image2 so that it fits image1
transformed_image = transform_image(Ia, Ib, P, N);
figure
imshow(transformed_image);

% transforming image1 so that it fits image2
transformed_image = transform_image(Ib, Ia, P, N);
figure
imshow(transformed_image);


% Plot for figuring out how many iterations we need
[best_paramA, best_paramb, best_inlier_matrix, success_rates] = RANSAC(Ia,Ib,P,N);
sum_success_rates = success_rates
for iteration = 2:10
    [best_paramA, best_paramb, best_inlier_matrix, success_rates] = RANSAC(Ia,Ib,3,100);
    sum_success_rates = sum_success_rates + success_rates;
end
avg_success_rates=sum_success_rates/10;
figure
plot(1:size(avg_success_rates,2),avg_success_rates);




