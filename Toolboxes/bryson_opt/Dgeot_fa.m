function [f,th,ph]=dgeot_fa(p,th0,thf,phf)                              
% Subroutine for Pb. 4.1.3a; DVDP for min distance between two points on
% a sphere using FSOLVE on the EL eqns; p=estimate of optimal [be nu dt];
% f=[Hu th-thf ph-phf Om]; s=[th ph]'; indpt. variable `t' is distance
% along path; APPROX SYSTEM EQUATIONS;                      12/96, 6/1/98
%
c=pi/180; N=length(p)-3; be=p([1:N]); nuth=p(N+1); nuph=p(N+2);
dt=p(N+3); th(1)=th0; ph(1)=0;
%
% Forward sequence:
for i=1:N, c=cos(be(i)); s=sin(be(i)); th(i+1)=th(i)+dt*s;
   ph(i+1)=ph(i)+dt*c/cos(th(i)); end
%
% Backward sequence:
la=[nuth nuph]'; for i=N:-1:1
 c=cos(be(i)); s=sin(be(i)); fs=[1 0; c*dt*sin(th(i))/cos(th(i))^2 1];
 fu=dt*[c; -s/cos(th(i))]; fd=[s; c/cos(th(i))]; Hu(i)=la'*fu;
 Hd(i)=la'*fd;  la=fs'*la; end; 
Om=N; for i=1:N, Om=Om+Hd(i); end;
f=[Hu th(N+1)-thf  ph(N+1)-phf  Om]; 