


Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');


[matched_a,matched_b] = keypoint_matching(Ia,Ib);





i=1;

% calculate parameters
x1 = matched_a(1,1)
y1 = matched_a(2,1)
x2 = matched_b(1,1)
y2 = matched_b(2,1)

A = [x1 y1 0 0 1 0; 0 0 x1 y1 0 1]
b = [x2;y2]
params = pinv(A)*b

% this will be the RANSAC implementation
% P = 25 % should become function input
% n_matches = size(matched_a,2)
% perm = randperm(n_matches) ;
% sel = perm(1:P) 
% for i in sel
%     %compute params as above
% end



% % plotting matched keypoints
% imshow(Ia);
% I=Ia;
% h1 = vl_plotframe(matched_a) ;
% h2 = vl_plotframe(matched_a) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;

% % testing threshholds
% imshow(Ia)
% I=Ia;
% peak_thresh = 20
% [f,d] = vl_sift(I,'PeakThresh', peak_thresh) ;
% % [f,d] = vl_sift(I) ;
% h1 = vl_plotframe(f(:,:)) ;
% h2 = vl_plotframe(f(:,:)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;




% % the following lines are just the illustration from the websites
%I = vl_impattern('roofs1') ;
%image(I);
%I = single(rgb2gray(I)) ;
%[f,d] = vl_sift(I) ;
%perm = randperm(size(f,2)) ;
%sel = perm(1:50) ;
%h1 = vl_plotframe(f(:,sel)) ;
%h2 = vl_plotframe(f(:,sel)) ;
%set(h1,'color','k','linewidth',3) ;
%set(h2,'color','y','linewidth',2) ;
% h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
% set(h3,'color','g') ;

