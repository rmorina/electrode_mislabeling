function [ label ] = findLabel(mus, sigmas, pis, x)
% Finds the label that best describes the generation of x
    class_number = size(mus, 1);
    all_probabilities = nan(1, class_number);
    for i = 1 : class_number
        class_mu = mus{i, 1};
        class_sigma = sigmas{i, 1};
        class_pi = pis(i);
        class_prob = class_mu'*inv(class_sigma)*x - ...
            (1/2)*class_mu'*inv(class_sigma)*class_mu + log(class_pi);
        all_probabilities(i) = class_prob;
    end
    [v, label] = max(all_probabilities);
end

