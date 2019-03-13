function [transformed_image] = transform_image(Ia, Ib, P, N)

% using the RANSAC function to get the best parameters
[paramA, paramb, inlier_matrix, success_rate] = RANSAC(Ia, Ib, P, N);

[h w] = size(Ib);
new_corners = round((paramA * [1 1; w 1;  w h;  1 h]')' ...
                    + paramb')

new_h = max(new_corners(:, 2)) - min(new_corners(:, 2))
new_w = max(new_corners(:, 1)) - min(new_corners(:, 1)) 


% initialize transformed_image
transformed_image = zeros([new_h new_w]);

[h,w] = size(Ib);

% paramb is the horizontal and vertical translation.
% here we add a rather large value, so we do not get negative indices,
% after transforming the image.
% If you get a out of index, becaus of negative indices, just increase the
% padding value
% Later on, the padding is removed.
padding = 300;
paramb_pad = paramb;

for j = 1:new_h
    for i = 1:new_w
        transformed_coordinates = (paramA*[i;j]) + paramb_pad;
        % nearest neighbor x-value (rounding to nearest integer)
        NN_transform_x = round(transformed_coordinates(1));
        % nearest neighbor y-value (rounding to nearest integer)
        NN_transform_y = round(transformed_coordinates(2));
        if NN_transform_x > 0 && NN_transform_x < w && ...
                NN_transform_y > 0 && NN_transform_y < h
            transformed_image(j, i) = double(Ib(NN_transform_y,NN_transform_x))/double(255);
        end
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
