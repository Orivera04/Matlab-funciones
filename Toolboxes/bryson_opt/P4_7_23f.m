% Script p4_7_23f.m; min time climb, A/C w. parabolic lift-drag polar
% using FOPTF; s=[V ga h x]'; al=control; V in sqrt(g*l), alm=1/12;
% l=2m/(rho*S*Cla);eta=1/2; T=.2; Vo=Vf=7, ga0=gaf=0; hf=11.3;
%                                                  4/97, 3/28/02
%
la0=[-12.6991 -6.1797 -2.1121  0]; name='climbt'; nu=[-17.4749 ...
      -7.2864 -2.1121]; tf=30.0; p0=[la0 nu tf]; s0=[7 0 0 0]';
optn=optimset('Display','Iter','MaxIter',50);
p=fsolve('foptf',p0,optn,name,s0);
[f,t,y]=foptf(p,name,s0); eta=.5; c=180/pi; V=y(:,1); ga=y(:,2);
h=y(:,3); x=y(:,4); lv=y(:,5); lg=y(:,6); al=lg./(2*eta*V.*lv); 
es=4.630^2/2; ke=V.^2/2; N1=length(t); tf=t(N1);
%
figure(1); clf; plot(ke,h,[es 24.5],[27.96 13.78],'r--',[es 24.5],...
   [13.78 0],'r--',[es es],[13.78 27.96],'r--',24.5,0,'ro',24.5,...
   h(N1),'ro'); grid; axis([0 30 0 30]); axis('square'); 
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
