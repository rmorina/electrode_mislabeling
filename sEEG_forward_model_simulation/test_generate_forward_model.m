% test_generate_forward_model
% Parameters
eeg_num = 10:10:50;
seeg_num = 2;
noise_snr = 5:5:15;

all_accuracies = cell(1, length(noise_snr));
for n = 1 : length(noise_snr)
    snr_accuracies = nan(length(seeg_num), length(eeg_num));
    all_accuracies{1, n} = snr_accuracies;
end
sim_per_depth_electrode = 1000;

% index = randperm(64);
% all_eeg_locations = 9.2*create_grid(8);
all_d_train=cell(length(eeg_num),1);
all_seeg_locations=cell(length(seeg_num),1);
for n = 1 : 1
    cur_noise_snr = noise_snr(n);
    snr_accuracies = all_accuracies{1, n};
    for d = 1 : length(seeg_num)
        cur_seeg_num = seeg_num(d);
        depth_electrode_location = generateSEEGLocation(cur_seeg_num,'set');
        all_seeg_locations{d} = depth_electrode_location;
        for e = 1 : length(eeg_num)
            cur_eeg_num = eeg_num(e);
            fprintf('e = %d depth = %d snr % d\n', cur_eeg_num, cur_seeg_num, cur_noise_snr); 
            %eeg_location = all_eeg_locations(index(1:cur_eeg_num), :);
            eeg_location = generateEEGLocation(cur_eeg_num);
            A = generateForwardModel(depth_electrode_location, eeg_location);
            [d_train, d_test, labels] = generateRecordings(A, cur_noise_snr, sim_per_depth_electrode);
            all_d_train{e} = d_train;
            % Classification
            [ mus, sigmas, pis ] = fitGaussianModel(d_train, labels, cur_seeg_num);
            test_labels = nan(1, size(d_test, 2));
            for i = 1 : size(d_test, 2)
                cur_test_point = d_test(:, i);
                test_labels(i) = findLabel(mus, sigmas, pis, cur_test_point);
            end
            cur_accuracy = (sum(test_labels == labels)/length(labels))*100;
            snr_accuracies(d, e) = cur_accuracy;
        end
    end
    all_accuracies{1, n} = snr_accuracies;
end


%% Visualize the signals that are generated when each seeg is stimulated

cur_figure = 1;

% x = 1 : eeg_num;
% for j = 1 : seeg_num
%     figure(cur_figure);
%     for i = 1 : size(d_train, 2)
%         cur_point = d_train(:, i);
%         cur_label = labels(i);
%         if cur_label == j
%             plot(x, cur_point, 'blue');
%             hold on;
%         end
%     end
%     cur_figure = cur_figure + 1;
% end