function R = ex6mfg(l,m,k,K);
%R = ex6mfg(l,m,k,K)
%l production rate,
%m demand aret,
%k the mackhine is turned on when the inventory decreases to k,
%K storage capacity.
if  (l < 0)
msgbox('invalid entry for l');R='error';return; 
elseif (m < 0)
msgbox('invalid entry for m');R='error';return; 
elseif  k < 0 | (k - fix(k) ~= 0) | k >= K
msgbox('invalid entry for k');R='error';return; 
elseif  K < 0 | (K - fix(K) ~= 0)
msgbox('invalid entry for K');R='error';return; 
else
R=diag([l*ones(1,K) m*ones(1,K-k-1)],1) + diag([m*ones(1,K-1) zeros(1,K-k)],-1);
R(2*K-k,k+1)=m;
end;
