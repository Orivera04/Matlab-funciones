function q = simp1(func,a,b,n)
% Implements Simpson's rule using vectors.
%
% Example call: q = simp1(func,a,b,n)
% Integrates user defined function func from a to b, using n divisions
%
if (n/2)~=floor(n/2)
  disp('n must be even');break
end
h=(b-a)/n;
x=[a:h:b]; y=feval(func,x);
v=2*ones(n+1,1);
v2=2*ones(n/2,1);
v(2:2:n)=v(2:2:n)+v2;
v(1)=1; v(n+1)=1;
q=y*v;
q=q*h/3;
