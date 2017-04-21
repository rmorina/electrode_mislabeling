% test_generate_forward_model
% Parameters
eeg_num = 20;
seeg_num = 3;
sigma_squared = 5;
sim_per_depth_electrode = 100;

eeg_location = generateEEGLocation(eeg_num);
depth_electrode_location = generateSEEGLocation(seeg_num);
A = generateForwardModel(depth_electrode_location, eeg_location);
[d_train, d_test, labels] = generateRecordings(A, sigma_squared, sim_per_depth_electrode);

% Classification
[ mus, sigmas, pis ] = fitGaussianModel(d_train, labels, seeg_num);
test_labels = nan(1, size(d_test, 2));
for i = 1 : size(d_test, 2)
    cur_test_point = d_test(:, i);
    test_labels(i) = findLabel(mus, sigmas, pis, cur_test_point);
end
