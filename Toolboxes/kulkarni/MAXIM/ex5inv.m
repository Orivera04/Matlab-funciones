function P = ex5inv(s,S,y);
%P = ex5inv(s,S,y)
%s = basestock level;
%S = restocking level;
%y = row vector of the demand pmf;
%Output P = tr pr matrix for the inventory system problem.
[my ny]=size(y)
if  (s <0)|(s - fix(s) ~= 0)
msgbox('invalid entry for s');P = 'error'; return;
elseif (S <s) | S - fix(S) ~= 0 
msgbox('invalid entry for S');P = 'error';return; 
elseif  any(y < 0) | sum(y) > 1.000000000000001
msgbox('invalid entry for y');P = 'error';return;  
elseif my > 1
   msgbox('y must be a row vector'); P= 'error'; return;
else
P=zeros(S-s+1,S-s+1);
si = size(y);
for i=0:min(si(2)-1,S-s)
P=P + y(i+1)*diag(ones(1,S-s+1-i), -i);
end;
P(S-s+1,S-s+1) =0;
x=sum(P');
P(:,S-s+1) = ones(S-s+1,1)-x';


end;
