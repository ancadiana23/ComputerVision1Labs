% test gauss1D and gauss2D
I = imread('./images/image2.jpg');
%{
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

%-----------------------------------------------------------
% test gradient 
[Gx, Gy, G, theta] = compute_gradient(I);
G = uint8(G);
figure(1), imshow(G), title("Magnitute");
figure(2), imshow(Gx), title("Gx");
figure(3), imshow(Gy), title("Gy");
figure(4), imshow(theta), title("direction");


%{
% compare results with imgradient
[G_b, theta_b] = imgradient(I, 'sobel');
[Gx_b,Gy_b] = imgradientxy(I, 'sobel');
G_b = uint8(G_b);
figure(5), imshow(G_b);

diff_Gx = Gx(2:end-1, 2:end-1) ~= Gx_b(2:end-1, 2:end-1);
diff_Gy = Gy(2:end-1, 2:end-1) ~= Gy_b(2:end-1, 2:end-1);
if sum(diff_Gx(:)) ~= 0 || sum(diff_Gy(:)) ~= 0
    fprintf("Wrong Gx or Gy \n")
end

%figure(6), title("diff x"), imshow(Gx == Gx_b)
%figure(7), title("diff y"), imshow(Gy == Gy_b)

diff_mag = G(2:end-1, 2:end-1) ~= G_b(2:end-1, 2:end-1);
if sum(diff_mag(:)) ~= 0
    fprintf("Wrong magnitude \n")
end

diff_mag = G == G_b;
%figure(8), title("diff mag"), imshow(diff_mag);

diff_dir = theta ~= theta_b;
figure(9), title("diff dir"), imshow(diff_dir)
figure(10), imshow(theta_b);

figure(11), hist(theta(:))
figure(12), hist(theta_b(:))
%}
%}
%------------------------------------------------------
% test Laplacian 
for i=1:3
    str = sprintf("Second order derivative filter - method %d", i);
    fprintf(str + "\n");
    imOut = compute_LoG(I, i);
    max_val = max(max(imOut));
    imOut = imOut * (255.0 / max_val);
    figure(i*2), imshow(imOut), title(str);
    figure(i*2+1), hist(double(imOut(:))), title(str);
    
    
    drawnow();
end
