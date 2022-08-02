% Script p5_2_16.m; dumping roll/yaw angular mom. using roll gravity
% torque and roll/yaw reaction wheels; oblate S/C with symmetry axis
% cross-track; I=Ix=Iz=2*Iy/3 ==> a=b=.5; sg=50/pi; ep=.02; s=[ph p 
% Hx ps r Hz ep*ph_w ep*ps_w]'; u=[ex ez]'; time in units of 1/n, 
% (p r Hx/Ix Hz/Iz sg) in n, u in R*I*n^2/N;           7/91, 3/31/02
%
flg=1;
tf=pi/2; Ns=100; a=.5; b=.5; sg=50/pi; ep=.02; csg=sg*(1-ep); 
A=[0 1 0 1 0 0 0 0; -3*a -sg csg 0 -a 0 0 0; -3*a 0 0 0 -a 0 0 0; ...
  -1 0 0 0 1 0 0 0; 0 b 0 0 -sg csg 0 0; 0 b 0 0 0 0 0 0; ...
   0 -1 1 0 0 0 0 0; 0 0 0 0 -1 1 0 0]; psi=zeros(8,1);
B=[0 1 0 0 0 0 0 0; 0 0 0 0 1 0 0 0]'; Q=zeros(8); N=zeros(8,2);
R=eye(2); Mf=eye(8); Qf=1e6;
if flg==1, s0=[0 .3 .3 0 0 0 0 0]';
elseif flg==2, s0=[0 0 0 0 .1 .1 0 0]'; end
[s,u,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns); t=t/(2*pi); ph=s(1,:);
p=s(2,:); Hx=s(3,:); ps=s(4,:); r=s(5,:); Hz=s(6,:); ephw=s(7,:);
epsw=s(8,:); epw=Hx-p; erw=Hz-r; eex=ep*u(1,:); eez=ep*u(2,:);
phw=ephw/ep; psw=epsw/ep;
%
figure(1); clf; subplot(221), plot(t,ph,'b',t,-ephw,'r--',t,Hx,'k-.');
grid; legend('\phi','-\epsilon\phi_w','H_x'); axis([0 .25 -.4 .5]); 
subplot(222), plot(t,ps,'b',t,-epsw,'r--',t,-Hz,'k-.'); grid;
legend('\psi','-\epsilon\psi_w','-H_z',2); axis([0 .25 -.4 .5]);
subplot(223), a=plot(t,p,'b',t,-epw,'r--',t,eex,'k-.'); grid;
xlabel('nt/2\pi'); legend(a,'p','-\epsilon p_w' ,'\epsilon e_x');
axis([0 .25 -2 2]);
subplot(224), b=plot(t,r,'b',t,-erw,'r--',t,eez,'k-.'); grid;
xlabel('nt/2\pi'); legend(b,'r','-\epsilon r_w','\epsilon e_z'); 
axis([0 .25 -2 2]);
%
% Movie of motion with roll/yaw wheel angles multiplied by ep:
figure(2); clf; n=length(t);
for j=1:181, th=(j-1)*2*pi/180; xc1(j)=-1+.5*cos(th); yc(j)=.5*sin(th);
  xc2(j)=1+.5*cos(th); end
for i=1:n-1, 
   s=sin(ph(i)); c=cos(ph(i)); sw=sin(phw(i))/2; cw=cos(phw(i))/2;
   s1=sin(ps(i)); c1=cos(ps(i)); sw1=sin(psw(i))/2; cw1=cos(psw(i))/2;
   plot([-s-1 s-1],[-c c],'b',-1,0,'ro',[-1 sw-1],[0 cw],'r',...
      -s-1,-c,'bo',s-1,c,'bo',[-s1+1 s1+1],[-c1 c1],'b',1,0,'ro',...
      [1 sw1+1],[0 cw1],'r',-s1+1,-c1,'bo',s1+1,c1,'bo',xc1,yc,'r',...
      xc2,yc,'r'); axis([-2.4 2.4 -2.4 2.4]); axis('square'); axis off  
  title('Roll Schematic                  Yaw Schematic')
  pause(.02); clf
end
i=n;
s=sin(ph(i)); c=cos(ph(i)); sw=sin(phw(i))/2; cw=cos(phw(i))/2;
s1=sin(ph(i)); c1=cos(ph(i)); sw1=sin(phw(i))/2; cw1=cos(phw(i))/2;
plot([-s-1 s-1],[-c c],'b',-1,0,'ro',[-1 sw-1],[0 cw],'r',...
   -s-1,-c,'bo',s-1,c,'bo'); hold on;
plot([-s1+1 s1+1],[-c1 c1],'b',1,0,'ro',[1 sw1+1],[0 cw1],'r',...
   -s1+1,-c1,'bo',s1+1,c1,'bo',xc1,yc,'r',xc2,yc,'r');
axis([-2.4 2.4 -2.4 2.4]); axis('square'); axis off; hold off
title('Roll Schematic                  Yaw Schematic');
