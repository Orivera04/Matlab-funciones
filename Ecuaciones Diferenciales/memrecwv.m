function [u,x,y,t]= memrecwv(a,b,alp,w,x0,y0,tmax)
%
% [u,x,y,t]=memrecwv(a,b,alp,w,x0,y0,tmax)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This program illustrates wave motion in a 
% rectangular membrane subjected to a concentrated
% oscillatory force applied at an arbitrary 
% interior point. The membrane has fixed edges 
% and is initially at rest in an undeflected 
% position. The resulting response u(x,y,t)is
% computed and a plot of the motion is shown.
% a,b    -  side dimensions of the rectangle
% alp    -  wave propagation velocity in the
%           membrane
% w      -  frequency of the applied force. This
%           can be zero if the force is constant.
% x0,y0  -  coordinates of the point where
%           the force acts
% x,y,t  -  vectors of position and time values
%           for evaluation of the solution
% N,M    -  summation limits for the double 
%           Fourier series solution
% u      -  an array of size [length(y),...
%                          length(x),length(t)]
%           in which u(i,j,k) contains the
%           normalized displacement at 
%           y(i),x(j),t(k). The displacement is
%           is normalized by dividing by 
%           max(abs(u(:)))
%
% The solution is a double Fourier series 
% having the form 
%
% u(x,y,t)=Sum(A(n,m,x,y,t), n=1..N, m=1..M)
% where
% A(n,m,x,y,t)=sin(n*pi*x0/a)*sin(n*pi*x/a)*...
%              sin(m*pi*y0/b)*sin(m*pi*y/b)*...
%              (cos(w*t)-cos(W(n,m)*t))/...
%              ( w^2-W(n,m)^2)
% and the membrane natural frequencies are
% W(n,m)=pi*alp*sqrt((n/a)^2+(m/b)^2)

if nargin==0
  a=2; b=1; alp=1; tmax=3; w=13; x0=1.5; y0=0.5;
end
if a<b
   nx=31; ny=round(b/a*21); ny=ny+rem(ny+1,2);
else
   ny=31; nx=round(a/b*21); nx=nx+rem(nx+1,2);
end
x=linspace(0,a,nx); y=linspace(0,b,ny);

N=40; M=40; pan=pi/a*(1:N)'; pbm=pi/b*(1:M);
W=alp*sqrt(repmat(pan.^2,1,M)+repmat(pbm.^2,N,1));
wsort=sort(W(:)); wsort=reshape(wsort(1:30),5,6)';
Nt=ceil(40*tmax*alp/min(a,b)); 
t=tmax/(Nt-1)*(0:Nt-1);
  
% Evaluate fixed terms in the series solution  
mat=sin(x0*pan)*sin(y0*pbm)./(w^2-W.^2);
sxn=sin(x(:)*pan'); smy=sin(pbm'*y(:)');

u=zeros(ny,nx,Nt); 
for j=1:Nt
  A=mat.*(cos(w*t(j))-cos(W*t(j)));
  uj=sxn*(A*smy); u(:,:,j)=uj';
end