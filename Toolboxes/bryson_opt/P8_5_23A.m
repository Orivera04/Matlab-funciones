% Script p8_5_23a.m; max altitude climb, A/C w. parabolic 
% lift-drag polar using FOP0N2; s=[V ga h x]'; u=alpha; 
% h in l, V in sqrt(g*l), l=2m/(rho*S*Cla); alm=1/12;
% eta=1/2; T=.2; V0=Vf=7, ga0=gaf=0;         2/97, 7/31/02
%
tf=30; name='climb0'; load p2_7_23a; V0=7; s0=[V0 0 0 0]';
tol=1e-5; mxit=5; global K 
[t,al,s,K,Hu,Huu]=fop0n2(name,tu,u0,s0,tf,tol,mxit); 
N1=length(t); V=s(:,1); ga=s(:,2); h=s(:,3); c=180/pi;  
%
figure(1); clf; plot(V.^2/2,h); grid; axis([0 30 -2 28])
axis('square'); xlabel('V^2/2gl'); ylabel('h/l')
hold on
%
figure(2); clf; subplot(211), plot(t,V); grid
ylabel('V/sqrt(gl)'); hold on; subplot(212)
plot(t,c*ga); grid; ylabel('\gamma (deg)')
xlabel('t*sqrt(g/l)'); hold on
%
figure(3); clf; subplot(211), plot(t,h); grid; ylabel('h')
hold on; subplot(212), plot(t,c*al); grid 
ylabel('\alpha (deg)'); xlabel('t*sqrt(g/l)'); hold on
%
figure(4); clf; subplot(311),plot(t,K(:,[1 2])); 
grid; axis([0 tf -1 1]); legend('K_V','K_\gamma',2)
subplot(312), plot(t,Hu); grid; ylabel('H_u');
axis tight; subplot(313), plot(t,Huu); grid
ylabel('H_{uu}'); xlabel('t*sqrt(g/l)')
%
% A nbr. opt. path:
global tn aln sn; tn=t; aln=al; sn=s; 
optn=odeset('RelTol',1e-4); s0=[7.7 0 0 0]'; 
[t1,s1]=ode23('climb0s',[0 tf],s0,optn);
V1=s1(:,1); ga1=s1(:,2); h1=s1(:,3); x1=s1(:,4);
s11=interp1(t1,s1,t); for i=1:N1,
    al1(i)=aln(i)-K(i,:)*(s11(i,:)'-sn(i,:)'); end
figure(1); plot(V1.^2/2,h1,'r--',V0^2/2,0,'ro',...
  [1 1]*V0^2/2,[0 30],'r--',7.7^2/2,0,'ro'); 
legend('Nominal','Nbr. Opt.'); hold off
figure(2); subplot(211), plot(t1,V1,'r--',0,...
    V0,'ro',tf,V0,'ro'); 
legend('Nominal','Nbr. Opt.',3); hold off
subplot(212), plot(t1,c*ga1,'r--',0,0,'ro',tf,0,'ro'); 
legend('Nominal','Nbr. Opt.',3); hold off
figure(3); subplot(211), plot(t1,h1,'r--');
legend('Nominal','Nbr. Opt.',2); hold off
subplot(212), plot(t,c*al1,'r--'); 
legend('Nominal','Nbr. Opt.',2); hold off