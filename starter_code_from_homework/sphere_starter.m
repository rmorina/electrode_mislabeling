%% Starter code for source localization on spherical head models
clear;
dipole_L = 10;
dipole_grid = create_grid(dipole_L);
sensor_L = 7;
sensor_grid = create_grid(sensor_L);
m = sensor_L^2;
A = leadfield_matrix(dipole_grid, sensor_grid);
x = zeros(dipole_L^2, 1);
x(10^2+10+1) = 1;
sigma = 0.0;
y = A * x + sigma * randn(m, 1);

%% Code for l2-regularized least squares inverse solution
dipole_L = 25;                    % Reset dipole_L to create the source space
[dipole_grid, thetas, phis] = create_grid(dipole_L);
A = leadfield_matrix(dipole_grid, sensor_grid);
lambdas = logspace(-6,-1,10);
error=zeros(size(lambdas));
for rep = 1:10
    indices = crossvalind('Kfold',size(y,1),5);
    for k = 1:5
        test = (indices == k);
        train = ~test;
        A_train = A(train,:);
        y_train = y(train);
        y_test = y(test);
        A_test = A(test,:);
        I = eye(min(size(A_train))); 
        for i = 1:length(lambdas)
            lambda = lambdas(i);            
            if size(A_train,1) >= size(A_train,2)
                x_hat = (A_train' * A_train + lambda * I) \ (A_train' * y_train);
            else
                x_hat = A_train' * ((A_train * A_train' + lambda * I) \ y_train);
            end
            error(i) = error(i) + norm(y_test - A_test * x_hat)^2;
        end
    end  
end
error = error/(5*10);
plot(lambdas,error)
set(gca,'XScale','log');

%% Plot reconstruction assuming solution is stored in x_hat
lambda = 1e-6;%1.3e-5;%
I = eye(min(size(A))); 
if size(A,1) >= size(A,2)
   x_hat = (A' * A + lambda * I) \ (A' * y);
else
   x_hat = A' * ((A * A' + lambda * I) \ y);
end
figure(1);
plot_x_hat(x_hat, thetas, phis);
%%
dipole_L_ori = 20;
[dipole_grid_ori,thetas_ori,phis_ori ]= create_grid(dipole_L_ori);
plot_x_hat(x, thetas_ori, phis_ori);
% recover_display(x_hat,dipole_grid,1)
% x_ori = 0.0001*ones(dipole_L_ori^2, 1)+x;
% hold on 
% recover_display(x_ori,dipole_grid_ori,5^2+5+1)
