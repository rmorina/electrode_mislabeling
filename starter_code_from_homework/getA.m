function A = getA(kernel_width)
% Blur kernel
h = 0.5 + 0.5 * cos(linspace(-pi, pi, kernel_width));

% Sensing matrix - cyclic shifts of h form the rows of A.
n = 100;
h_cyclic = zeros(1, n);
kw_by_2 = floor(kernel_width / 2) + 1;
h_cyclic(1 : kw_by_2) = h(kw_by_2 : end);
h_cyclic(n-kw_by_2+2 : n) = h(1 : kw_by_2-1);
A = toeplitz(h_cyclic);
A = A(1:2:end, :);
end