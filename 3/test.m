image = imread('./pingpong/0000.jpeg');
[H, r, c] = harris_corner_detector(image);

imshow(image);
hold on
plot(c, r, 'o');
hold off