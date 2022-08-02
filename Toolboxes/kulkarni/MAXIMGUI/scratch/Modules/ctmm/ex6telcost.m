function c = ex6telcost(l,m,K,hc,lc);

% Returns cost rate vector where c(i) is the cost rate in state i for a Telephone Switch
% Usage:  l = call arrival rate lambda;
%         m = call completion rate mu;
%         K = switch capacity K; 
%         hc = cost per unit time of holding a call ;
%         lc = cost of losing a call;

c = zeros(K+1,1);

for i = 0:K
  c(i+1) = i*hc;
end;

c(K+1) = c(K+1) + l*lc;