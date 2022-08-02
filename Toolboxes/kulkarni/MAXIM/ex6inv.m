function R = ex6inv(l,m,k,r);
%R = ex6inv(l,m,k,r)
%l arrival rate deliveries,
%m arrival rate of demands,
%k base stock,
%r order size.
if  (l < 0)
msgbox('invalid entry for l');R='error';return; 
elseif  (m < 0)
msgbox('invalid entry for m');R='error';return; 
elseif  k < 0 | (k - fix(k) ~= 0)
msgbox('invalid entry for k'); R='error';return; 
elseif  r < 0 | (r - fix(r) ~= 0)
msgbox('invalid entry for r'); R='error';return; 
else
R = diag(m*ones(1,k+r),-1) + diag(l*ones(1,k+1),r);
end;
