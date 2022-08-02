function c = ex6invcost(l,m,k,r,hc,oc,rev);

% Returns vector of cost rates where c(i) is the cost rate in state i for the Inventory Mgmt Sys.
% Usage:  l = arrival rate deliveries,
%         m = arrival rate of demands,
%         k = base stock,
%         r = order size.
%         hc = holding cost per unit time per machine
%         rev = revenue ( selling price - buying price) per machine;
%         oc = cost of placing an order

c = zeros(k+r+1,1);
c(1) = l*oc; 

for i = 1:k-r-1
  c(i+1) = l*oc + hc*i - rev*m;
end;

for i = max(k-r,1):k+r
  c(i+1) = hc*i - rev*m;
end;
