image = imread('./pingpong/0000.jpeg');
[H, r, c] = harris_corner_detector(image);

image = imread('./person_toy/00000001.jpg');
[H, r_0, c_0] = harris_corner_detector(image);

I_45 = imrotate(image, 45);
[H, r_45, c_45] = harris_corner_detector(I_45);

I_90 = imrotate(image, 90);
[H, r_90, c_90] = harris_corner_detector(I_90);

[h, w, channels] = size(image)
size(I_45)
size(I_90)

fprintf("diff")
sum(sum(r_0 ~= c_90))
sum(sum(c_0 ~= w - r_90))

figure, imshow(image)
hold on
plot(c_0, r_0, 'o');
plot(h - r_90, c_90, 'o');

hold off
drawnow
