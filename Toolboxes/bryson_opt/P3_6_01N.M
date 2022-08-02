% Script p3_6_01n.m; VDP for max xf with gravity and specified yf
% using FOPCN; s=[V y x]';                          4/97, 9/14/02
%
clear global; clear; global name tu ts ns np yf; name='vdpc';
N=20; tf=1; tu=tf*[0:1/N:1]'; u=[1:-1/N:0]';  
yf=.3; s0=[0 0 0]'; k=-1; told=1e-4; tols=1e-4; mxit=10;
[t,u,s,nu,la0]=fopc(name,tu,u,tf,s0,k,told,tols,mxit);
u20=interp1(t,u,tu); p0=[u' nu]; 
optn=optimset('Display','Iter','MaxIter',15);
p=fsolve('fopcn',p0,optn,name,s0,tf); 
[f,s,la0]=fopcn(p,name,s0,tf); y=s(2,:); x=s(3,:);
[dum,N1]=size(s);
%
figure(1); clf; plot(x,-y,x,-y,'b.',x(N1),-y(N1),'ro',0,0,'ro');
grid; axis([0 .35 -.35 0]); axis('square'); ylabel('y/gt_f^2')
xlabel('x/gt_f^2')

