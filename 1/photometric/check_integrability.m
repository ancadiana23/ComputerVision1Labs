function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives
% initalization
[h, w, ~] = size(normals);

p = zeros(h, w);
q = zeros(h, w);
dp = zeros(h, w);
dq = zeros(h, w);
SE = zeros(h, w);

% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
% q measures value of df / dy
p = normals(:, :, 1) ./ normals(:, :, 3);
q = normals(:, :, 2) ./ normals(:, :, 3);

% ========================================================================


p(isnan(p)) = 0;
q(isnan(q)) = 0;


% ========================================================================
% YOUR CODE GOES HERE
% approximate second derivate by neighbor difference
% and compute the Squared Errors SE of the 2 second derivatives SE
dp(:, 1) = p(:, 1);
dp(:, 2:end) = p(:, 2:end) - p(:,1:end-1);
dq(1, :) = q(1, :);
dq(2:end, :) = q(2:end, :) - q(1:end-1, :);

dp(isnan(dp)) = 0;
dq(isnan(dq)) = 0;

SE = (dp - dq).^2;
% ========================================================================


end

