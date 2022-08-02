function y=ex8or(C,D,k,l,x)
%y=ex8or(C,D,k,l,x)
%C =  Cost of planned replacement.
%D =  Additional cost of unplanned replacement.
% Assume lifetime cdf G(.) is Erl(k,l)
% x is the row vector of possible replacement times.
y='error';
[mx nx]=size(x);
if mx ~=1 | any(x < 0)
   msgbox('invalid entry for x '); return;
   elseif k < 1 | k - fix(k) ~= 0 
      msgbox('k must be a positive integer'); return;
   elseif l < 0
      msgbox('l must be positive'); return;
      else
g=[];
for i= 1:nx
   T=x(i);
   %compute GT = G(T) and IGT = int_0^T(1-G(t))dt.
term = 1; sumgt =1; sumigt = k;
for n=1:k-1
term = term*l*T/n;
sumgt = sumgt + term;
sumigt = sumigt + (k-n)*term;
end;
gt = 1 - exp(-l*T)*sumgt;
igt = (1/l)*(k - exp(-l*T)*sumigt);
g=[g (C + D*gt)/igt];
end;
y=g;
plot(x,g)
end;


