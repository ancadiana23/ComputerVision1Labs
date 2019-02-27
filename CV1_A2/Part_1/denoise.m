function [ imOut ] = denoise( image, kernel_type, varargin)

switch kernel_type
    case 'box'
        % built in function imboxfilt for boxfiltering
        imOut = imboxfilt(image, varargin{1});
    case 'median'
        % built in function medfilt2 for medianfiltering
        imOut = medfilt2(image, varargin{1});
    case 'gaussian'
        % using gauss2d
        h = gauss2D(varargin{1}, varargin{2});
        imOut = imfilter(image, h);
end
end
