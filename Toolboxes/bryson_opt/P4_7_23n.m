% Script p4_7_23n.m; min time climb, A/C w. parabolic lift-drag polar
% using FOPTN; s=[V ga h x]'; u=alpha; h in l, V in sqrt(g*l), alm=1/12;
% l=2m/(rho*S*Cla); eta=1/2; T=.2; Vo=Vf=7, ga0=gaf=0; hf=11.3;
%                                                     2/97, 3/28/02
%
al0=[3.9756 2.8227 2.0922 1.6416 1.3970 1.3209 1.3870 1.5642 1.8111 ...
     2.0821 2.3379 2.5534 2.7185 2.8338 2.9041 2.9340 2.9243 2.8711 ...
     2.7660 2.5992 2.3650 2.0707 1.7445 1.4373 1.2101 1.1139 1.1766 ...
     1.4087 1.8236 2.4609 3.4153];              % Converged alpha in deg
nu=[-17.4501 -7.2813 -2.1094]; tf=30.0011; c=180/pi; p=[al0/c nu tf];
N1=length(al0); name='climbt'; s0=[7 0 0 0]'; 
optn=optimset('Display','Iter','MaxIter',50);
p=fsolve('foptn',p,optn,name,s0); al=p([1:N1]); tf=p(N1+4); N=N1-1; 
t=tf*[0:1/N:1]; [f,s,la0]=foptn(p,name,s0); V=s(1,:); ga=s(2,:);
h=s(3,:); x=s(4,:); es=4.630^2/2; ke=V.^2/2;
%
figure(1); clf; plot(ke,h,[es 24.5],[27.96 13.78],'r--',[es 24.5],...
   [13.78 0],'r--',[es es],[13.78 27.96],'r--',24.5,0,'ro',24.5,...
   h(31),'ro'); grid; axis([0 30 0 30]); axis('square'); 
xlabel('V^2/2gl'); ylabel('h/l');
%
figure(2); clf; subplot(211), plot(t,V,[0 tf],4.63*[ 1 1],'r--'); grid;
ylabel('V/sqrt(gl)'); axis([0 30 4 8]); subplot(212), plot(t,c*ga,...
[0 tf],c*.1023*[1 1],'r--'); grid; axis([0 30 -30 30]); 
ylabel('\gamma (deg)'); xlabel('t*sqrt(g/l)');
%
figure(3); clf; subplot(211), plot(t,h,[0 0],[0 13.78],'r--',...
   [tf tf],[27.96 14.18],'r--',[0 tf],[13.78 27.96],'r--'); grid; 
ylabel('h/l'); axis([0 30 0 30]); subplot(212), plot(t,c*al,...
   [0 tf],c*.0466*[1 1],'r--'); grid; ylabel('\alpha (deg)'); 
xlabel('t*sqrt(g/l)'); axis([0 30 1 4]);

	
