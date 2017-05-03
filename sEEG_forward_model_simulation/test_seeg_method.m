% test_sEEG_method
% Parameters
source_num = 1;
recording_num = 3:3:15;
noise_snr = 10;
num_sensors = 7;

sim_per_depth_electrode = 1000;
all_d_train = cell(size(recording_num));
all_d_test = cell(size(recording_num));
for k = 1:length(recording_num)
%source_electrode_location = generateSEEGLocation(source_num);
source_electrode_location = [0.1,0.1,0.1];
recording_electrode_location = generateSEEGLocation(recording_num(k),'electrodes',num_sensors);
A = generateForwardModel(source_electrode_location, recording_electrode_location);
[d_train, d_test, labels] = generatesEEGRecordings(A, noise_snr, num_sensors, sim_per_depth_electrode);
all_d_train{k} = d_train;
all_d_test{k} = d_test;
% Classification
[ mus, sigmas, pis ] = fitGaussianModel(d_train, labels, recording_num(k));
test_labels = nan(1, size(d_test, 2));
for i = 1 : size(d_test, 2)
    cur_test_point = d_test(:, i);
    test_labels(i) = findLabel(mus, sigmas, pis, cur_test_point);
end
acc(k) = sum(test_labels == labels)/size(test_labels,2);
end
%% Visualize the signals that are generated when each seeg is stimulated

cur_figure = 1;

x = 1 : eeg_num;
for j = 1 : source_num
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