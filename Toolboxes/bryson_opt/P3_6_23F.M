% Script p3_6_23f.m; A/C max altitude climb using FOPCF; s=[V ga h x]';
% u=alpha; h in l, V in  sqrt(g*l); alm=1/12; eta=.5; T=.2; V0=Vf=7;
% ga0=gaf=0;                                               4/97, 9/5/02
%
la0=[6.013 2.926 1]; nu=[8.274 3.450]; p0=[la0 nu]; s0=[7 0 0]';
tf=30; name='climb'; optn=optimset('Display','Iter','MaxIter',50); 
p=fsolve('fopcf',p0,optn,name,s0,tf); [f,t,y]=fopcf(p,name,s0,tf);
V=y(:,1); ga=y(:,2); h=y(:,3); lv=y(:,4); lg=y(:,5); eta=1/2;
al=lg./(2*eta*V.*lv); ke=V.^2/2; es=4.630^2/2; c=180/pi; N=length(t);
x=cumtrapz(t,V.*cos(ga));
%
figure(1); clf; plot(ke,h,[es 24.5],[27.96 13.78],'r--',[es 24.5],...
   [13.78 0],'r--',[es es],[13.78 27.96],'r--',24.5,0,'ro',24.5,...
   h(N),'ro'); grid; axis([0 30 0 30]); axis('square') 
xlabel('V^2/2gl'); ylabel('h/l')
%
figure(2); clf; subplot(211), plot(t,V,[0 tf],4.63*[ 1 1],'r--');
grid; ylabel('V'); subplot(212), plot(t,c*ga,[0 tf],c*.1023*[1 1],...
   'r--'); grid; ylabel('\gamma (deg)'); xlabel('t*sqrt(g/l)')
%
figure(3); clf; subplot(211), plot(t,h,[0 0],[0 13.78],'r--',...
   [tf tf],[27.96 14.18],'r--',[0 tf],[13.78 27.96],'r--'); grid
ylabel('h'); subplot(212), plot(t,c*al,[0 tf],c*.0466*[1 1],'r--'); 
grid; ylabel('\alpha (deg)'); xlabel('t*sqrt(g/l)')
%
figure(4); clf; subplot(211), plot(x,h); grid; ylabel('h/l')
xlabel('x/l')
