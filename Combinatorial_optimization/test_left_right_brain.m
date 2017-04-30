addpath ../sEEG_forward_model_simulation/
load depthElecpos.mat % the original real eletrode position
% pre-processing, centre to 0, shrink size
elecpos(:,1) = elecpos(:,1) - mean(elecpos(:,1));
elecpos(:,2) = elecpos(:,2) - mean(elecpos(:,2));
elecpos(:,3) = elecpos(:,3) - mean(elecpos(:,3));
r = sqrt(sum(elecpos(:,1:3).^2,2));
elecpos(:,1:3) = 7/max(r) * elecpos(:,1:3); 
% praveen assmue size of brain is 8,so the eletrode is insize r=7
% electrode 2 is the one we assume we knew
source = [-0.1,-0.1,-0.1];
% If the sensor is too close to the source, this error will showup
% In zdipole_leadfield (line 66)
% In leadfield_matrix (line 45) 
% Warning: Rank deficient, rank = 0, tol = NaN. 
A = generateForwardModel(source, elecpos(:,1:3));
groundTruthMeasure = A' * 1000;
%% add noise
elec_num = size(elecpos,1);
noise_snr=20;
ideal_norm=norm(groundTruthMeasure(:));
noise_norm=sum(rand(elec_num,1).^2)^0.5;
var=10^(-noise_snr/20)*ideal_norm/noise_norm;
elec_signal=groundTruthMeasure' + rand(elec_num,1)*var;
%% generate depth electrode signals
num_depth = 7;
elec_signal = reshape(elec_signal,8,num_depth); % 6 depth eletrode, with 8 on each one
oneside = elec_signal(:,2);
elec_signal(:,4) = [];
elec_signal(:,2) = [];

%%
num = 2^size(elec_signal,2);
costs = zeros(num,1);
for i = 1:num
    side = bitget(i-1,size(elec_signal,2):-1:1,'uint8');
    le = getLocalEnergy(elec_signal,oneside,side);
    ce = getCrossEnergy(elec_signal,side);
    costs(i) = 0.5*le + ce;
end
%%
[~,index] = sort(costs);
side = bitget(index(1)-1,6:-1:1,'uint8')
side2 = bitget(index(2)-1,6:-1:1,'uint8')