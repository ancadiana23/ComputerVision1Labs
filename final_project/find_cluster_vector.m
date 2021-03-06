%{
Parameters
----------
C : CLUSTER_COUNTx128 matrix
    Each row contains a cluster centre.
descr: mx128 matrix
    Contains the descriptor data from one image
CLUSTER_COUNT: int (400, 1000, 4000)
    the number of cluster

Return
----------
cluster_vector: 1xCLUSTER_COUNT
    this contains the histogram and represents the 'words' of the image
%}  
function [cluster_vector] = find_cluster_vector(C, descr, CLUSTER_COUNT)
% here we create the cluster histogram
cluster_vector = zeros(1, CLUSTER_COUNT);
[descriptor_count, ~] = size(descr');
[~, idx_test] = pdist2(C,descr','euclidean', 'Smallest', 1);

for j = 1:descriptor_count
    idx = idx_test(j);
    %idx = get_closest_cluster(C, descr(j)');
    cluster_vector(idx) = cluster_vector(idx) + 1;
end
% Normalization of the histogram
cluster_vector = cluster_vector/descriptor_count;
end

%{
function [cluster_idx] = get_closest_cluster(C, single_descr)

cluster_idx = 1;
min_dist = norm(double(C(1) - single_descr), 2);

[cluster_count, ~] = size(C);

for j = 2:cluster_count
    if min_dist > norm(double(C(j)-single_descr),2)
        min_dist = norm(double(C(j)-single_descr),2);
        cluster_idx = j;
    end
    
end
end
%}