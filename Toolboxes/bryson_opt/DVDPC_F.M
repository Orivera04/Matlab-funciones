function [f,v,x,y]=dvdpc_f(p)                              
% Subroutine for Pb. 3.1.1; DVDP for max range with gravity & yf spec;
% p=estimate of optimal [u nu]; f=[Hu y-yf]; s=[v,x,y]'; 12/96, 6/8/98
%
yf=.1; N=length(p)-1; u=p([1:N]); nu=p(N+1); tf=1; dt=tf/N;
v(1)=0; x(1)=0; y(1)=0;
%
% Forward sequence:
for i=1:N, c=cos(u(i)); s=sin(u(i)); dl=dt*(v(i)+.5*dt*s);
 v(i+1)=v(i)+s*dt; x(i+1)=x(i)+c*dl; y(i+1)=y(i)+s*dl; end
%
% Backward sequence:
la=[0 1 nu]'; for i=N:-1:1
 c=cos(u(i)); s=sin(u(i)); fs=eye(3)+dt*[0 0 0; c 0 0; s 0 0  ];
 fu=dt*[c; -v(i)*s+dt*(.5-s^2); v(i)*c+dt*s*c]; Hu(i)=la'*fu;
 la=fs'*la; end;
%
f=[Hu y(N+1)-yf]; 