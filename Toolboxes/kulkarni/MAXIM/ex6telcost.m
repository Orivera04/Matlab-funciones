function c = ex6telcost(l,m,K,hc,lc);
%c = ex6telcost(l,m,K,hc,lc)
% computes the R matrix for the CTMC in Example ex6:tel
%K switch capacity K; 
%l call arrival rate lambda;
%m call completion rate mu;
%hc = cost per unit time of holding a call ;
%lc = cost of losing a call;
if isempty(l) | (l < 0)
msgbox('invalid entry for l'); R='error'; return;
elseif isempty(m) | (m < 0)
msgbox('invalid entry for m'); R='error'; return;
elseif isempty(K) | K < 0 | (K - fix(K) ~= 0)
msgbox('invalid entry for K');R='error'; return;
else
   c=zeros(K+1,1);
   for i=0:K
      c(i+1)= i*hc;
   end;
   c(K+1)=c(K+1)+ l*lc;
end;
