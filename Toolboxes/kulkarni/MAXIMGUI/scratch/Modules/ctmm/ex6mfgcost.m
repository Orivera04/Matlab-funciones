function c = ex6mfgcost(l,m,k,K,rev,hc,du);

% Returns cost rate vector where c(i) is the cost rate in state i for a Manufacturing System
% Usage:  l = production rate,
%         m = demand rate,
%         k = the mackhine is turned on when the inventory decreases to k,
%         K = storage capacity,
%         rev = net revenue from selling an item,
%         hc = cost of hoding an item for one unit f time,
%         du = cost of turning the machine on.

c = -m*rev*ones(2*K-k,1);
c(1) = 0;

for i = 0:K
  c(i+1) = c(i+1) + i*hc;
end;

for i = k+1:K-1
  c(2*K-i+1) = c(2*K-i+1) + i*hc;
end;

c(2*K-k) = c(2*K-k) + m*du;
