function visualize(input_image)
[x,y,z] = size(input_image);
if z == 4
    % only grayscale option has 4 different channels
    subplot(2,2,1);
    imshow(input_image(:,:,1)), title('Lightness');
    subplot(2,2,2);
    imshow(input_image(:,:,2)), title('Average');
    subplot(2,2,3);
    imshow(input_image(:,:,3)), title('Luminosity');
    subplot(2,2,4);
    imshow(input_image(:,:,4)), title('Matlab: rgb2gray');
elseif z==3
    % Any other colorspace has one main picture with three different
    % channels
    subplot(2,2,1);
    imshow(input_image), title('Image in Colorspace ');
    subplot(2,2,2);
    imshow(input_image(:,:,1)), title('First channel');
    subplot(2,2,3);
    imshow(input_image(:,:,2)), title('Second channel');
    subplot(2,2,4);
    imshow(input_image(:,:,3)), title('Third channel');
end
end