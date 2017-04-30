function [ d_train, d_test, label ] = generatesEEGRecordings( A, noise_snr, num_elec_on_depth,sim_per_depth_electrode )
    num_source = size(A,2); %number of source electrodes (1)
    num_recording = size(A,1)/num_elec_on_depth; %number of depth seeg electrodes  
    num_col_of_d = num_recording * sim_per_depth_electrode;
    d_train = zeros(num_elec_on_depth, num_col_of_d);
    d_test  = zeros(num_elec_on_depth, num_col_of_d);
    label = zeros(1, num_col_of_d);
    
    for node = 1 : num_source %looping through source
        f = zeros(num_source,1);
        f(node) = 100;
        ground_truth = A*f;
        for rep = 1:sim_per_depth_electrode 
            % generate train data
            index = (node-1)*sim_per_depth_electrode + num_recording*(rep-1)+1;
            %noise = mvnrnd(zeros(1, M), sigma_squared*eye(M))';
            %d_train(:,index) = ground_truth + noise;
            noise_signal = reshape(add_noise(ground_truth, noise_snr),...
                num_elec_on_depth,num_recording);
            
            d_train(:,index:index + num_recording - 1) = noise_signal;
            % generate test data
            %noise = mvnrnd(zeros(1, M), sigma_squared*eye(M))';
            %d_test(:, index) = ground_truth + noise;
            noise_signal = reshape(add_noise(ground_truth, noise_snr),...
                num_elec_on_depth,num_recording);
            d_test(:, index:index + num_recording - 1) = noise_signal;
            label(index:index + num_recording - 1) = 1:num_recording;
        end
    end

end