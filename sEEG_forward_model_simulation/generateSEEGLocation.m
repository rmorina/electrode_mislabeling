% function elec = generateSEEGLocation(num,specs,num_sensors)
% % 
% % specs can be 'same': source in the same hemisphere
% %              'random': in the whole brain
% %              'electrodes': instead of generating source
% if nargin == 1
%     specs = 'random';
% end
% 
% switch specs
%     case 'same'
%         n = ceil(sqrt(num*2));
%         grid = create_grid(n);
%         grid = grid(grid(:,3)>-0.1,:);
%         
%     case 'random'
%         n = ceil(sqrt(num));
%     case 'electrodes'
%         n = ceil(sqrt(num * 2)) + 1;
%         grid = create_grid(n);
%         grid = grid(grid(:,3)>0,:);
%         %r = repmat(5 + 0.5*rand(num,1),1,3);
%         r = repmat(5,1,3);
%         start = r .* grid(randperm(size(grid,1),num),:);
%         signs = (start >= 0) * 2 -1;
%         dir = signs .* rand(num,3);
%         r = repmat(2 + rand(num,1),1,3);
%         ends = start + r.* dir;
%         dis = (start - ends)/(num_sensors - 1);
%         elecx = (repmat(start(:,1),1,num_sensors) + dis(:,1) * (0:(num_sensors - 1)))';
%         elecy = (repmat(start(:,2),1,num_sensors) + dis(:,2)* (0:(num_sensors - 1)))';
%         elecz = (repmat(start(:,3),1,num_sensors) + dis(:,3)* (0:(num_sensors - 1)))';
%         elec = [elecx(:),elecy(:),elecz(:)];
%         return
%     case 'set'
%         location = [1.56294757065352,-1.95987426344580,0.572154641105791;...
%             0.605182717436156,-1.86256088643624,-0.636326766145979;...
%             0.518602672565031,1.59609490768848,-1.33834655796340;...
%             2.14932592316116,0,-0.698358326059035;...
%             2.19738633172152,0,-1.75235712464184;...
%             0.748308166609147,2.30305572510677,-0.786817769278513];
%         elec = location(1:num,:);
%         return
%     otherwise
%         elec = zeros(num,3);
%         return
% end
% grid1 = create_grid(n);
% grid2 = create_grid(n-1);
% grid3 = create_grid(n+1);
% grid = [grid1;grid2;grid3];
% grid = grid(grid(:,1)>0,:);
% r = repmat(2 + rand(num,1),1,3);
% elec = r .* grid(randperm(size(grid,1),num),:);
% 
% end

% function elec = generateSEEGLocation(num)
%     index = [2,4,3];
%     grid = 2*create_grid(9);
%     elec = grid(index(num),:);
% end

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
        n = ceil(sqrt(num))+1;
        grid = create_grid(n);
        grid = grid(grid(:,1)>0,:);
        elec = 3 * grid(randperm(size(grid,1),num),:);       
    case 'random'
        n = ceil(sqrt(num));
        grid = create_grid(n);
        elec = 3 * grid(randperm(size(grid,1),num),:);
    case 'electrodes'
        n = ceil(sqrt(num * 2)) + 1;
        grid = create_grid(n);
        grid = grid(grid(:,3)>0,:);
        %r = repmat(5 + 0.5*rand(num,1),1,3);
        r = repmat(5,1,3);
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
    case 'set'
        location = [1.56294757065352,-1.95987426344580,0.572154641105791;...
            0.605182717436156,-1.86256088643624,-0.636326766145979;...
            0.518602672565031,1.59609490768848,-1.33834655796340;...
            2.14932592316116,0,-0.698358326059035;...
            2.19738633172152,0,-1.75235712464184;...
            0.748308166609147,2.30305572510677,-0.786817769278513];
        elec = location(1:num,:);
        return
    case 'interactive'
%         grid1 = 2*create_grid(9);
        grid2 = 3*create_grid(10);
        fig = figure;
%         scatter3(grid1(:,1),grid1(:,2),grid1(:,3));
%         hold on
        scatter3(grid2(:,1),grid2(:,2),grid2(:,3));
        elec = zeros(6,3);
        for i = 1:num
              shg
              dcm_obj = datacursormode(fig);
              set(dcm_obj,'DisplayStyle','window',...
                  'SnapToDataVertex','off','Enable','on')
              waitforbuttonpress
              f = getCursorInfo(dcm_obj);
              elec(i,:) = f.Position;
        end
    otherwise
        elec = zeros(num,3);
        return
end


end
