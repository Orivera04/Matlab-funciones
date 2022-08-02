% Script p3_4_22b.m; max final altitude for spec. xf, glider with
% parabolic lift-drag polar; s=[V ga h]'; u=alpha; h in l, V in 
% sqrt(g*l), l=2m/(rho*S*Cla); alm=1/12; eta=1/2; indpt. variable
% x (not t);                                        2/97, 7/16/02
%
N=30; al0=.08*ones(N+1,1); xf=120; tu=xf*[0:1/N:1]'; name='gldcx';
s0=[4 0 0]'; k=-.01; told=1e-4; tols=1e-4; mxit=25;
[t,al,s]=fopc(name,tu,al0,xf,s0,k,told,tols,mxit); x1=t;
V=s(:,1); c=180/pi; ga=s(:,2)*c; h=s(:,3); al=al*c; 
es=3.458^2/2; N1=length(x1);
%
figure(1); clf; plot(V.^2/2,h,8,h(N1),'ro',8,0,'ro',es*[1 1],...
   [2.01,-7.98],'r--',[es 8],[2.02 0],'r--',[es 8],[-7.98 -10],...
   'r--'); grid; axis([0 14 -11 3]); axis('square') 
xlabel('V^2/2gl'); ylabel('h/l')
%
figure(2); clf; subplot(211), plot(x1,V,[0 xf],3.458*[ 1 1],'r--'); 
grid; ylabel('V'); subplot(212), plot(x1,ga,[0 xf],-c*.0831*[1 1],...
   'r--'); grid; ylabel('\gamma (deg)'); xlabel('t*sqrt(g/l)')
%
figure(3); clf; subplot(211), plot(x1,h,[0 xf],[2.02 -7.98],'r--',...
   [0 0],[0 2.02],'r--',xf*[1 1],[-7.98 -10],'r--'); grid
ylabel('h'); subplot(212), plot(x1,al,[0 xf],.0833*c*[1 1],'r--');
grid; ylabel('\alpha (deg)'); xlabel('t*sqrt(g/l)')
