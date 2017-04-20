%% Simple one-dimensional T-SVD example
clear;

% Blur kernel
kernel_width = 21; % Must be odd
h = 0.5 + 0.5 * cos(linspace(-pi, pi, kernel_width));

% Sensing matrix - cyclic shifts of h form the rows of A.
n = 100;
h_cyclic = zeros(1, n);
kw_by_2 = floor(kernel_width / 2) + 1;
h_cyclic(1 : kw_by_2) = h(kw_by_2 : end);
h_cyclic(n-kw_by_2+2 : n) = h(1 : kw_by_2-1);
A = toeplitz(h_cyclic);
A = A(1:2:end, :);
m = size(A, 1);

%% Random non-zero indices
nnz = 1;  % Number of non-zero indices
idx = datasample(1:n, nnz, 'Replace', false);
x = zeros(n, 1);
x(idx) = 1;

% Apply blur kernel
y_true = A * x;

% Add sensor noise
sigma = 0.1;
y = y_true + sigma * randn(m, 1);

% Plot original and sensed signals
figure(1);
tx = 0:n-1;
ty = 0:2:n-1;
plot(tx, x, 'k-', 'Linewidth', 2);
hold on;
plot(ty, y, 'ro');

%% T-SVD code goes here
