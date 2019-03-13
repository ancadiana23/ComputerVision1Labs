I_left = imread('./left.jpg');
I_right= imread('./right.jpg');
P = 3;
N = 50;

% outputs the stitched image in the figure
stitch(I_left, I_right, P, N);
