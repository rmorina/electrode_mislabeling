function A = generateForwardModel(depth_electrode_location, eeg_location)
% r1 = 8;   % Brain
% r2 = 8.2; % CSF
% r3 = 8.7; % Skull
% r4 = 9.2; % Scalp

A = leadfield_matrix(dipole_grid, eeg_location, 5);


end
