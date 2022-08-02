% Script p5_2_14.m; insertion of a S/C at the Sun-Earth L2 point using
% a solar sail; s=[x xd y yd]'; time in 1/n, n=orbit rate of earth; (x,y
% in units of 1.51*10^6 km (distance Earth to L2 point); 
% 2J=sf'*Sf*sf+int(th^2)dt;                                7/97, 3/31/02
%
flg=2; b1=12.762; b2=4.914; c=1.948; A=[0 1 0 0; b1 0 0 2; 0 0 0 1; ...
      0 -2 -b2 0]; B=[0 0 0 c]'; Q=zeros(4); N=zeros(4,1); R=1; tf=pi/2; 
s0=[0 0 -.01 0]'; Mf=eye(4); Qf=1e6; psi=[0 0 0 0]'; Ns=50; tol=1e-4; 
if flg==1, [s,th,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns); x=s(1,:); y=s(3,:);
elseif flg==2, [s,th,t,tk,K]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol);
x=s(:,1); y=s(:,3); end;  t=t/tf;
%
figure(1); clf; subplot(211), plot(t,th); grid; ylabel('\theta (rad)'); 
subplot(212), plot(t,x,t,y,'r--'); grid; xlabel('nt');
legend('x','y'); ylablel('1.51*10^6 km');
%
figure(2); clf; plot(y,x,-.01,0,'ro',0,0,'ro'); grid; hold on;
xlabel('y/l'); ylabel('x/l'); axis([-.012 .002 -.008 .006]);
axis('square'); pltarrow([0 0],[-.002 -.007],.001,'r','-');
text(-.0038,-.005,'Sun & Earth'); hold off;

 
