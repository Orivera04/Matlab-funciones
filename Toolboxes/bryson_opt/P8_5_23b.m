% Script p8_5_23b.m; max altitude climb in given xf, A/C w. parabolic
% lift-drag polar using FOP0N2; s=[V,gamma,h]'; u=alpha; h in l, V in 
% sqrt(g*l), l=2m/(rho*S*Cla); alm=1/12; eta=1/2; T=.2; Vo=Vf=7, ga0=
% gaf=0; indpt. variable=horiz. distance x;             2/97, 7/19/02
%
% NOT WORKING 8/10/02
%
xf=120; s0=[5 0 0]'; tol=1e-5; mxit=3; c=180/pi; name='climbx0s';
load p2_7_23b; al0=al0/c;
[x1,al,s,K,Hu,Huu]=fop0N2(name,tu,al0,s0,xf,tol,mxit);
V=s(:,1); ga=c*s(:,2); h=s(:,3); al=c*al; N1=length(x1); 
es=3.464^2/2;  
%
figure(1); clf; plot(V.^2/2,h,[es 12.5],[6.50 0],'r--',[es 12.5],...
   [20.57 14.07],'r--',[es es],[20.57 6.50],'r--',12.5,0,'ro',...
   12.5,h(N1),'ro'); grid; axis([0 22 0 22]); axis('square')
xlabel('V^2/2gl'); ylabel('h/l')
%
figure(2); clf; subplot(211), plot(x1,V,[0 xf],3.464*[ 1 1],'r--');
grid; ylabel('V'); subplot(212), plot(x1,ga,[0 xf],c*.1023*[1 1],...
    'r--'); grid; ylabel('\gamma (deg)'); xlabel('x/l')
%
figure(3); clf; subplot(211), plot(x1,h,[.2 .2],[0 6.50],'r--',...
   [xf-.2 xf-.2],[20.57 14.07],'--',[0 xf],[6.50 20.57],'r--'); 
grid; ylabel('h'); subplot(212), plot(x1,al,[0 xf],c*.0833*[1 1],...
    'r--'); grid; ylabel('\alpha (deg)'); xlabel('x/l')
	