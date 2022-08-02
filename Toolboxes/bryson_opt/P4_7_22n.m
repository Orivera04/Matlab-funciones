% Script p4_7_22n.m; max tf for spec. (Vf,gaf,hf), glider with parabo-
% lic lift-drag polar using FOPTN; s=[V ga h]'; h in l, V in sqrt(gl),
% t in sqrt(l/g), l=2m/(rho*S*Cla), alm =sqrt(Cdo/(eta*Cla));
%                                                        3/97, 3/28/02
%
al0=[6.2679 5.4111 5.0588 5.1109 5.5076 6.1716 6.9696 7.7291 8.3075 ...
     8.6508 8.7899 8.7967 8.7448 8.6909 8.6710 8.7019 8.7822 8.8905 ...
     8.9808 8.9784 8.7841 8.3051 7.5193 6.5358 5.5691 4.8265 4.4222 ...
     4.3911 4.7559 5.6008 7.1928]; c=pi/180; al0=al0*c;
nu=[18.1770 9.1277 3.9879]; tf=30.0034; p0=[al0 nu tf]; name='gldt';
s0=[4 0 0]'; optn=optimset('Display','Iter','MaxIter',50);
t=tf*[0:1/30:1];
p=fsolve('foptn',p0,optn,name,s0); al=p([1:31]); tf=p(35); 
[f,s,la0]=foptn(p,name,s0); V=s(1,:); ga=s(2,:); h=s(3,:); 
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
figure(3); clf; es=2.614^2/2; plot(V.^2/2,h,8,h(31),'ro',8,0,...
   'ro',es*[1 1],[-2.97 4.58],'r--',[es 8],[4.58 0],'r--',...
   [es 8],[-2.97 -7.55],'r--'); grid; axis([0 15 -10 5]); 
axis('square'); xlabel('V^2/2gl'); ylabel('h/l') 