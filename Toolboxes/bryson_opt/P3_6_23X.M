% Script p3_6_23x.m; A/C max altitude climb with SPEC. XF using FOPCF;
% s=[V ga h]'; u=alpha; h in l, V in sqrt(g*l); alm=1/12; eta=.5; T=.2; 
% V0=Vf=7; ga0=gaf=0; INDPT. VARIABLE IS `x';             3/97, 5/28/02
%
la0=[4.6641 2.1445 1]; nu=[5.4524 2.0450]; s0=[5 0 0]'; xf=120;
p0=[la0 nu]; c=180/pi; name='climbx'; 
optn=optimset('Display','Iter','MaxIter',500); 
p=fsolve('fopcf',p0,optn,name,s0,xf); [f,x,y]=fopcf(p,name,s0,xf);
V=y(:,1); ga=y(:,2); h=y(:,3); lv=y(:,4); lg=y(:,5); lh=y(:,6);
la=[lv lg lh]'; eta=.5; al=lg./(2*eta*V.*lv); N=length(x);
ke=V.^2/2; es=3.464^2/2; 
%
figure(1); clf; plot(ke,h,[es 12.5],[6.50 0],'r--',[es 12.5],...
   [20.57 14.07],'r--',[es es],[20.57 6.50],'r--',12.5,0,'ro',...
   12.5,h(N),'ro'); grid; axis([0 22 0 22]); axis('square')
xlabel('V^2/2gl'); ylabel('h/l')
%
figure(2); clf; subplot(211), plot(x,V,[0 xf],3.464*[ 1 1],'r--');
grid; ylabel('V'); subplot(212), plot(x,c*ga,[0 xf],c*.1023*[1 1],...
   'r--'); grid; ylabel('\gamma (deg)'); xlabel('x/l')
%
figure(3); clf; subplot(211), plot(x,h,[.2 .2],[0 6.50],'r--',...
   [xf-.2 xf-.2],[20.57 14.07],'--',[0 xf],[6.50 20.57],'--'); grid
ylabel('h'); subplot(212), plot(x,c*al,[0 xf],c*.0833*[1 1],'--'); 
grid; ylabel('\alpha (deg)'); xlabel('x/l')


	