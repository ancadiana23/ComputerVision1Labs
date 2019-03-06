image = imread('./pingpong/0000.jpeg');
[H, r, c] = harris_corner_detector(image);

image = imread('./person_toy/00000001.jpg');
[H, r, c] = harris_corner_detector(image);


I_45 = imrotate(image, 45);
[H, r, c] = harris_corner_detector(I_45);

I_90 = imrotate(image, 90);
[H, r, c] = harris_corner_detector(I_90);
