grid1 = 2*create_grid(9);
grid2 = 2.5*create_grid(8);
grid = [grid1;grid2];
fig = figure;
scatter3(grid(:,1),grid(:,2),grid(:,3));
%clickA3DPoint(grid')
dcm_obj = datacursormode(fig);
set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on')
%%
f = getCursorInfo(dcm_obj);

%%
grid1 = 2*create_grid(9);
grid2 = 2.5*create_grid(8);
grid = [grid1;grid2];
fig = figure;
scatter3(grid1(:,1),grid1(:,2),grid1(:,3));
hold on
scatter3(grid2(:,1),grid2(:,2),grid2(:,3));
   c_info = zeros(6,3);
          for i = 1:6
              shg
              dcm_obj = datacursormode(1);
              set(dcm_obj,'DisplayStyle','window',...
                  'SnapToDataVertex','off','Enable','on')
              waitforbuttonpress
              c_info[i,:] = getCursorInfo(dcm_obj.position);
          end

