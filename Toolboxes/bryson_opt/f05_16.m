% Script f05_16.m; insertion of a solar sail S/C at the
% Sun-Earth L2 point; s=[x xd y yd]'; time in 1/n, n=
% orbit rate of earth around the sun; (x,y) in units of 
% 1.51*10^6 km (distance Earth to L2 point); 
% 2J=sf'*Sf*sf+int(th^2)dt;                7/97, 4/4/02
%
b1=12.762; b2=4.914; c=1.948; 
A=[0 1 0 0; b1 0 0 2; 0 0 0 1; 0 -2 -b2 0];
B=[0 0 0 c]'; C=[0 0 1 0];  D=0; R=1;
Q=zeros(4); N=zeros(4,1); s0=[0 0 -.01 0]'; 
tf=pi/2; Ns=50; Mf=eye(4); Qf=1e6; psi=[0 0 0 0]';
[s,th,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns);
%
figure(1); clf; subplot(211), plot(t/tf,th); 
grid; ylabel('\theta (rad)') 
subplot(212), plot(t/tf,s([1 3],:)); grid
xlabel('nt'); legend('x','y',4); ylabel('1.51*10^6 km')
%
figure(2); clf; plot(s(3,:),s(1,:)); grid
hold on; plot(-.01,0,'o',0,0,'o');
plot(s(3,:),s(1,:),'.'); xlabel('y/l'); ylabel('x/l')
axis([-.012 .002 -.008 .006]); axis('square')
pltarrow([0 0],[-.002 -.007],.001,'r','-');
text(-.0038,-.005,'Sun & Earth'); hold off
%print -deps2 \book_do\figures\f05_16
	  
 
