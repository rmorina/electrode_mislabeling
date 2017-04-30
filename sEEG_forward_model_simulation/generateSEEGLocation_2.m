function elec = generateSEEGLocation_2(num,specs)

load depthElecpos.mat % the original real eletrode position
% the fourth col is the label
% pre-processing, centre to 0, shrink size
elecpos(:,1) = elecpos(:,1) - mean(elecpos(:,1));
elecpos(:,2) = elecpos(:,2) - mean(elecpos(:,2));
elecpos(:,3) = elecpos(:,3) - mean(elecpos(:,3)) + 3;
r = get_r(elecpos);
elecpos(:,1:3) = 7/max(r) * elecpos(:,1:3); 
rs = [elecpos,r];
sorted_elec = sortrows(rs,[4,5]);
sorted_elec = sorted_elec(1:8*num,:);
index = (1:num)*8-7;
elec = sorted_elec(index,1:3);

% elec = zeros(num,3);
% elec(:,2) = 3 * rand(N,1) - 1.5;
% elec(:,2) = 3 * rand(N,1) - 1.5;
% switch specs
%     case 'same'
%         elec(:,1) = 1.5 * rand(N,1);
%     case 'random'
%         elec(:,1) = 3 * rand(N) - 1.5;
%     case 'real'      
        
        
end


    %% get stereo-eeg electrodes
%     load depthElecpos.mat % the original real eletrode position
%     % the fourth col is the label
%     % pre-processing, centre to 0, shrink size
%     elecpos(:,1) = elecpos(:,1) - mean(elecpos(:,1));
%     elecpos(:,2) = elecpos(:,2) - mean(elecpos(:,2));
%     elecpos(:,3) = elecpos(:,3) - mean(elecpos(:,3)) + 3;
%     r = get_r(elecpos);
%     % x location denoted the left or right hemisphere
%     elecpos(:,1:3) = 7/max(r) * elecpos(:,1:3); 
%     elec = [-2.229,1.659,0.4885;
%     1.512,1.582,-0.02828;
%     1.378,0.005295,0.0886];
%         [~,r0index] = sort(r);
%     sourceElectrode = elecpos(r0index,4);
%     % praveen assmue size of brain is 8,so the eletrode is insize r=7
%     source = elecpos(r0index,:);
%     elecpos(elecpos(:,4) == sourceElectrode,:)=[];
%     r0 = min(r)/max(r); %source location


function r = get_r(pos)
    r = sqrt(sum(pos(:,1:3).^2,2));
end