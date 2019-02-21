% test gauss1D and gauss2D
I = imread('./images/image1.jpg');
imshow(I);
F1d = gauss1D(2, 5);
F2d = gauss2D(2, 5);

I1 = conv2(F1d, I);
I1 = conv2(F1d', I1);
I2 = conv2(F2d, I);

% should be zero
sum(sum(abs(I1 - I2) > 0.001))