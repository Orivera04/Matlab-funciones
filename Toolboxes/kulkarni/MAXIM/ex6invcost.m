function c = ex6invcost(l,m,k,r,hc,oc,rev);
%c = ex6invcost(l,m,k,r,hc,oc,rev)
%l arrival rate deliveries,
%m arrival rate of demands,
%k base stock,
%r order size.
%hc = holding cost per unit time per machine
%rev = revenue ( selling price - buying price) per machine;
% oc = cost of placing an order
if  (l < 0)
msgbox('invalid entry for l');c='error';return; 
elseif  (m < 0)
msgbox('invalid entry for m');c='error';return; 
elseif  k < 0 | (k - fix(k) ~= 0)
msgbox('invalid entry for k'); c='error';return; 
elseif  r < 0 | (r - fix(r) ~= 0)
msgbox('invalid entry for r'); c='error';return; 
else
   c=zeros(k+r+1,1);
   c(1)=l*oc; 
   for i=1:k-r-1
      c(i+1)=l*oc + hc*i - rev*m;
   end;
   for i=max(k-r,1):k+r
      c(i+1) = hc*i - rev*m;
      end;
end;
