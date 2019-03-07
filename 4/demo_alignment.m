Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');

plot_matches(Ia,Ib);

[best_paramA, best_paramb, best_inlier_matrix, success_rates] = RANSAC(Ia,Ib,3,100);




% figuring out how many iterations we need
sum_success_rates = success_rates
for iteration = 2:10
    [best_paramA, best_paramb, best_inlier_matrix, success_rates] = RANSAC(Ia,Ib,3,100);
    sum_success_rates = sum_success_rates + success_rates;
end
avg_success_rates=sum_success_rates/10;
plot(1:size(avg_success_rates,2),avg_success_rates);
