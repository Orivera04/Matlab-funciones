function y = geometricpmf(p,k)
%y = geometricpmf(p,k)
% computes y(i) = P(X = i) for i=1,...k, where X ~ Geometric(p) $rv. Range 0 \le p \le 1.
if   p < 0 | p > 1 
msgbox('invalid entry for p');y='error'; return; 
elseif  k <= 0 | k - fix(k) ~= 0 
msgbox('invalid entry for k');y='error'; return;
else
y = zeros(1,k+1);
y(1) =  p;
for i=2:1:k+1
y(i)=y(i-1)*(1-p);
end;
end;
