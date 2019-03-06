
fprintf("ping-pong \n")
image = imread('./pingpong/0000.jpeg');
[H1, r, c] = harris_corner_detector(image);

fprintf("toy \n")
image = imread('./person_toy/00000001.jpg');
[H2, r_0, c_0] = harris_corner_detector(image);

fprintf("toy 45 \n")
I_45 = imrotate(image, 45);
[H3, r_45, c_45] = harris_corner_detector(I_45);

fprintf("toy 90 \n")
I_90 = imrotate(image, 90);
[H4, r_90, c_90] = harris_corner_detector(I_90);

[h, w, channels] = size(image);

% Plot the corners found on the original photo and the ones found on the 
% images rotated by 90 degrees. They overlap.
figure, imshow(image);
hold on
plot(c_0, r_0, 'o');
plot(w - r_90 + 1, c_90, 'o');

hold off
drawnow
