% Script p3_6_22f.m; A/C max final altitude glide using FOPCF; 
% s=[V ga h]'; u=alpha; h in l, V in  sqrt(g*l); alm=1/12; eta=.5; 
% V0=Vf=4; ga0=gaf=0;                                4/97, 8/14/02
%
la0=[3.6347 1.5886 1]; nu=[4.5535 2.2819]; p0=[la0 nu]; 
s0=[4 0 0]'; tf=30; name='gldc'; c=180/pi;
optn=optimset('Display','Iter','MaxIter',2); 
p=fsolve('fopcf',p0,optn,name,s0,tf); [f,t,y]=fopcf(p,name,s0,tf);
V=y(:,1); ga=y(:,2); h=y(:,3); lv=y(:,4); lg=y(:,5); eta=1/2;
al=lg./(2*eta*V.*lv); ke=V.^2/2; es=4.630^2/2;  N=length(t);
%
figure(1); clf; plot(ke,h,8,h(N),'ro',8,0,'ro',es*[1 1],...
   [-2.97 4.58],'r--',[es 8],[4.58 0],'r--',[es 8],...
   [-2.97 -7.55],'r--'); grid; axis([0 10 -9 5]); axis('square') 
xlabel('V^2/2gl'); ylabel('h/l')
%
figure(2); clf; subplot(211), plot(t,V,[0 tf],2.61*[ 1 1],'r--'); 
grid; ylabel('V'); subplot(212), plot(t,ga,[0 tf],-c*.0964*[1 1],...
   'r--'); grid; ylabel('\gamma (deg)'); xlabel('t*sqrt(g/l)')
%
figure(3); clf; subplot(211), plot(t,h,[0 tf],[4.58 -2.97],...
    'r--',[0 0],[0 4.58],'r--',tf*[1 1],[-2.97 -7.55],'r--');
grid; ylabel('h'); subplot(212), plot(t,c*al,[0 tf],.1457*c*[1 1],...
   'r--'); grid; ylabel('\alpha (deg)'); xlabel('t*sqrt(g/l)')

