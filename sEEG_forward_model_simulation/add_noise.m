function x_noisy = add_noise(x, noise_snr)
    % Tiny wrapper to add AWGN noise for a given SNR.
    %
    % Inputs:
    %   x: Signal of interest.
    %   noise_snr: SNR of noise to add.
    % 
    % Outputs:
    %   x_noisy: Noisy version of x.
    
    noise = randn(size(x));
    
    noise_norm = norm(noise(:));
    xnorm = norm(x(:));
    
    noise = noise*10^(-noise_snr/20)*xnorm/noise_norm;
    
    x_noisy = x + noise;
end