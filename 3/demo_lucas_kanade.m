% read images synth1.pgm and synth2.pgm
im1 = imread('synth2.pgm')
im2 = imread('synth1.pgm')
Vy_Vx = lucas_kanade(im1, im2);
[h,w] = size(imread('synth1.pgm'));
%display(Vx_Vy)
size(Vy_Vx(:,:,1));
h = floor(h/15) * 15;
w = floor(w/15) * 15;

[x,y] = meshgrid(8:15:h,8:15:w);

%size([x,y]);


figure
quiver(x,y,Vy_Vx(:,:,1), Vy_Vx(:,:,2))

% compute the optical flow using 'lucas_kanade.m'

im1 = rgb2gray(imread('sphere2.ppm'));
im2 = rgb2gray(imread('sphere1.ppm'));
%imshow(im1)
%imshow(im2)
Vy_Vx = lucas_kanade(im1, im2)
[h,w] = size(rgb2gray(imread('sphere1.ppm')));
%display(Vx_Vy)
size(Vy_Vx(:,:,1)');
h = floor(h/15) * 15;
w = floor(w/15) * 15;

[x,y] = meshgrid(8:15:h,8:15:w);

size([x,y]);


figure
quiver(y,x,Vy_Vx(:,:,2), Vy_Vx(:,:,1)')

% plot the quiver on top of the original image

% repeat for other images.

