%{
Parameters
----------
image : image (an mxnx3 array)
    the image in rgb format
variant: string 
    either 'keypoint' for keypoint sampling or 'dense' for dense sampling
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
    [~, descr] =  vl_phow(single(squeeze(image)), 'Color', sift_mode,  'Step', 16);
    % Now we have to reshape the descriptor matrix from 384xm to 128x(mx3)
    if sift_mode == "rgb" || sift_mode == "opponent"
        descr = cat(2,descr(1:128,:), descr(129:256,:), descr(257:384,:));
    end
    
% Now we consider the case, where we only take keypoints.
elseif variant == "keypoint"
    if sift_mode == "gray"
        [~, descr] = vl_sift(single(rgb2gray(squeeze(image))));
    elseif sift_mode == "rgb" || sift_mode == "opponent"
        image = squeeze(image);
        if sift_mode == "opponent"
            % the following transformation is taken from vl_phow to allow for
            % better comparability
            mu = 0.3*image(:,:,1) + 0.59*image(:,:,2) + 0.11*image(:,:,3);
            alpha = 0.01;
            size(image);
            image = cat(3, mu, ...
                 (image(:,:,1) - image(:,:,2))/sqrt(2) + alpha*mu, ...
                 (image(:,:,1) + image(:,:,2) - 2*image(:,:,3))/sqrt(6) ...
                 + alpha*mu);
        end
        size(image);
        [frames, ~] = vl_sift(single(rgb2gray(image)));
        size(vl_sift(single(image(:,:,1)), 'frames', frames));
        [~,descr1] = vl_sift(single(image(:,:,1)), 'frames', frames);
        [~,descr2] = vl_sift(single(image(:,:,2)), 'frames', frames);
        [~,descr3] = vl_sift(single(image(:,:,3)), 'frames', frames);
        descr = cat(2,descr1,descr2,descr3);
    end
end
end