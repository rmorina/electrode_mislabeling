function recover_display(J,source_space,source_position)
    figure
    J_norm = abs(J); % preallocate J_norm
    div=min(1,max(J_norm)/100);
    xs = source_space(:, 1);
    ys = source_space(:, 2);
    zs = source_space(:, 3);
    s = J_norm(:)/div; %turn S into a column vector
    scatter3(xs, ys, zs, s,  'o', 'filled');
    hold on
    scatter3(source_position(1),source_position(2),source_position(3),[],2,  'o','filled');   
end