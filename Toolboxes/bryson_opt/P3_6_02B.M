% Script p3_6_02b.m; VDP for max range with uc=Vy/h, and yf specified
% using FOPCB; tf=6, yf=0; s=[x y]' in units of h, t in units of h/V;
%                                                       4/97, 5/28/02
%
clear; clear global; global yf; yf=0; sf=[11.3053 0]; nu=-3;
s0=[0 0]'; tf=6; name='zrmc'; p=[sf nu]; 
optn=optimset('Display','Iter','MaxIter',15);
p=fsolve('fopcb',p,optn,name,s0,tf);
[f,t,y1]=fopcb(p,name,s0,tf); x=y1(:,1); y=y1(:,2);
%
figure(1); clf; plot(x,y); grid; axis([0 12 -3 6]); xlabel('x/h')
ylabel('y/h')
       

       
       