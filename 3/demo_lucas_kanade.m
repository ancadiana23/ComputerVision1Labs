% set regionsize to 15x15
blocksize = 5
% compute the optical flow for the synthetic images
im1 = imread('synth2.pgm');
im2 = imread('synth1.pgm');
Vy_Vx = lucas_kanade(im1, im2, blocksize);
[h,w] = size(imread('synth1.pgm'));
%display(Vx_Vy)
size(Vy_Vx(:,:,1));
h = floor(h/blocksize) * blocksize;
w = floor(w/blocksize) * blocksize;

start = floor(blocksize/2)+1
[x,y] = meshgrid(start:blocksize:h,start:blocksize:w);


figure
imshow(im1);
hold on;
q = quiver(x,y,Vy_Vx(:,:,1), Vy_Vx(:,:,2),'color',[1 0 0]);


% compute the optical flow using 'lucas_kanade.m' for the sphere-images
im1 = rgb2gray(imread('sphere2.ppm'));
im2 = rgb2gray(imread('sphere1.ppm'));
%imshow(im1)
%imshow(im2)
Vy_Vx = lucas_kanade(im1, im2, blocksize);
[h,w] = size(rgb2gray(imread('sphere1.ppm')));
%display(Vx_Vy)
size(Vy_Vx(:,:,1)');
h = floor(h/blocksize) * blocksize;
w = floor(w/blocksize) * blocksize;

[x,y] = meshgrid(start:blocksize:h,start:blocksize:w);

size([x,y]);


figure
imshow(imread('sphere2.ppm'));
hold on;
q = quiver(x,y,Vy_Vx(:,:,1), Vy_Vx(:,:,2),'color',[1 0 0]);
q.AutoScaleFactor = 1.;
q.LineWidth = 1.;

