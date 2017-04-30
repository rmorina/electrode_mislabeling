function r = get_r(pos)
    r = sqrt(sum(pos(:,1:3).^2,2));
end