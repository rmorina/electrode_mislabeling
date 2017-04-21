function [ mus, sigmas, pis ] = fitGaussianModel(X, Y, class_number)
    % Fit a Gaussian model for each class. Each class is modeled as a 
    % Gaussian with a mean and covariance. So the parameters that need to 
    % be estimated in this function are the mus and sigmas for each class.
    sigmas = cell(class_number, 1);
    mus = cell(class_number, 1);
    pis = nan(1, class_number);
    for i = 1 : class_number
        cur_class_ind = Y == i;
        class_training_points = X(:, cur_class_ind);
        class_mu = mean(class_training_points, 2);
        class_sigma = cov(class_training_points');
        pis(i) = size(class_training_points, 2)/size(X, 2);
        sigmas{i, 1} = class_sigma;
        mus{i, 1} = class_mu;
    end
end

