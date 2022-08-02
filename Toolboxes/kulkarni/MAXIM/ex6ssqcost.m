function c = ex6ssqcost(l,m,K,hc,lc,bc);
%c = ex6ssqcost(l,m,K,hc,lc,bc)
%l arrival rate;
%m service rate m;
%K capacity;
%hc = cost og holding a customer for one time unit;
%lc = cost of losing a customer;
%bc = cost per unit time of keeping the server busy;
if l < 0 
msgbox('invalid entry for l'); R='error';return;
elseif  m < 0 
msgbox('invalid entry for m');R='error'; return;
elseif  K < 0 | K - fix(K) ~= 0
msgbox('invalid entry for K'); R='error';return;
else
   c=bc*ones(K+1,1);
   c(1)=0;
   for i=0:K
      c(i+1)=c(i+1) + i*hc;
   end;
   c(K+1)=c(K+1)+l*lc;
end;
