% Script p2_7_23a.m; max altitude climb, A/C w. parabolic lift-
% drag polar; s=[V ga h x]'; u=alpha; h in l, V in sqrt(g*l), 
% l=2m/(rho*S*Cla); alm=1/12; eta=1/2; T=.2; V0=Vf=7, ga0=gaf=0;
%                                                  2/97, 7/17/02
%
tf=30; c=180/pi; name='climb0'; load p2_7_23a; 
s0=[7 0 0 0]'; k=-2e-6; told=1e-5; tols=1e-5; mxit=15; 
[t,al,s]=fop0(name,tu,u0,tf,s0,k,told,tols,mxit); 
V=s(:,1); ga=s(:,2)*c; h=s(:,3); x=s(:,4); al=al*c; 
es=4.630^2/2; N1=length(t);
%
figure(1); clf; plot(V.^2/2,h,[es 24.5],[27.96 13.78],'r--',...
   [es 24.5],[13.78 0],'r--',[es es],[13.78 27.96],'r--',...
   24.5,0,'ro',24.5,h(N1),'ro'); grid; axis([0 30 0 30])
axis('square'); xlabel('V^2/2gl'); ylabel('h/l')
%
figure(2); clf; subplot(211), plot(t,V,[0 tf],4.63*[ 1 1],...
   'r--'); grid; ylabel('V'); subplot(212), plot(t,ga,...
   [0 tf],c*.1023*[1 1],'r--'); grid; ylabel('\gamma (deg)')
xlabel('t*sqrt(g/l)')
%
figure(3); clf; subplot(211), plot(t,h,[0 0],[0 13.78],'r--',...
   [tf tf],[27.96 14.18],'r--',[0 tf],[13.78 27.96],'r--'); 
grid; ylabel('h'); subplot(212), plot(t,al,[0 tf],...
   c*.0466*[1 1],'r--'); grid; ylabel('\alpha (deg)')
xlabel('t*sqrt(g/l)')
