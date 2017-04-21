%Input : 
%   A : the forward model of size MxN
%   sigma_squared : covariance of the Normal distribution the function draws 
%   noise from. The dimension of the noise covariance is MxM
%   sim_per_depth_electrode : number of simulations for each depth electrode
%Output :
%   d_train : M x (N * sim_per_depth_electrode) matrix of simulated eeg 
%   electrodes with noise
%   d_test : M x (N * sim_per_depth_electrode) matrix of simulated eeg 
%   electrodes with noise
%   label : label vector to indicate the depth electrode source for columns 
%   d_train and d_test


function [ d_train, d_test, label ] = generateRecordings( A, sigma_squared, sim_per_depth_electrode )
    N = size(A,2); %number of depth electrodes
    M = size(A,1); %number of eeg electrodes
    num_col_of_d = N * sim_per_depth_electrode;
    d_train = zeros(M, num_col_of_d);
    d_test  = zeros(M, num_col_of_d);
    label = zeros(1, num_col_of_d);
       
    for node = 1 : N %looping through intracranial nodes
        f = zeros(N,1);
        f(node) = 1000;
        ground_truth = A*f;
        for rep = 1:sim_per_depth_electrode 
            % generate train data
            index = (node-1)*sim_per_depth_electrode + rep;
            noise = mvnrnd(zeros(1, M), sigma_squared*eye(M))';
           
            d_train(:,index) = ground_truth + noise;
            
            % generate test data
            noise = mvnrnd(zeros(1, M), sigma_squared*eye(M))';
            
            d_test(:, index) = ground_truth + noise;
            label(index) = node;
        end
    end

end

