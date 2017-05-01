function elec = generateSEEGLocation(num,specs,num_sensors)
% 
% specs can be 'same': source in the same hemisphere
%              'random': in the whole brain
%              'electrodes': instead of generating source
if nargin == 1
    specs = 'random';
end

switch specs
    case 'same'
        n = ceil(sqrt(num*2));
    case 'random'
        n = ceil(sqrt(num));
    case 'electrodes'
        n = ceil(sqrt(num * 2)) + 1;
        grid = create_grid(n);
        grid = grid(grid(:,3)>0,:);
        r = repmat(5 + 0.5*rand(num,1),1,3);
        start = r .* grid(randperm(size(grid,1),num),:);
        signs = (start >= 0) * 2 -1;
        dir = signs .* rand(num,3);
        r = repmat(2 + rand(num,1),1,3);
        ends = start + r.* dir;
        dis = (start - ends)/(num_sensors - 1);
        elecx = (repmat(start(:,1),1,num_sensors) + dis(:,1) * (0:(num_sensors - 1)))';
        elecy = (repmat(start(:,2),1,num_sensors) + dis(:,2)* (0:(num_sensors - 1)))';
        elecz = (repmat(start(:,3),1,num_sensors) + dis(:,3)* (0:(num_sensors - 1)))';
        elec = [elecx(:),elecy(:),elecz(:)];
        return
    otherwise
        elec = zeros(num,3);
        return
end
grid1 = create_grid(n);
grid2 = create_grid(n-1);
grid3 = create_grid(n+1);
grid = [grid1;grid2;grid3];
grid = grid(grid(:,1)>0,:);
r = repmat(2 + rand(num,1),1,3);
elec = r .* grid(randperm(size(grid,1),num),:);

end

