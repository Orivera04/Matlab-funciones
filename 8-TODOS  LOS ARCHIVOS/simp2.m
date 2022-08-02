function q = simp2(func,a,b,n)
% Implements Simpson's rule using for loop.
%
% Example call: q = simp2(func,a,b,n)
% Integrates user defined function 
% func from a to b, using n divisions
%
if (n/2)~=floor(n/2)
  disp('n must be even');break
end
h=(b-a)/n; s=0;
yl=feval(func,a);
for j=2:2:n
  x=a+(j-1)*h; ym=feval(func,x);
  x=a+j*h; yh=feval(func,x);
  s=s+yl+4*ym+yh;
  yl=yh;
end
q=s*h/3;
