


Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');


[matched_a,matched_b] = keypoint_matching(Ia,Ib);



% this will be the RANSAC implementation
P = 25 % should become function input
n_matches = size(matched_a,2)
perm = randperm(n_matches) ;

first=1 % tells if we are in the first iteration
for i = perm(1:P)
    x1 = matched_a(1,i);
    y1 = matched_a(2,i);
    x2 = matched_b(1,i);
    y2 = matched_b(2,i);

    A = [x1 y1 0 0 1 0; 0 0 x1 y1 0 1];
    b = [x2;y2];
    params = pinv(A)*b;
    
    n_inliers=0
    paramA = [params(1) params(2); params(3) params(4)]
    paramb = [params(5) ; params(6)]
    for j = 1:n_matches
        x1 = matched_a(1,j)
        y1 = matched_a(2,j)
        x2 = matched_b(1,j)
        y2 = matched_b(2,j)
        deviation = paramA*[x1;y1] + paramb - [x2;y2]
        if norm(deviation)<=10
            n_inliers=n_inliers+1
        end
    end
    n_inliers/n_matches %print success rate
    if first==1 
        best_n_inliers=n_inliers
        best_paramA=paramA
        best_paramb=paramb
        first=0
    end
    if n_inliers>best_n_inliers 
        best_n_inliers=n_inliers
        best_paramA=paramA
        best_paramb=paramb
    end

    
end





