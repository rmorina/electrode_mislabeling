%% 1.a
A = getA(21);
[U,S,V] = svd(A);
% figure;plot(U(:,1:4))
% title('First 4 columns of U')
% saveas(1,'../figures/1a1.jpg','jpg');
% figure;plot(V(:,1:4))
% title('First 4 columns of V')
% saveas(2,'../figures/1a2.jpg','jpg');
%% 1.b
kernel_widths = [11,21,31,41];
for i = 1:length(kernel_widths)
    A = getA(kernel_widths(i));
    [U,S,V] = svd(A);
    plot(diag(S))
    title(sprintf('Singular values at length %d',kernel_widths(i)));
    %saveas(1,sprintf('../figures/1b%d.jpg',i),'jpg');
end
%% 1.c
A = getA(21);
[U,S,V] = svd(A);
n = 100;
nnz = 1;  % Number of non-zero indices
idx = datasample(1:n, nnz, 'Replace', false);
x = zeros(n, 1);
x(idx) = 1;

% Apply blur kernel
y_true = A * x;
%% 1.c2
[U,S,V] = svd(A);
thr = 50;
SInver = S;
SInver(1:thr,1:thr) = inv(SInver(1:thr,1:thr));
x_hat = V * SInver' * U'* y_true;
figure(1);
tx = 0:n-1;
ty = 0:2:n-1;
plot(tx, x, 'k-', 'Linewidth', 1);
hold on;
plot(ty, y_true, 'ro');
plot(tx, x_hat, 'r-', 'Linewidth', 1);
title(sprintf('Inverse ground truth with threshold %d',thr))
%saveas(1,'../figures/1c2.jpg','jpg');
%% 1.c3
[U,S,V] = svd(A);
thr = 20;
SInver = zeros(size(S));
SInver(1:thr,1:thr) = inv(S(1:thr,1:thr));
U(:,thr+1:end) = 0;
V(:,thr+1:end) = 0;
x_hat = V * SInver' * U'* y_true;
% Plot original and sensed signals
figure(1);
tx = 0:n-1;
ty = 0:2:n-1;
plot(tx, x, 'k-', 'Linewidth', 1);
hold on;
plot(ty, y_true, 'ro');
plot(tx, x_hat, 'r-', 'Linewidth', 1);
title(sprintf('Inverse ground truth with threshold %d',thr))
%saveas(1,'../figures/1c3.jpg','jpg');
%% 1.c4
sigma = 0.1;
m = size(A,1);
y = y_true + sigma * randn(m, 1);
x_hat2 = V * SInver' * U'* y;
% Plot original and sensed signals
figure(2);
tx = 0:n-1;
ty = 0:2:n-1;
plot(tx, x, 'k-', 'Linewidth', 1);
hold on;
plot(ty, y, 'ro');
plot(tx, x_hat2, 'r-', 'Linewidth', 1);
title(sprintf('Inverse noisy signal with threshold %d',thr))
%saveas(2,'../figures/1c4.jpg','jpg');
%% 1.c5
thrs = linspace(5,25,11);
error=zeros(size(thrs));
for rep = 1:10
    indices = crossvalind('Kfold',size(y,1),5);
    for k = 1:5
        test = (indices == k);
        train = ~test;
        U_train = U(train,:);
        y_train = y(train);
        y_test = y(test);
        A_test = A(test,:);
        for i = 1:length(thrs)
            thr = thrs(i);  
            SInver = zeros(size(S));
            SInver(1:thr,1:thr) = inv(S(1:thr,1:thr));
            x_hat = V * SInver' * U_train'* y_train;
            error(i) = error(i) + norm(y_test - A_test*x_hat)^2;
        end
    end
end
error = error/(5*10);
plot(thrs,error)
xlabel('thresholds')
ylabel('error')
title('Validation results')
%saveas(1,'../figures/1c51.jpg','jpg');
%%
[~,minIndex] = min(error);
thr = thrs(minIndex);
SInver = zeros(size(S));
SInver(1:thr,1:thr) = inv(S(1:thr,1:thr));
x_hat = V * SInver' * U'* y;
figure;
tx = 0:n-1;
ty = 0:2:n-1;
plot(tx, x, 'k-', 'Linewidth', 1);
hold on;
plot(ty, y, 'ro');
plot(tx, x_hat, 'r-', 'Linewidth', 1);
title(sprintf('Inverse noisy signal with threshold %d',thr))
%saveas(1,'../figures/1c52.jpg','jpg');

