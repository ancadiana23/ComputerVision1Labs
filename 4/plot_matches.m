function [] = plot_matches(Ia,Ib)
    n_lines=10;

    Iab = [Ia Ib];
    
    [matched_a,matched_b] = keypoint_matching(Ia,Ib);
    
    imshow(Iab);
    n_matches = size(matched_a,2);
    perm = randperm(n_matches);
    shift = size(Ia,2)
    for i = 1:10
        % needlessly complicated color construction
        colscale = nthroot(n_lines,3); 
        r = (i/colscale^3 - floor(i/colscale^3));
        g = (i/colscale^2 - floor(i/colscale^2));
        b = (i/colscale - floor(i/colscale));

        match=perm(i);
        line([matched_a(1,match),shift+matched_b(1,match)],[matched_a(2,match),matched_b(2,match)],'Color',[r g b],'LineWidth',2);
    end
 end
