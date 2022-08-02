function R = ex6tel(l,m,K);
%R = ex6tel(l,m,K)
% computes the R matrix for the CTMC in Example ex6:tel
%K switch capacity K; 
%l call arrival rate lambda;
%m call completion rate mu;
if isempty(l) | (l < 0)
msgbox('invalid entry for l'); R='error'; return;
elseif isempty(m) | (m < 0)
msgbox('invalid entry for m'); R='error'; return;
elseif isempty(K) | K < 0 | (K - fix(K) ~= 0)
msgbox('invalid entry for K');R='error'; return;
else
R = zeros(K+1,K+1);
R(1,2) = l;
R(K+1,K) = K*m;
for i = 2:K
R(i,i-1) = (i-1)*m;
R(i,i+1) = l;
end;
end;
