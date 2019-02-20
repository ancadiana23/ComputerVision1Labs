% recoloring an image
% Read the given images
albedo = imread("ball_albedo.png");
shading = imread("ball_shading.png");
ball = imread("ball.png");

% Get the true material color in RGB (one value per dimension, as it 
% is uniform (albedo has same color on circle, 0 in black region)

% maximum in each dimension as only black (0) or other value (uniform)
% appear
true_albedo_R = max(max(albedo(:,:,1)));
true_albedo_G = max(max(albedo(:,:,2)));
true_albedo_B = max(max(albedo(:,:,3)));

% true color in RGB: [184, 141, 108]
RGB_color = [true_albedo_R, true_albedo_G, true_albedo_B];

% Recolor the ball in the image with pure green (0,255,0)
% R and B 0 as it should be pure green
albedo(:,:,1) = 0;
albedo(:,:,3) = 0;
albedo(:,:,2) = 255;

% reconstruct by element wise multiplication (similar to iid image
% formation
shading = double(shading)./255;

% Recover original image by element-wise multiplication
recoloring = uint8(double(albedo).*shading);

% Plot images
subplot(1,2,1)
imshow(ball)
title('Original Image')

subplot(1,2,2)
imshow(recoloring)
title('Recolored Image')