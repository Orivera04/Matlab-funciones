function u=fwave(nx,hx,nt,ht,init,initslope,lowb,hib,c)
% Solves hyperbolic equ'n, see page 218, e.g. wave equation. 
%
% Example call: u=fwave(nx,hx,nt,ht,init,initslope,lowb,hib,c)
% nx, hx are number and size of x panels
% nt, ht are number and size of t panels
% init is a row vector of nx+1 initial values of the function.
% initslope is a row vector of nx+1 initial derivatives of the function. 
% lowb is a column vector of nt+1 boundary values at the low value of x.
% hib is a column vector of nt+1 boundary values at hi value of x.
% c is a constant in the hyperbolic equation.
%
alpha=c*ht/hx
u=zeros(nt+1,nx+1);
u(:,1)=lowb; u(:,nx+1)=hib; u(1,:)=init;
for i=2:nx
  u(2,i)=alpha^2*(init(i+1)+init(i-1))/2+(1-alpha^2)*init(i) ...
  +ht*initslope(i);
end
for j=2:nt
  for i=2:nx
    u(j+1,i)=alpha^2*(u(j,i+1)+u(j,i-1))+(2-2*alpha^2)*u(j,i) ...
    -u(j-1,i);
  end
end
