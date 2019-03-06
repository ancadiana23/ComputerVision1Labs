image = imread('./person_toy/00000001.jpg');
[H, r, c] = harris_corner_detector(image);

imshow(image);
hold on
plot(c, r, 'o');
hold off