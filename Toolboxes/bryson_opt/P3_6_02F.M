% Script p3_6_02f.m; VDP for max range with uc=Vy/h, and yf spec. using
% FOPCF; s=[x y]' in units of h, t in units of h/V;       4/97, 5/28/02
%
clear; clear global; global yf; yf=0; la0=[1 3]; nu=-3; s0=[0 0]'; 
tf=6; name='zrmc'; p=[la0 nu];
optn=optimset('Display','Iter','MaxIter',15);
p=fsolve('fopcf',p,optn,name,s0,tf);
[f,t,y1]=fopcf(p,name,s0,tf); x=y1(:,1); y=y1(:,2);
%
figure(1); clf; plot(x,y); grid; axis([0 12 -3 6]); xlabel('x/h')
ylabel('y/h')
       

       
       