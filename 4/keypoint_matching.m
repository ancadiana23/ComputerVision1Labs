function [matched_a,matched_b] = keypoint_matching(Ia,Ib)

% read the images into a suitable format
% Ia and Ib are already the matrix representing a gray image
Ia = single(Ia);
Ib = single(Ib);

% The vl_function computes relevant regions in both images
[fa, da] = vl_sift(Ia) ;
[fb, db] = vl_sift(Ib) ;

% if we want to include a threshold peak_thresh as function input:
%[fa, da] = vl_sift(Ia, 'PeakThresh', peak_thresh) ;
%[fb, db] = vl_sift(Ib, 'PeakThresh', peak_thresh) ;

% The vl_ubcmatch matches the corresponding regions of both images to the 
% points in the other image.
[matches, scores] = vl_ubcmatch(da, db);

% here we save the information about the relevant matching regions\pixel
% and return it as return-values.
matched_a=fa(:,matches(1,:));
matched_b=fb(:,matches(2,:));

end




