function y = geometriccdf(p,k)
%y = geometriccdf(p,k)
% computes y(i) = P(X <= i) for i=1,...k, where X ~ Geometric(p) $rv. 
if (k <= 0) | (k-fix(k)~=0)
   msgbox('illegal entry for k');y='error'; return;
elseif   p < 0 | p > 1 
   msgbox('invalid entry for p');y='error'; return;   
else   
for i=1:1:k
y(i)=1-(1-p)^i;
end;
end;