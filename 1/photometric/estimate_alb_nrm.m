function [ albedo, normal ] = estimate_alb_nrm( image_stack, scriptV, shadow_trick)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal

[h, w, ~] = size(image_stack);
if nargin == 2
    shadow_trick = true;
end

% create arrays for
%   albedo (1 channel)
%   normal (3 channels)
albedo = zeros(h, w);
normal = zeros(h, w, 3);

% for each point in the image array
%   stack image values into a vector i
%   construct the diagonal matrix scriptI
%   solve scriptI * scriptV * g = scriptI * i to obtain g for this point
%   albedo at this point is |g|
%   normal at this point is g / |g|
for y = 1:h
  for x = 1:w 
    i = image_stack(y, x, :);
    i = i(:);
    scriptI = diag(i);
    IV = scriptI * scriptV;
    Ii = scriptI * i;
    if shadow_trick
        [g, ~] = linsolve(IV, Ii);
    else
        [g, ~] = linsolve(scriptV, i);
    end
    % r should be == 3
    norm_g = norm(g);
    % should alwayds be in (0, 1]
    albedo(y, x) = norm_g;
    normal(y, x, :) = g / norm_g;
  end
end

end

