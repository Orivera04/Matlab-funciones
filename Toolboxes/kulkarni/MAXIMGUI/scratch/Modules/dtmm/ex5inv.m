function P = ex5inv(s,S,y);

%Output P = tr pr matrix for the inventory system problem.
%Usage: s = basestock level;
%       S = restocking level;
%       y = row vector of the demand pmf;

P = zeros(S-s+1,S-s+1);
si = size(y,2);

for i=0:min(si-1,S-s)
  P = P + y(i+1)*diag(ones(1,S-s+1-i), -i);
end;

P(S-s+1,S-s+1) = 0;
x = sum(P');
P(:,S-s+1) = ones(S-s+1,1)-x';
