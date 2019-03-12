function [transformed_image] = transform_image(Ia, Ib, P, N)

% using the RANSAC function to get the best parameters
[paramA, paramb, inlier_matrix, success_rate] = RANSAC(Ia, Ib, P, N);

% initialize transformed_image
transformed_image = [];

[h,w] = size(Ib);

% paramb is the horizontal and vertical translation.
% here we add a rather large value, so we do not get negative indices,
% after transforming the image.
% If you get a out of index, becaus of negative indices, just increase the
% padding value
% Later on, the padding is removed.
padding = 300;
paramb_pad = paramb + padding;

for j = 1:h
    for i = 1:w
        transformed_coordinates = (paramA*[i;j]) + paramb_pad;
        % nearest neighbor x-value (rounding to nearest integer)
        NN_transform_x = floor(transformed_coordinates(1) + 0.5);
        % nearest neighbor y-value (rounding to nearest integer)
        NN_transform_y = floor(transformed_coordinates(2) + 0.5);
        transformed_image(NN_transform_y, NN_transform_x) = double(Ib(j,i))/double(255);
    end
end

% Here we cut out the unnecessary padding
% if in the results there is too much cut away at the border, this
% may be the reason. If you want, you can also remove the unnecessary 
% padding rows and columns by hand
transformed_image = transformed_image(any(transformed_image,2), :);
transformed_image = transformed_image(:,any(transformed_image,1));

%transformed_image = transformed_image(any(transformed_image,2),any(transformed_image,2) );
end
