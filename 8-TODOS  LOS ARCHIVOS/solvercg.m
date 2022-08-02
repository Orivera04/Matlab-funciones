function xdash=solvercg(a,b,n,tol)
% Solves linear system ax = b using conjugate gradient method.
%
% Example call: xdash=solvercg(a,b,n,tol)
% a is an n x n positive definite matrix, b is a vector of n coefficients
% tol is accuracy to which system is satisfied.
% WARNING Large, ill-conditioned systems will lead to reduced accuracy.
%
xdash=[ ]; gdash=[ ]; ddash=[ ]; qdash=[ ]; q=[ ];
mxitr=n*n;
xdash=zeros(n,1); gdash=-b; ddash=-gdash;
muinit=b'*b;
stop_criterion1=1;
k=0;
mu=muinit;
% main stage
while (stop_criterion1==1)
  qdash=a*ddash;
  q=qdash;
  r=ddash'*q;
  if (r==0),
    error('r=0,divide by 0!!!')
  end
  s=mu/r;
  xdash=xdash+s*ddash; gdash=gdash+s*q;
  t=gdash'*qdash; beta=t/r;
  ddash=-gdash+beta*ddash;
  mu=beta*mu;
  k=k+1;
  val=a*xdash;
  if((1-val'*b/(norm(val)*norm(b)))<=tol)&(mu/muinit<=tol),
    stop_criterion1=0;
  end
  if(k>mxitr)
    stop_criterion1=0;
  end
end
