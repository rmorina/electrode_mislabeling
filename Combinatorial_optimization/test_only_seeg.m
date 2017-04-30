%% get stereo-eeg electrodes
addpath ../sEEG_forward_model_simulation/
num_depth = 7;
num_sensors = 7;
%source = generateSEEGLocation(1);
source = [-0.1,-0.1,-0.1]; % if use other locations, may perform badly
elecpos = generateSEEGLocation(num_depth,'electrodes');
A = generateForwardModel(source, elecpos);
%% get signal
elec_num = size(elecpos,1);
groundTruthMeasure = A' * 1000;
noise_snr=20;
ideal_norm=norm(groundTruthMeasure(:));
noise_norm=sum(randn(elec_num,1).^2)^0.5;
var=10^(-noise_snr/20)*ideal_norm/noise_norm;
elec_signal=groundTruthMeasure + randn(size(groundTruthMeasure))*var;
%% the objective function
elec_signal = reshape(elec_signal,num_sensors,num_depth); % with num_sensors on each one
groundTruthMeasure = reshape(groundTruthMeasure,num_sensors,num_depth);
com = perms(1:num_depth);
corrs = zeros(size(com,1),1);
for i = 1:size(com,1)
 %   corr = corrcoef(groundTruthMeasure,elec_signal(:,com(i,:)));
 %   corrs(i) = corr(1,2);
    corrs(i) = norm(groundTruthMeasure-elec_signal(:,com(i,:)));
end
[~,index] = sort(corrs);
labels = com(index(1),:)
labels2 = com(index(2),:)
