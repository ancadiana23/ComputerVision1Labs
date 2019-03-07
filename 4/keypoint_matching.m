function [matched_a,matched_b] = keypoint_matching(Ia,Ib)

run('vlfeat-0.9.21/toolbox/vl_setup') %one-time setup

Ia = single(Ia);
Ib = single(Ib);

[fa, da] = vl_sift(Ia) ;
[fb, db] = vl_sift(Ib) ;

% if we want to include a threshold peak_thresh as function input:
%[fa, da] = vl_sift(Ia, 'PeakThresh', peak_thresh) ;
%[fb, db] = vl_sift(Ib, 'PeakThresh', peak_thresh) ;

[matches, scores] = vl_ubcmatch(da, db);

matched_a=fa(:,matches(1,:))
matched_b=fb(:,matches(2,:))

end




