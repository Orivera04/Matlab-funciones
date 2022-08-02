% Script p4_5_22.m; max tf for spec. (Vf,gaf,hf), glider w. parabolic 
% lift-drag polar; s=[V ga h]'; h in l, V in sqrt(gl), t in sqrt(l/g),
% l=2m/(rho*S*Cla), alm=sqrt(Cdo/(eta*Cla));             2/97, 9/5/02
%
clear; name='gldt';
al0=[6.2703 5.4141 5.0635 5.1189 5.5200 6.1903 7.0004 7.7755 ...
     8.3719 8.7333 8.8852 8.9077 8.8685 8.8250 8.8155 8.8569 ...
     8.9454 9.0617 9.1565 9.1510 8.9497 8.4501 7.6303 6.6085 ...
     5.6132 4.8560 4.4435 4.4062 4.7674 5.6106 7.2034]';
c=pi/180; al0=al0*c; tf=30.00; N=length(al0)-1; tu=tf*[0:1/N:1]';
s0=[4 0 0]'; k=-.001; tol=1e-4; tols=1e-4; told=1e-4; mxit=15;  
[t,al,s,tf,nu,la0]=fopt(name,tu,al0,tf,s0,k,told,tols,mxit);
V=s(:,1); ga=s(:,2); h=s(:,3); N1=length(V); es=2.614^2/2; 
%
figure(1); clf; subplot(211), plot(t,V,[0 30],[2.61 2.61],'r--');
grid; ylabel('V/sqrt(gl)'); axis([0 32 2 5]); subplot(212)
plot(t,ga/c,[0 30],-.0964*[1 1]/c,'r--'); grid; axis([0 32 -22 12])
ylabel('\gamma (deg)'); xlabel('t*sqrt(g/l)')
%
figure(2); clf; subplot(211), plot(t,h,[0 30],[4.58 -2.97],...
   '--',[0 0],[0 4.58],'--',[30 30],[-2.97 -7.55],'--'); grid
ylabel('h/l'); axis([0 32 -10 5]); subplot(212), plot(t,al/c,...
  [0 30],.1457*[1 1]/c,'--'); grid; ylabel('\alpha (deg)')
xlabel('t*sqrt(g/l)'); axis([0 32 4 10])
%
figure(3); clf; plot(V.^2/2,h,8,h(N1),'ro',8,0,'ro', ...
   es*[1 1],[-2.97 4.58],'r--',[es 8],[4.58 0],'r--',[es 8],...
   [-2.97 -7.55],'r--'); grid; axis([0 15 -10 5])
axis('square'); xlabel('V^2/2gl'); ylabel('h/l')