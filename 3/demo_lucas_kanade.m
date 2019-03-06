% set regionsize to 15x15
blocksize = 15;
% compute the optical flow for the synthetic images
im1 = imread('synth2.pgm');
im2 = imread('synth1.pgm');

% compute the optical flow vectors
Vy_Vx = lucas_kanade(im1, im2, blocksize);
[h,w] = size(imread('synth1.pgm'));

h = floor(h/blocksize) * blocksize;
w = floor(w/blocksize) * blocksize;

%Compute the meshgrid for the display of the vectors
start = floor(blocksize/2)+1;
[x,y] = meshgrid(start:blocksize:h,start:blocksize:w);

% display the image with the optical flow vectors.
figure
imshow(im1);
hold on;
q = quiver(x,y,Vy_Vx(:,:,1), Vy_Vx(:,:,2),'color',[1 0 0]);


% compute the optical flow using 'lucas_kanade.m' for the sphere-images
im1 = rgb2gray(imread('sphere2.ppm'));
im2 = rgb2gray(imread('sphere1.ppm'));

% Compute the optical flow vectors
Vy_Vx = lucas_kanade(im1, im2, blocksize);
[h,w] = size(rgb2gray(imread('sphere1.ppm')));
%display(Vx_Vy)
size(Vy_Vx(:,:,1)');
h = floor(h/blocksize) * blocksize;
w = floor(w/blocksize) * blocksize;

[x,y] = meshgrid(start:blocksize:h,start:blocksize:w);

% display the image with the optical flow vectors.
figure
imshow(imread('sphere2.ppm'));
hold on;
q = quiver(x,y,Vy_Vx(:,:,1), Vy_Vx(:,:,2),'color',[1 0 0]);
q.AutoScaleFactor = 1.;
q.LineWidth = 1.;

