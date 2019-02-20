% Function should output a Figure displaying the original image, its 
% intrinsic images and the reconstructed one

% read input images 
albedo = imread('ball_albedo.png');
shading = imread('ball_shading.png');
original = imread('ball.png');

% scale shading elementwise by grayscales max value (255)
shading = double(shading)./255;

% Recover original image by element-wise multiplication
reconstruction = uint8(double(albedo).*shading);

% Plot images in one subplot
subplot(2,2,1)
imshow(shading)
title('Shading')

subplot(2,2,2)
imshow(albedo)
title('Albedo')

subplot(2,2,3)
imshow(reconstruction)
title('Reconstruction')

subplot(2,2,4)
imshow(original)
title('Original')