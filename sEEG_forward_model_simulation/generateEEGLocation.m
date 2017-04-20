function elec = generateEEGLocation(num)

n = ceil(sqrt(num * 2))+1;
grid = create_grid(n);
elec = 9.2*grid(grid(:,3)> 0,:);
n = size(elec,1);
index = randperm(n);
elec = elec(index(1:num),:);
end
% % format for eegEletrodes:elecpos & labes
% load 'elec_pos_for_74easycap.mat'
% % For labels = ['Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','F8','T4','T6','Fz','Cz','Pz'];
% % The index is 
% First15index = [1:10,13:14,17:19];
% First15label = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','T7','T8','Fz','Cz','Pz'}';
% %% Preprocess the electrode positions
% pos = eegElecpos.elecpos;
% % centre to 0
% pos(:,1) = pos(:,1) - mean(pos(:,1));
% pos(:,2) = pos(:,2) - mean(pos(:,2));
% pos(:,3) = pos(:,3) - mean(pos(:,3));
% % r = 1;
% norms = sqrt(sum(pos.^2,2));
% pos = 9.2*pos./repmat(norms,1,3);
% %%
% if num < 15
%     index = randperm(74);
%     elec.elecpos = pos(index(1:15),:);  
%     elec.label = eegElecpos.label{index(1:15)};
% else
%     n = num - 15;
%     index = 1:74;
%     index(First15index)=[];
%     shuffle = randperm(index);
%     index = index(shuffle(1:n));
%     elec.elecpos = [pos(First15index,:);pos(index)];
%     elec.label = {First15label,eegElecpos.label(index)};
% end

