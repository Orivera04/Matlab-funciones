function erfun=efunc(a,b,h)
% CALL: erfun=efunc(a,b,h) create erfun=abs(y-exp(b))
%  with stepsize (b-a)/h; y is computed by Euler method
step=(b-a)/h;  % Step: 1, 2, 4, ... 32768 (n=15), ... 
y=1;
for J=1:step
 yn=(1+h)*y;
 y=yn;
end
erfun=abs(y-exp(b));