function recover_display(J,source_space,activated)
 %   figure
    J_norm = abs(J); % preallocate J_norm
    div=min(1,max(J_norm)/100);
    xs = source_space(:, 1);
    ys = source_space(:, 2);
    zs = source_space(:, 3);
    s = J_norm(:)/div; %turn S into a column vector
    scatter3(xs, ys, zs, s,  'o', 'filled');
    hold on
    scatter3(source_space(activated,1),source_space(activated,2),source_space(activated,3),max(J_norm)+1,2,  'o','filled');   
end