function R = ex6gms(l,m,N,M);

% Computes Rate matrix for General Machine Shop
% Usage: l = repair rate;
%        m = failure rate;
%        N = number of machines;
%        M = number of repair persons;

R = zeros(N+1,N+1);

for i = 0:N-1
  R(i+1,i+2) = l*min(N-i,M);
end

for i = 1:N
  R(i+1,i) = i*m;
end
