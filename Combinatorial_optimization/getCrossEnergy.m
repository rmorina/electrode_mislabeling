function ce = getCrossEnergy(elec_signal,side)
num_depth = size(elec_signal,2);
pos = permpos(2,num_depth);
corrs = zeros(length(pos),1);
for i = 1:length(pos)
    %corr = corrcoef(elec_signal(:,pos(i,:)));
    sig = elec_signal(:,pos(i,:));
    corr = norm(sig(:,1) - sig(:,2));
    if sum(side(pos(i,:))) == 1
        %corrs(i) = abs(corr(1,2));
        corrs(i) = 1/corr;
    else
        %corrs(i) = 1/abs(corr(1,2));
        corrs(i) = corr;
    end
end
ce = sum(corrs);
end