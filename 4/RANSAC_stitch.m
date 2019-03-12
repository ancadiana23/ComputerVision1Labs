function [best_x_diff, best_y_diff] = RANSAC_stitch(Ia,Ib,P,N)


[matched_a,matched_b] = keypoint_matching(Ia,Ib);
[h_left, w_left] = size(Ia);
[h_right, w_right] = size(Ib);

n_matches = size(matched_a,2);

best_n_inliers= 0;
best_x_diff = 0;
best_y_diff = 0;

for k = 1:N
    perm = randperm(n_matches) ;
    
    x_diff = round(sum((w_left - matched_a(1, perm(1:P)) + matched_b(1, perm(1:P)))) / P);
    y_diff = round(sum((matched_a(2, perm(1:P)) - matched_b(2, perm(1:P)))) / P);

    diff_matrix = zeros(size(matched_a, 2), 2);
    diff_matrix(:, 1) = matched_a(2, :) - matched_b(2, :) - y_diff;
    diff_matrix(:, 2) = w_left - matched_a(1, :) + matched_b(1, :) - x_diff;
    diff_vector = vecnorm(diff_matrix') < 10;
    sum(diff_vector);
    
    % Now if we have more inliers (aka better transformation approximation)
    % then before, we save all the data
    if sum(diff_vector) > best_n_inliers 
        best_n_inliers = sum(diff_vector);
        best_x_diff = x_diff;
        best_y_diff = y_diff;
    end
end