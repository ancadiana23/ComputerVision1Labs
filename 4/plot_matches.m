
Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');

Iab = [Ia Ib];

[matched_a,matched_b] = keypoint_matching(Ia,Ib);

n_lines=10;


imshow(Iab);
n_matches = size(matched_a,2);
perm = randperm(n_matches);
shift = size(Ia,2)
for i = 1:n_lines
    % needlessly complicated color construction
    colscale = nthroot(n_lines,3); 
    r = (i/colscale^3 - floor(i/colscale^3));
    g = (i/colscale^2 - floor(i/colscale^2));
    b = (i/colscale - floor(i/colscale));

    match=perm(i);
    line([matched_a(1,match),shift+matched_b(1,match)],[matched_a(2,match),matched_b(2,match)],'Color',[r g b],'LineWidth',2);
end



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
