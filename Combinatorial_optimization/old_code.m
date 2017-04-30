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
%% generate depth electrode signals
num_depth = 6;
elec_signal = reshape(elec_signal,8,num_depth); % 6 depth eletrode, with 8 on each one
groundTruthMeasure = reshape(groundTruthMeasure,8,num_depth);
com = perms(1:num_depth);
corrs = zeros(size(com,1),1);
for i = 1:size(com,1)
    corr = corrcoef(groundTruthMeasure,elec_signal(:,com(i,:)));
    corrs(i) = corr(1,2);
end
[~,index] = max(corrs);
labels = com(index,:);
