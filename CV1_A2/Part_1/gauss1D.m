cdfunction G = gauss1D( sigma , kernel_size )
    G = zeros(1, kernel_size);
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    %% solution
    G = 1:1:kernel_size;
    G = floor(G - kernel_size/2);
    G = (1/(sigma * sqrt(2 * pi))) * exp((-G.^2) / (2 * sigma^2));
    G = G / sum(G);
end
