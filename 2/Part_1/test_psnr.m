 %
 % Calculate PSNR's 
 % Between image 1 and image1_saltpepper
 image1 = imread('images/image1.jpg');
 image1_saltpepper = imread('images/image1_saltpepper.jpg');
 image1_gaussian = imread('images/image1_gaussian.jpg');
 
 % 16.1079
 PSNR_image1 = myPSNR(image1, image1_saltpepper);
 
 % 20.5835
 PSNR_image1_2 = myPSNR(image1, image1_gaussian);

 % Denoisification
 filter = ["box", "median"];
 kernel_size = [3,5,7];
 noise_names = ["saltpepper", "gaussian"];
 ims = ["./images/image1_saltpepper.jpg", "./images/image1_gaussian.jpg"];
 stds = [1, 2, 3, 4, 5];
 std_labels = ["1", "2", "3", "4", "5"];
 
 % save images for denoising task
 
 for i = 1: length(ims)
     im = ims(i);
     im = imread(im);
     for j = 1:length(kernel_size)
         kernel = kernel_size(j);
         for k = 1:length(filter)
             filt = filter(k);
             if filt == "median"
                denoised_image = denoise(im, filt, [kernel, kernel]);
             end
             if filt == "gaussian"
                denoised_image = denoise(im, filt, stds(1), kernel);
             end
             if filt == "box"
                denoised_image = denoise(im, filt, kernel);
             end
             
             filename = noise_names(i) + "_" + filt + "_" + num2str(kernel,1);
             path = "./images/test/" + filename;
             imwrite(denoised_image, path+ ".png");
         end
     end
 end
 
 
 % save gaussian noise filtered by gaussian with different std and
 % kernelsize values
 
 im = ims(2);
 im = imread(im);
for j = 1:length(kernel_size)
    kernel = kernel_size(j);
    for k = 1:length(stds)
        std = stds(k);
        std_label = std_labels(k);
                   
        denoised_image = denoise(im, "gaussian", std, kernel);
                          
        psnr = myPSNR(image1, denoised_image);
        filename = noise_names(2) + "_" + std_label + "_" + num2str(kernel,1);
        path = "./images/gaussian_test/" + filename;
        head = char("std: " + num2str(std) + "; kernel: " + kernel + "; psnr = " +  num2str(psnr, 5));
        fig = imshow(denoised_image);
        title(head);
        saveas(fig, path, "png");
    end
end        

 