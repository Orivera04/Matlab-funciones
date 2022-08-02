% Script p4_5_14.m; VDP to cross a river w. a parabolic current
% uc=uo*(1-y^2/h^2); uo in V, (x,y) in h, t in h/V; uo=1;
%                                                    11/96, 7/16/02
%
clear; clear global; global xf yf; xf=0; yf=1; name='zrmpt';
th0=[.383 .582 .728 .835 .912 .967 1.008 1.036 1.055 1.065 1.069 ...
    1.065 1.055 1.036 1.008 .968 .912 .835 .728 .582 .383]';
tf=2.61; N=length(th0)-1; tu=tf*[0:1/N:1]'; s0=[0 -1]';
k=.1; told=1e-5; tols=1e-4; mxit=10;
[t,th,s,tf,nu,la0]=fopt(name,tu,th0,tf,s0,k,told,tols,mxit);
x=s(:,1); y=s(:,2); th=th*180/pi; 
%
figure(1); clf; plot(x,y,0,-1,'ro',0,1,'ro'); grid
axis([-1 1 -1 1]); axis('square'); xlabel('x'); ylabel('y')
%
figure(2); clf; subplot(211), plot(t,th); grid; xlabel('Vt/h')
ylabel('\theta (deg)');