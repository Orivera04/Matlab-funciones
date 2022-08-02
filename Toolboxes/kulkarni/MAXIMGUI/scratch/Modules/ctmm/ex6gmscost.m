function c = ex6gmscost(l,m,N,M,r,dc,rc);

% Returns vector of cost rates when i machines are working
% Usage:  l = repair rate;
%         m = failure rate;
%         N = number of machines;
%         M = number of repair persons;
%         r = revenue per unit time from a working machine;
%         dc = cost of downtime per machine per unit time;
%         rc = repair time cost per unit time;

c = zeros(N+1,1);
for i = 0:N
  c(i+1) = rc*min(N-i,M) - i*r + (N-i)*dc;
end;
