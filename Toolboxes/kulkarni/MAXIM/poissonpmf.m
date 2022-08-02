function y = poissonpmf(l,k)
%y = poissonpmf(l,k)
% computes y(i) = P(X = i-1) for i=1,...k+1, where X ~ Poisson(l) $rv. Range l \le 700.
if  l < 0  
   msgbox('invalid entry for l'); y='error';return;
elseif  l > 700  
msgbox('l is too large'); y='error';return;
elseif  (k < 0) | (fix(k) - k ~= 0)
msgbox('invalid entry for k'); y='error';return;
else
y = zeros(1,k+1);
y(1) =  exp(-l);
for i=2:1:k+1
y(i)=y(i-1)*l/(i-1);
end;
end;
