
function M = lincomb(v,A)

% Function lincomb formes the linear combination of
% matrices of the same size. Coefficients v = {v1 v2 ... vm}
% and the associated matrices A = {A1 A2 ... Am} must be
% inputted as cells.

m = length(v);
[k, l] = size(A{1});
M = zeros(k, l);
for i = 1:m
   M = M + v{i}*A{i};
end
