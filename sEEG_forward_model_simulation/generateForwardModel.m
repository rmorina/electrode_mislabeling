function A = generateForwardModel(dipole_pos, sensor_pos)
% r1 = 8;   % Brain
% r2 = 8.2; % CSF
% r3 = 8.7; % Skull
% r4 = 9.2; % Scalp

n = size(dipole_pos,1); 
m = size(sensor_pos,1);
IsEEG = abs(get_r(sensor_pos(1,:)) - 9.2)< 1e-2;
rd = get_r(dipole_pos);
A = zeros(m,n);
if IsEEG
    for i = 1:n
        A(:,i) = leadfield_matrix(dipole_pos(i,:),sensor_pos,rd(i));
    end
else
    rs = get_r(sensor_pos);
    for i = 1:n
        for j = 1:m
            A(j,i) = leadfield_matrix(dipole_pos(i,:),sensor_pos(j,:),rd(i),rs(j));
        end
    end
end
end

function r = get_r(pos)
    r = sqrt(sum(pos.^2,2));
end
