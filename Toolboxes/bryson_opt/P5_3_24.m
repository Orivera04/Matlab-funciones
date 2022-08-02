% Script p5_3_24.m; Helicopter deceleration to hover (12th-order model
% of OH-6A); xdot=Ax+Bd; s=[u,w,q,theta,v,r,p,phi,psi,x,y,h]'; d=[dc,de,
% da,dr]'; s in ft, sec, crad, d in deci-in;                9/97, 7/3/02 
%
A11=[-.0257 .0113 .013 -.3216; -.0422 -.3404 .0001 -.0093; ...
     1.26 -.6 -1.7645 0; 0 0 .9986 0];
A12=[.0004 -.0006 -.0081 0; -.044 .0147 .0005 .0171; ...
    -.26 .0719 .3763 0; 0 .0532 0 0];
A21=[.0158 -.0194 -.0084 0; -2.62 3.1 -.1724 0; ...
     .03 -.19 -1.136 0; 0 0 -.0015 0];
A22=[-.0435 .0034 -.0134 .3216; -.170 -.8645 -1.075 0; ...
    -4.620 -.2873 -4.92 0; 0 .0289 1 0];
A=[A11 A12; A21 A22]; A=[A zeros(8,4); 0 0 0 0 0 1 0 0 0 0 0 0; ...
   1 zeros(1,11); 0 -1 zeros(1,10); 0 0 0 0 1 zeros(1,7)];
B=[.0216 .086 -.0028 -.003; -.7343 -.0016 .0011 -.003; ...
  -.785 -7.408 .35 -.096; 0 0 0 0; ...
  -.0057 .0038 .0514 .153; 9.507 .493 1.982 -25.68; ...
  1.206 1.874 12.79 -.781; zeros(5,4)]; 
Q=1*diag([0 0 0 0 0 0 0 0 1 0 0 0]); N=zeros(12,4); R=eye(4);
Qf=1e3; Mf=eye(12); psi=zeros(12,1); tf=3; Ns=40; Ts=tf/Ns; 
s0=[10 1 0 -.3555 0 0 0 .1714 0 -15 0 1.5]';
[Ad,Bd,Qd,Nd,Rd]=cvrtj(A,B,Q,N,R,Ts); t=tf*[0:1/Ns:1];
[s,d]=tdlqs(Ad,Bd,Qd,Nd,Rd,s0,Mf,Qf,psi,Ts,Ns); dh=[d d(:,Ns)];
%
figure(1); clf; subplot(211), plot(t,s([1 2 5 6],:)); grid 
text(1.25,7,'u'); text(1.2,-1.5,'v'); text(.6,1.2,'w')
text(2.7,-1,'r'); ylabel('ft/sec & crad/sec')
subplot(212), zohplot(t,dh); grid; xlabel('Time (sec)')
ylabel('deci-inches'); text(2.3,-7,'\delta a')
text(.25,-9,'\delta c'); text(1.2,-2.8,'\delta r') 
text(2.1,2,'\delta e')
%
figure(2); clf; subplot(211), plot(t,s([4 8 9],:)); grid
ylabel('crad'); text(.6,12,'\theta'); text(1.9,4.5,'\phi')
text(.6,2,'\psi'); subplot(212), plot(t,s([10:12],:)); grid
xlabel('Time (sec)'); ylabel('ft'); text(1.1,-7,'x')
text(1.1,3,'h'); text(1.1,-2.5,'y')
