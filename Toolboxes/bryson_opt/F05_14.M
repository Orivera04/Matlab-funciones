% Script f05_14.m; insertion of a S/C at the Earth-Moon L1 
% point using radial thrusters; s=[x u y v]'; time in 1/n,
% n=orbit rate of moon around the earth, a=radial specific 
% thrust in units of l*n^2, (x,y) in units of l=distance
% earth to L1;                                    7/97, 4/4/02
%
be=5.148; A=[0 1 0 0; 2*be+1 0 0 2; 0 0 0 1; 0 -2 -(be-1) 0];
B=[0 1 0 0]'; Q=zeros(4); N=zeros(4,1); R=1; s0=[0 0 -.01 0]'; 
tf=pi/4; Ns=50; Mf=eye(4); Qf=1e6; psi=[0 0 0 0]';
[s,a,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns); x=s(1,:);
y=s(3,:);
%
figure(1); clf; subplot(211), plot(t/tf,a); grid
ylabel('a/ln^2'); subplot(212), plot(t/tf,[x;y]); 
grid; xlabel('t/t_f'); legend('x/l','y/l',2)
%
figure(2); clf; plot(y,x,y,x,'.',-.01,0,'o',0,0,'o'); grid
xlabel('y/l'); ylabel('x/l'); text(-.007,.014,'Moon')
axis([-.025 .025 -.03 .02]); axis('square')
text(-.005,-.014,'Sun'); hold on
pltarrow([0 0],[.006 .018],.002,'r','-'); 
pltarrow([0 0],[-.006 -.018],.002,'r','-'); hold off
%print -deps2 \book_do\figures\f05_14

 
