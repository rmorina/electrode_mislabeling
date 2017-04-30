A = rand(4,4);
[U,S,V] = svd(A);
S_new = zeros(size(S));
S_new(1:3,1:3) = S(1:3,1:3);
A = U(:,1:3) * S_new * V(:,1:3)';