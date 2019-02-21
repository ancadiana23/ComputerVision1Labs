function G = gauss2D( sigma , kernel_size )
    G = gauss1D(sigma, kernel_size)' * gauss1D(sigma, kernel_size);
end
