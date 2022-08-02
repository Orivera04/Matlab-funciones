% Script p3_6_23m.m; A/C max altitude climb using FOPCFM (MULTI-SHOOTING);
% s=[V ga h x]'; u=alpha; h in l, V in sqrt(g*l); alm=1/12; eta=.5; T=.2;
% V0=Vf=7; ga0=gaf=0; intermediate time t1;                  6/97, 5/28/02
%
s0=[7 0 0 0]'; t1=15; tf=30; name='climb'; nu=[8.27 3.45];
la0=[6.01  2.926 1 0]; y1=[4.474 .1076  20.37 74.40 4.50 1.03 1 0];
p0=[la0 nu y1]; optn=optimset('Display','Iter','MaxIter',50); 
p=fsolve('fopcfm',p0,optn,name,s0,t1,tf); [f,t,y]=fopcfm(p,name,s0,t1,tf);
V=y(:,1); ga=y(:,2); h=y(:,3); lv=y(:,5); lg=y(:,6); eta=1/2;
al=lg./(2*eta*V.*lv); ke=V.^2/2; es=4.630^2/2; c=180/pi; N=length(t);
%
figure(1); clf; plot(ke,h,[es 24.5],[27.96 13.78],'r--',[es 24.5],...
   [13.78 0],'r--',[es es],[13.78 27.96],'r--',24.5,0,'ro',24.5,...
   h(N),'ro'); grid; axis([0 30 0 30]); axis('square') 
xlabel('V^2/2gl'); ylabel('h/l');
%
figure(2); clf; subplot(211), plot(t,V,[0 tf],4.63*[ 1 1],'--'); grid
ylabel('V'); subplot(212), plot(t,c*ga,[0 tf],c*.1023*[1 1],'--'); 
grid; ylabel('\gamma (deg)'); xlabel('t*sqrt(g/l)')
%
figure(3); clf; subplot(211), plot(t,h,[0 0],[0 13.78],'r--',...
   [tf tf],[27.96 14.18],'r--',[0 tf],[13.78 27.96],'r--'); grid
ylabel('h'); subplot(212), plot(t,c*al,[0 tf],c*.0466*[1 1],'--'); 
grid; ylabel('\alpha (deg)'); xlabel('t*sqrt(g/l)')

	