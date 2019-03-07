run('vlfeat-0.9.21/toolbox/vl_setup') %one-time setup

Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');
Ia = single(Ia);
Ib = single(Ib);

h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;

[fa, da] = vl_sift(Ia) ;
[fb, db] = vl_sift(Ib) ;
[matches, scores] = vl_ubcmatch(da, db);



% the following lines are just the illustration from the websites
I = vl_impattern('roofs1') ;
image(I);
I = single(rgb2gray(I)) ;
[f,d] = vl_sift(I) ;
perm = randperm(size(f,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;



