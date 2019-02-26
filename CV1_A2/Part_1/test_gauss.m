X = [2 3 1 9]% test gauss1D and gauss2D
I = imread('./images/image1.jpg');

% computational complexity of convolutions:
% n = kernel_size; m = image_size
% 1D: O(2 x n x m x m)
% 2D: O(n x n x m x m)
F1d = gauss1D(2, 5);
F2d = gauss2D(2, 5);

conv2(F1d', F1d) == F2d;

I1 = conv2(F1d, I);
I1 = conv2(F1d', I1);
I2 = conv2(F2d, I);

% should be zero
sum(sum(abs(I1 - I2) > 0.001))