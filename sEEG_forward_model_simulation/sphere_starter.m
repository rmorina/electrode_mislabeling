%% Starter code for source localization on spherical head models
clear;

dipole_L = 10;
dipole_grid = create_grid(dipole_L);

sensor_L = 15;
sensor_grid = create_grid(sensor_L);
m = sensor_L^2;

A = leadfield_matrix(dipole_grid, sensor_grid);

x = zeros(dipole_L^2, 1);
x(5^2+5+1) = 1;
sigma = 0.0;
y = A * x + sigma * randn(m, 1);

%% Code for l2-regularized least squares inverse solution

%dipole_L = ...;                    % Reset dipole_L to create the source space
%dipole_grid = create_grid(dipole_L);
%A = leadfield_matrix(dipole_grid, sensor_grid);


%% Plot reconstruction assuming solution is stored in x_hat

figure(1);
plot_x_hat(x_hat, thetas, phis);
