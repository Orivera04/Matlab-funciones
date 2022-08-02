function M = dtmcot(P,n)

% Computes the occupancy times matrix M(n) of the one step
% probability transition matrix P.

m = size(P, 1);
A = eye(m) ;
M = A ;
for r = 1:n
  A = A * P ;
  M = M + A ;
end;
