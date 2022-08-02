function q=simp2v(func,a,b,c,d,n)
% Implements  2 variable Simpson integration.
%
% Example call: q=simp2v(func,a,b,c,d,n)
% Integrates user defined 2 variable function func, see page 154.
% Range for first variable is a to b, and second variable, c to d
% using n divisions of each variable.
%
if (n/2)~=floor(n/2)
  disp('n must be even');break
else
  hx=(b-a)/n; x=[a:hx:b];
  hy=(d-c)/n; y=[c:hy:d];
  z=feval(func,x,y);
  v=2*ones(n+1,1); v2=2*ones(n/2,1);
  v(2:2:n)=v(2:2:n)+v2;
  v(1)=1; v(n+1)=1;
  S=v*v'; T=z.*S;
  q=sum(sum(T))*hx*hy/9;
end
