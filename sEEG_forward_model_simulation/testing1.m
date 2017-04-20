%% get stereo-eeg electrodes
load depthElecpos.mat % the original real eletrode position
% pre-processing, centre to 0, shrink size
elecpos(:,1) = elecpos(:,1) - mean(elecpos(:,1));
elecpos(:,2) = elecpos(:,2) - mean(elecpos(:,2));
elecpos(:,3) = elecpos(:,3) - mean(elecpos(:,3));
r = sqrt(sum(elecpos(:,1:3).^2,2));
[~,r0index] = min(r);
sourceElectrode = elecpos(r0index,4);
elecpos(:,1:3) = 7/max(r) * elecpos(:,1:3); 
% praveen assmue size of brain is 8,so the eletrode is insize r=7
source = elecpos(r0index,:);
elecpos(elecpos(:,4) == sourceElectrode,:)=[];
r0 = min(r)/max(r); %source location
%%
elec_num = size(elecpos,1);
r = sqrt(sum(elecpos(:,1:3).^2,2));
A = zeros(1,elec_num);
for i = 1:elec_num
    A(i) = leadfield_matrix(source, elecpos(i,:), r0, r(i));
% If the sensor is too close to the source, this error will showup
% In zdipole_leadfield (line 66)
% In leadfield_matrix (line 45) 
% Warning: Rank deficient, rank = 0, tol = NaN. 
end
groundTruthMeasure = A' * 1000;
%% add noise
noise_snr=20;
ideal_norm=norm(groundTruthMeasure(:));
noise_norm=sum(rand(elec_num,1).^2)^0.5;
var=10^(-noise_snr/20)*ideal_norm/noise_norm;
elec_signal=groundTruthMeasure + rand(elec_num,1)*var;
%%
num_depth = 6;
elec_signal = reshape(elec_signal,8,num_depth); % 6 depth eletrode, with 8 on each one
groundTruthMeasure = reshape(groundTruthMeasure,8,num_depth);
label = zeros(num_depth,1);

% use corrcoef(elec_signal) find the last 3 has high correlation,we see
% them as a group
%% find the label for the first electrodes
for i = 1:3
    test = repmat(elec_signal(:,i),1,num_depth);
    dis = sum((test - groundTruthMeasure).^2);
    [~,pick] = min(dis);
    label(i) = elecpos(pick*8,4);
end
%% find the label for last 3 eletrodes
arrange = [1,2,3;1,3,2;2,1,3;2,3,1;3,1,2;3,2,1];
left_signal = elec_signal(:,4:6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Todo: find which labels are left and pick out the groundTruth signal, I
% just look at the data here.
left_ground = groundTruthMeasure(:,4:6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cor = zeros(6,1);  
% 6 is 3!, will become huge with more eletrodes, is this a problem?
% try different combinations
for i = 1:6
    ind = arrange(i,:);
    tmp = left_signal(:,ind);
    corr = corrcoef(tmp,left_ground);
    cor(i) = corr(2,1);
end
[~,ind] = max(cor);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To do: many magic numbers in this part!!!! Automated labeling  needed.
labels = arrange(ind,:) + 3;