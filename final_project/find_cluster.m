function [cluster_vector] = find_cluster(C, descr, cluster_size)

cluster_vector = zeros(1,cluster_size)
[descriptor_count, ~] = size(descr')
for j = 1:descriptor_count
    idx = get_closest_cluster(C, descr'(j))
    cluster_vector(idx) = cluster_vector(idx) + 1
    
end
end


function [cluster_idx] = get_closest_cluster(C, single_descr)

cluster_idx = 1
min_dist = norm(C(1)-single_descr, 2)

[cluster_count, ~] = size(C)

for j = 2:cluster_count
    if min_dist > norm(C(j)-single_descr,2)
        min_dist = norm(C(j)-single_descr,2)
        cluster_idx = j
    end
    
end
end