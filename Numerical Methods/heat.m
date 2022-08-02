function u=heat(nx,hx,nt,ht,init,lowb,hib,K)
% Solves parabolic equ'n, see page 215, by implicit method. e.g. heat flow equation. 
%
% Example call: u=heat(nx,hx,nt,ht,init,lowb,hib,K)
% nx, hx are number and size of x panels
% nt, ht are number and size of t panels
% init is a row vector of nx+1 initial values of the function.
% lowb & hib are boundaries at low and hi values of x.
% Note that lowb and hib are scalar values.
% K is a constant in the parabolic equation.
%
alpha=K*ht/hx^2;
A=zeros(nx-1,nx-1); u=zeros(nt+1,nx+1);
u(:,1)=lowb*ones(nt+1,1);
u(:,nx+1)=hib*ones(nt+1,1);
u(1,:)=init;
A(1,1)=1+2*alpha; A(1,2)=-alpha;
for i=2:nx-2
  A(i,i)=1+2*alpha;
  A(i,i-1)=-alpha; A(i,i+1)=-alpha;
end
A(nx-1,nx-2)=-alpha; A(nx-1,nx-1)=1+2*alpha;
b(1,1)=init(2)+init(1)*alpha;
for i=2:nx-2, b(i,1)=init(i+1); end
b(nx-1,1)=init(nx)+init(nx+1)*alpha;
[L,U]=lu(A);
for j=2:nt+1
  y=L\b; x=U\y;
  u(j,2:nx)=x'; b=x; 
  b(1,1)=b(1,1)+lowb*alpha;
  b(nx-1,1)=b(nx-1,1)+hib*alpha;
end
