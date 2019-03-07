function [best_paramA, best_paramb, best_inlier_matrix, success_rate] = RANSOC(Ia,Ib,P)

N = 400;


[matched_a,matched_b] = keypoint_matching(Ia,Ib);

n_matches = size(matched_a,2);
perm = randperm(n_matches) ;

% initialize matrix that stores the best inliers in columns as emtpy matrix
% -> (2, #best inliers) = size(inlier_matrix)
% it saves the coordinates of transformed points of image2
% that now lie in image1
best_inlier_matrix = [];
best_n_inliers= 0;
best_paramA= [];
best_paramb= [];


for j = 1:N
    perm = randperm(n_matches) ;
    current_best_inlier_matrix = [];
    A = zeros(2*P, 6);
    b = zeros(2*P, 1);
    for i=1:perm(1:P)
        x1 = matched_a(1,i);
        y1 = matched_a(2,i);
        x2 = matched_b(1,i);
        y2 = matched_b(2,i);


        A(i*2-1,:) = [x1 y1 0 0 1 0];
        A(i*2,:) = [0 0 x1 y1 0 1];
        b(i*2-1:i*2) = [x2 y2];
    end
    params = pinv(A)*b;

    n_inliers=0;
    paramA = [params(1) params(2); params(3) params(4)];
    paramb = [params(5) ; params(6)];
    for j = 1:n_matches
        x1 = matched_a(1,j);
        y1 = matched_a(2,j);
        x2 = matched_b(1,j);
        y2 = matched_b(2,j);
        deviation = paramA*[x1;y1] + paramb - [x2;y2];
        if norm(deviation)<=10
            n_inliers=n_inliers+1;
            current_best_inlier_matrix = [current_best_inlier_matrix.'; paramA*[x1;y1] + paramb].';
        end
    end
    n_inliers/n_matches; %print success rate
    if j==1 
        best_n_inliers=n_inliers;
        best_paramA=paramA;
        best_paramb=paramb;
        best_inlier_matrix = current_best_inlier_matrix;
    end
    if n_inliers>best_n_inliers 
        best_n_inliers=n_inliers;
        best_paramA=paramA;
        best_paramb=paramb;
        best_inlier_matrix = current_best_inlier_matrix;
    end
end

success_rate = best_n_inliers/n_matches




