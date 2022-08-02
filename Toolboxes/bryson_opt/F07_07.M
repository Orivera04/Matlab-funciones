% Script f07_07.m; min time TDP intercept paths to x=y=0; r 
% in units of V^2/(2a), T in V/a, T=time-to-go; 12/96, 4/4/02
%
c=pi/180; r1=[0:.01:1.2 1.25:.05:4]; ga1=c*[0:60 62:2:180];
Nr=length(r1); Ng=length(ga1); th=zeros(Nr,Ng); tf=th;
%for i=1:Nr, for j=1:Ng,
%  r=r1(i); ga=ga1(j); T=roots([1 0 -4 4*r*cos(ga) -r^2]);
%  for k=1:4, if abs(imag(T(k)))>0; T(k)=1e9; 
%     elseif T(k)<0; T(k)=1e9; 
%  end; end;
%  t=real(min(T)); tf(i,j)=t;
%  th(i,j)=atan2(t*sin(ga),r/2-t*cos(ga));
%end; end;
T=[.2:.2:3 1.9 2.1]; 
load \book_do\figures\f07_07;
%
figure(1); clf; contour(ga1/c,r1,tf,T); grid
xlabel('\gamma (deg)'); ylabel('2ar/V^2')
text(1.5,.6,'.2'); text(7,1.1,'.4'); text(11,1.6,'.6')
text(22,1.9,'.8'); text(28,2.2,'1.0'); text(36,2.4,'1.2')
text(45,1.65,'1.4'); text(51,1.2,'1.6'); text(56,.65,'1.8')
text(65,.35,'1.9'); text(92,.3,'2.0'); text(126,.42,'2.1') 
text(135,.7,'2.2'); text(146,1.2,'2.4'); text(152,1.8,'2.6')
text(165,2.4,'2.8'); text(162,3.25,'T=3.0'); V=c*[15:15:175];
%print -deps2 \book_do\figures\f07_07
%
figure(2); clf; contour(ga1/c,r1,th,V); grid
xlabel('\gamma (deg)'); ylabel('2ar/V^2'); text(1,3.3,'0')
text(10,3.3,'15'); text(19,3.3,'30'); text(30,3.3,'45')
text(42,3.3,'\theta=60 deg'); text(16,.2,'165') 
text(30,.2,'150'); text(44,.3,'135'); text(53,.7,'120')
text(65,.85,'105'); text(72,1.3,'90'); text(85,1.7,'75')
text(100,2.2,'60'); text(116,2.65,'45'); text(138,3.2,'30')
text(160,3.6,'15')
%print -deps2 \book_do\figures\f07_08
	

	
	