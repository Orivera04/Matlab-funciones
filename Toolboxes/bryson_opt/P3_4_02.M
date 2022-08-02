% Script p3_4_02.m; VDP for max range with uc=Vy/h, yf=0;
% s=[x y]' in units of h, t in units of h/V;   11/96, 6/16/02
%
clear; clear global; global yf; yf=0; name='zrmc'; N=20; 
s0=[0 0]'; tf=6; k=-.3; told=1e-5; tols=5e-4; mxit=30;
tu=tf*[0:1/N:1]'; th0=pi/3*[1:-2/N:-1]'; 
[t,th,s]=fopc(name,tu,th0,tf,s0,k,told,tols,mxit);
x=s(:,1); y=s(:,2); N1=length(x);
%
% Coord. tips of thrust vectors:
for i=1:N1 
    xt(i)=x(i)+1.5*cos(th(i)); yt(i)=y(i)+1.5*sin(th(i));
end
%
figure(1); clf; subplot(211); plot(x,y); grid; hold on 
for i=1:4:N1, pltarrow([x(i) xt(i)],[y(i) yt(i)],.3,'r','-');
end; hold off; axis([0 12 -1 3]); xlabel('x/h'); 
ylabel('y/h')
      

       
       