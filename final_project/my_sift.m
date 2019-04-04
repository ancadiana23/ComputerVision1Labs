%{
Parameters
----------
image : image (an mxnx3 array)
    the image in rgb format
variant: string 
    either 'keypoints' for keypoint sampling or 'dense' for dense sampling
sift_mode: string
    either 'gray', 'rgb' or 'opponent'

Return
----------
descriptors: 128xM-matrix
    these are the descriptors according to the sift_mode. row count 'm'
    depends on the 'sift_mode' and on image (in non-dense mode)
%} 
function [descr] = my_sift(image, variant, sift_mode)
% maybe use 'if strcmp(str1, str2)'?
if variant == "dense"
    [~, descr] =  vl_phow(single(squeeze(image)), 'Color', sift_mode)
    % Now we have to reshape the descriptor matrix from 384xm to 128x(mx3)
    if sift_mode == "rgb" | sift_mode == "opponent"
        descr = cat(2,descr(1:128,:), descr(129:256,:), descr(257:284,:))
    end
    
% Now we consider the case, where we only take keypoints. What is missing
% is the case for keypoints and "rgb", or "opponent".
elseif variant == "keypoints"
    if sift_mode == "gray"
        [~, descr] = vl_sift(single(rgb2gray(squeeze(image))))
    elsif sift_mode == "rgb"
        % [~, descr]
        % maybe reshaping necessary
    elsif sift_mode == "opponent"
        % [~, descr]
        % maybe reshaping necessary
    end
end
end