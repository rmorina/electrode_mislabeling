% test_generate_forward_model
% Parameters
eeg_num = 20;
seeg_num = 3;
noise_snr = 7;
sim_per_depth_electrode = 1000;

eeg_location = generateEEGLocation(eeg_num);
depth_electrode_location = generateSEEGLocation(seeg_num);
A = generateForwardModel(depth_electrode_location, eeg_location);
[d_train, d_test, labels] = generateRecordings(A, noise_snr, sim_per_depth_electrode);

% Classification
[ mus, sigmas, pis ] = fitGaussianModel(d_train, labels, seeg_num);
test_labels = nan(1, size(d_test, 2));
for i = 1 : size(d_test, 2)
    cur_test_point = d_test(:, i);
    test_labels(i) = findLabel(mus, sigmas, pis, cur_test_point);
end

%% Visualize the signals that are generated when each seeg is stimulated

cur_figure = 1;

x = 1 : eeg_num;
for j = 1 : seeg_num
    figure(cur_figure);
    for i = 1 : size(d_train, 2)
        cur_point = d_train(:, i);
        cur_label = labels(i);
        if cur_label == j
            plot(x, cur_point, 'blue');
            hold on;
        end
    end
    cur_figure = cur_figure + 1;
end