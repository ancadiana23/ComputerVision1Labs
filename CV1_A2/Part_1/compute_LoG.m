function imOut = compute_LoG(image, LOG_type)

switch LOG_type
    case 1
        %method 1
        smooth_im = imfilter(image, gauss2D(0.5 , 5));
        imOut = imfilter(smooth_im, fspecial('laplacian'));

    case 2
        %method 2
        imOut = imfilter(image, fspecial('log', [5, 5], 0.5));

    case 3
        %method 3
        im_gauss_1 = imfilter(image, gauss2D(0.5 , 5));
        im_gauss_2 = imfilter(image, gauss2D(5.0 , 5));
        imOut = im_gauss_1 - im_gauss_2;
end
end

