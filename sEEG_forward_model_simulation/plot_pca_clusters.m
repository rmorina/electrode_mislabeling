% % For seeg
% d_train = all_d_train{2}';
% n = 6;
% for i = 1:n
%     index = n*(1:1000) - i + 1;
%     [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED, MU] = pca(d_train(index,:));
%     centre = MU * COEFF(:,1:3);
%     X = SCORE(:,1:3) + repmat(centre,size(SCORE,1),1);
%     scatter3(X(:,1),X(:,2),X(:,3));
%     hold on
% end

%% For eeg
close all
d_train = all_d_train{3}';
num_eeg = size(d_train,2);
n = size(d_train,1)/1000;
for i = 1:n
    index = (i-1)*1000;
    [COEFF, SCORE, ~, ~, ~, MU] = pca(d_train(index+1:index+1000,:)); % doing pca on each label seperately
    centre = MU * COEFF(:,1:3);
    X = SCORE(:,1:3) + repmat(centre,size(SCORE,1),1);
    scatter3(X(:,1),X(:,2),X(:,3),'filled');
    hold on
end
%%
% For eeg, doing pca on the whole data set looks better. But it doesn't
% make sense? 
d_train = all_d_train{6}';
[COEFF, SCORE, ~, ~, ~, MU] = pca(d_train);
X = SCORE(:,1:3);
for i = 1:9
    index = (i-1)*1000;
    Xt = X(index+1:index+1000,:);
    scatter3(Xt(:,1),Xt(:,2),Xt(:,3),'filled');
    hold on
end
% saveas(1,sprintf('../figures/num_depth_%d_num_eeg_%d_conf3.fig',n,num_eeg))
%saveas(1,sprintf('../figures/set.fig'))