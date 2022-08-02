% Script p3_4_23b.m; max altitude climb in given xf, A/C w. parabolic
% lift-drag polar; s=[V,gamma,h]'; u=alpha; h in l, V in sqrt(g*l),
% l=2m/(rho*S*Cla); alm=1/12; eta=1/2; T=.2; Vo=Vf=7, ga0=gaf=0;
% indpt. variable x;                                    2/97, 7/16/02
%
al0=[.920 .839 .770 .710 .659 .616 .581 .556 .544 .548 .571 .615 ...
     .676 .744 .807 .856 .888 .904 .908 .904 .895 .884 .873 .864 ...
     .858 .855 .856 .860 .867 .877 .890 .902 .913 .920 .917 .900 ...
     .866 .812 .741 .667 .601 .555 .530 .522 .528 .545 .572 .606 ...
     .647 .695 .752]'/10;             % N=50; al0=.0833*ones(1,N+1); 	
N=length(al0)-1; xf=120; tu=xf*[0:1/N:1]'; s0=[5 0 0]';
k=-1e-2; told=1e-5; tols=5e-5; mxit=5; c=180/pi; name='climbx';
[x1,al,s]=fopc(name,tu,al0,xf,s0,k,told,tols,mxit);  
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
	