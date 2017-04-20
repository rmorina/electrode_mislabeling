%% add noise
noise_snr=20;
ideal_norm=norm(groundTruthMeasure(:));
noise_norm=sum(rand(elec_num,1).^2)^0.5;
var=10^(-noise_snr/20)*ideal_norm/noise_norm;
elec_signal=groundTruthMeasure + rand(elec_num,1)*var;