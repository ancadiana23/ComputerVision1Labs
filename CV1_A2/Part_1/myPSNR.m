function [ PSNR ] = myPSNR( orig_image, approx_image )
 % log10 not working for unit8 -> conversion to double
 orig_image = im2double(orig_image);
 approx_image = im2double(approx_image);
 
 % Number of pixels in image: (m*n) -> dim(1)*dim(2) 
 dims = size(orig_image);
 total_pixels = dims(1) * dims(2);
 
 % Root mean squared error
 RMSE = sqrt(sum(sum((orig_image - approx_image).^2)) / total_pixels);
 
 % Maximum pixel value of the original image as I_max
 I_max = max(max(orig_image));
 
 % PSNR according to formula
 PSNR = 20 * log10(I_max/RMSE);
  
end

