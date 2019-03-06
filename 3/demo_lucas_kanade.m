% read images synth1.pgm and synth2.pgm
Vx_Vy = lucas_kanade('sphere1.ppm', 'sphere2.ppm');

display(Vx_Vy)

% compute the optical flow using 'lucas_kanade.m'

% plot the quiver on top of the original image

% repeat for other images.

