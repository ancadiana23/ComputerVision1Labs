run('vlfeat-0.9.21/toolbox/vl_setup') %one-time setup

I = vl_impattern('roofs1') ;
image(I);

I = single(rgb2gray(I)) ;
[f,d] = vl_sift(I) ;