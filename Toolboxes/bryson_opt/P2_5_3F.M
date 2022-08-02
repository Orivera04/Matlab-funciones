% Script p2_5_3f.m; disc. geod. Pb using DOP0F; min dist. to a 
% meridian on a sphere; th(0)=40 deg; phf=50 deg;  3/97, 3/28/02
%
N=40; la0=[1 -.6071]'; u0=.6383; c=pi/180; s0=[0 c*40]'; tf=c*50;
name='dgeo0'; optn=optimset('Display','Iter','MaxIter',50); 
la0=fsolve('dop0f',la0,optn,name,u0,s0,tf,N);
[f,s,u,la]=dop0f(la0,name,u0,s0,tf,N); d=s(1,:); th=s(2,:); 
ph=tf*[0:1/N:1];
% 
figure(1); clf; plot(ph/c,th/c,'.',ph/c,th/c); grid;
axis([0 50 40 54]); xlabel('Long. (deg)'); ylabel('Lat. (deg)'); 
	
	
