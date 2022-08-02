function q = diffgen(func,n,x,h)
% Numerical differentiation.
%
% Example call: q = diffgen(func,n,x,h)
% Provides nth order derivatives, where n = 1 or 2 or 3 or 4
% of the user defined function func at the value x, using a step h.
%
if ((n==1)|(n==2)|(n==3)|(n==4))
  c=zeros(4,7);
  c(1,:)=[  0   1  -8     0   8   -1  0];
  c(2,:)=[  0  -1  16   -30  16   -1  0];
  c(3,:)=[1.5 -12  19.5   0 -19.5 12 -1.5];
  c(4,:)=[ -2  24 -78   112 -78   24 -2];
  y=feval(func,x+[-3:3]*h);
  q=c(n,:)*y'; q=q/(12*h^n);
else
  disp('n must be 1, 2, 3 or 4');break
end
