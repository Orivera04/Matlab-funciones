% Script p4_7_22f.m; max tf for spec. (Vf,gaf,hf), glider w. parabolic
% lift-drag polar using FOPTF; s=[V ga h]'; h in l, V in sqrt(gl), t in
% sqrt(l/g), l=2m/(rho*S*Cla), alm=sqrt(Cdo/(eta*Cla));   4/97, 3/26/02
%
la0=[14.4791 6.3470 3.9801]; eta=.5; nu=[18.1444 9.1042 3.9801];
tf=30.0043; p0=[la0 nu tf]; c=pi/180; name='gldt'; s0=[4 0 0]';
optn=optimset('Display','Iter','MaxIter',50);
p=fsolve('foptf',p0,optn,name,s0);
[f,t,y]=foptf(p,name,s0); V=y(:,1); ga=y(:,2); h=y(:,3); lv=y(:,4);
lg=y(:,5); al=lg./(2*eta*V.*lv); N=length(t);  
%
figure(1); clf; subplot(211), plot(t,V,[0 30],[2.61 2.61],'r--');
grid; ylabel('V/sqrt(gl)'); axis([0 32 2 5]); subplot(212);
plot(t,ga/c,[0 30],-.0964*[1 1]/c,'r--'); grid; axis([0 32 -22 12]); 
ylabel('\gamma (deg)'); xlabel('t*sqrt(g/l)');
%
figure(2); clf; subplot(211), plot(t,h,[0 30],[4.58 -2.97],'r--',...
   [0 0],[0 4.58],'r--',[30 30],[-2.97 -7.55],'r--'); grid; 
ylabel('h/l'); axis([0 32 -10 5]); subplot(212), plot(t,al/c,...
   [0 30],.1457*[1 1]/c,'r--'); grid; ylabel('\alpha (deg)');
xlabel('t*sqrt(g/l)'); axis([0 32 4 10]);
%
figure(3); clf; es=2.614^2/2; plot(V.^2/2,h,8,h(N),'ro',8,0,...
   'ro',es*[1 1],[-2.97 4.58],'r--',[es 8],[4.58 0],'r--',...
   [es 8],[-2.97 -7.55],'r--'); grid; axis([0 15 -10 5]); 
axis('square'); xlabel('V^2/2gl'); ylabel('h/l') 

