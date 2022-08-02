% Script p5_2_13.m; insertion of a S/C at the Earth-Moon L1 point using
% radial thrusters; s=[x u y v]'; time in 1/n, n=orbit rate of moon
% a=radial specific thrust in units of l*n^2, (x,y) in units of l=dis-
% tance earth to L1;                                      7/97, 3/31/02
%
flg=2; be=5.148; A=[0 1 0 0; 2*be+1 0 0 2; 0 0 0 1; 0 -2 -(be-1) 0];
B=[0 1 0 0]'; Q=zeros(4); N=zeros(4,1); R=1; s0=[0 0 -.01 0]'; 
tf=pi/4; Ns=50; Mf=eye(4); Qf=1e6; psi=[0 0 0 0]'; tol=1e-4;
if flg==1, [s,a,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns); 
   x=s(1,:); y=s(3,:);
elseif flg==2, [s,a,t]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol); 
   x=s(:,1); y=s(:,3); 
end; t=t/tf;
%
figure(1); clf; subplot(211), plot(t,a); grid; ylabel('a/l*n^2'); 
subplot(212), plot(t,x,t,y); grid; xlabel('t/tf');
ylabel('x/l and y/l');
%
figure(2); clf; plot(y,x,-.01,0,'ro',0,0,'ro'); grid; xlabel('y/l');
ylabel('x/l'); text(-.007,.014,'Moon'); axis([-.025 .025 -.03 .02]);
axis('square'); text(-.005,-.014,'Sun'); hold on;
pltarrow([0 0],[.006 .018],.002,'r','-'); 
pltarrow([0 0],[-.006 -.018],.002,'r','-'); hold off;

