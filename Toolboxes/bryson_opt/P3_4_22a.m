% Script p3_4_22a.m; min altitude drop, glider w. parabolic lift-
% drag polar; s=[V ga h]'; u=alpha; h in l, V in sqrt(g*l), alm=1/12,
% l=2m/(rho*S*Cla); eta=1/2; T=.2; V0=Vf=7, ga0=gaf=0;  2/97, 8/14/02
%
N=30; tf=30; %al0=.15*ones(N+1,1); t=tf*[0:1/N:1]'; tu=[t al0]; 
c=180/pi; load p3_4_22a; tu=t; u0=al/c; 
name='gldc'; s0=[4 0 0]'; k=-.007; told=1e-4; tols=1e-4; mxit=10; 
[t,al,s,nu,la0]=fopc(name,tu,u0,tf,s0,k,told,tols,mxit); V=s(:,1);
ga=s(:,2)*c; h=s(:,3); al=al*c; es=2.614^2/2; N1=length(t);
%
figure(1); clf; plot(V.^2/2,h,8,h(N1),'ro',8,0,'ro',es*[1 1],...
   [-2.97,4.58],'r--',[es 8],[4.58 0],'r--',[es 8],...
   [-2.97 -7.55],'r--'); grid; axis([0 10 -9 5]); axis('square') 
xlabel('V^2/2gl'); ylabel('h/l')
%
figure(2); clf; subplot(211), plot(t,V,[0 tf],2.61*[ 1 1],'r--'); 
grid; ylabel('V'); subplot(212), plot(t,ga,[0 tf],-c*.0964*[1 1],...
   'r--'); grid; ylabel('\gamma (deg)'); xlabel('t*sqrt(g/l)')
%
figure(3); clf; subplot(211), plot(t,h,[0 tf],[4.58 -2.97],...
    'r--',[0 0],[0 4.58],'r--',tf*[1 1],[-2.97 -7.55],'r--');
grid; ylabel('h'); subplot(212), plot(t,al,[0 tf],.1457*c*[1 1],...
   'r--'); grid; ylabel('\alpha (deg)'); xlabel('t*sqrt(g/l)')
