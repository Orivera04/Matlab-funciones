function [f,v,x,y]=dvdpt_f(p)                              
% Subroutine for Pb. 4.1.1; DVDP for min time to a point with gravity 
% using FSOLVE on the EL eqns; p=estimate of optimal [ga nu dt];
% f=[Hu x-1 y-yf];  s=[v,x,y]'; (x,y,dl) in units of xf, v in sqrt(g*xf),
% dt in sqrt(xf/g);                                        12/96, 6/25/98
%
yf=1/3; N=length(p)-3; ga=p([1:N]); nux=p(N+1); nuy=p(N+2); dt=p(N+3);
v(1)=0; x(1)=0; y(1)=0;
%
% Forward sequence:
for i=1:N, c=cos(ga(i)); s=sin(ga(i));  dl=dt*(v(i)+.5*dt*s);
   v(i+1)=v(i)+s*dt; x(i+1)=x(i)+c*dl; y(i+1)=y(i)+s*dl; end
%
% Backward sequence:
la=[0 nux nuy]';
for i=N:-1:1, c=cos(ga(i)); s=sin(ga(i));
 fs=eye(3)+dt*[0 0 0; c 0 0; s 0 0  ];
 fu=dt*[c; -v(i)*s+dt*(.5-s^2); v(i)*c+dt*s*c];
 fd=[s; v(i)*c+dt*s*c; v(i)*s+dt*s^2]; 
 Hu(i)=la'*fu; Hd(i)=la'*fd;  la=fs'*la;
end;
Om=N; for i=1:N, Om=Om+Hd(i); end; f=[Hu  x(N+1)-1  y(N+1)-yf  Om]; 