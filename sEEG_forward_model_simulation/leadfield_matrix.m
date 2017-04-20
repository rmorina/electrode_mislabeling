function A = leadfield_matrix(dipole_grid, sensor_grid, r0, rs)
%% Function to compute the leadfield matrix between dipoles at points given
%  by dipole_grid and the sensors at points given by sensor_grid. Only the
%  (theta, phi) values of the grids matter. The radius of the dipoles should
%  be provided in r0 and the radius of the sensors in rs.
%
%  Inputs:
%    dipole_grid : array of size (num_dipoles, 3)
%      Array containing the (x, y, z) coordinates of dipole locations. All
%      dipoles are assumed to be located on the same sphere.
%    sensor_grid : array of size (num_sensors, 3)
%      Array containing the (x, y, z) coordinates of sensor locations. All
%      sensors are assumed to be located on the same sphere.
%    r0 : float
%      Radius of the dipole sphere
%    rs : float
%      Radius of the sensor sphere
%    r1 = 8 is the size of the brain
%
%  Returns:
%    A : array of size (num_sensors, num_dipoles)
%      The leadfield matrix corresponding to the given dipole- and sensor-
%      configuration
%
%  Notes:
%    If a leadfield matrix for dipoles and sensors of different radii is
%    desired, then this function will have to be called multiple times, once
%    for each dipole-sensor pair. Keep in mind that *all* dipoles must have
%    radii less than that of the innermost sensor.

% Compute cos(theta), for all angles theta between every dipole and sensor pair
dot_prod_matrix = sensor_grid * dipole_grid';
costheta_matrix = bsxfun(@rdivide, dot_prod_matrix, sqrt(sum(dipole_grid.^2, 2))');
costheta_matrix = bsxfun(@rdivide, costheta_matrix, sqrt(sum(sensor_grid.^2, 2)));

% Correct errors caused by limited floating-point precision, which result
% in |costheta| > 1 for some elements.
costheta_matrix(costheta_matrix > 1) = 1;
costheta_matrix(costheta_matrix < -1) = -1;
[num_sensors, num_dipoles] = size(costheta_matrix);

phi = zeros(numel(costheta_matrix), 1);

lmax = 30;
Cl = zdipole_leadfield(r0, rs);  % Compute Clm for dipole depth of 0.5mm.
Cl = Cl(1:lmax);
Clm = zeros(1, lmax^2);
l = 0:lmax-1;
Clm(l.^2+l+1) = Cl;

Ylm = compute_Ylm(lmax, costheta_matrix(:), phi);

A = reshape(Clm * Ylm, num_sensors, num_dipoles);
