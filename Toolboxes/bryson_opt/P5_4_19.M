% Script p5_4_19.m; Helicopter acceleration from hover (9th-order
% model of OH-6A); xdot=Ax+Bd; x=[u,w,q,theta,v,r,p,phi,psi]';
% d=[de,dc,da,dr]'; x in ft, sec, crad, d in deci-in;
%                                                  11/90, 7/25/02 
%
flg=1; A11=[-.0257 .0113 .013 -.3216; -.0422 -.3404 .0001 ...
      -.0093; 1.26 -.6 -1.7645 0; 0 0 .9986 0];
A12=[.0004 -.0006 -.0081 0; -.044 .0147 .0005 .0171; ...
        -.26 .0719 .3763 0; 0 .0532 0 0];
A21=[.0158 -.0194 -.0084 0; -2.62 3.1 -.1724 0; ...
        .03 -.19 -1.136 0; 0 0 -.0015 0];
A22=[-.0435 .0034 -.0134 .3216; -.170 -.8645 -1.075 0; ...
     -4.620 -.2873 -4.92 0; 0 .0289 1 0]; A8=[A11 A12; A21 A22];
A=[A8 zeros(8,1); 0 0 0 0 0 1 0 0 0];
B=[.0216 .086 -.0028 -.003; -.7343 -.0016 .0011 -.003; -.785 ...
  -7.408 .35 -.096; 0 0 0 0; -.0057 .0038 .0514 .153; 9.507 ...
   .493 1.982 -25.68; 1.206 1.874 12.79 -.781; 0 0 0 0; 0 0 0 0];
Q=3*diag([0 0 0 0 0 0 0 0 1]); N=zeros(9,4); R=eye(4); Sf=zeros(9);
x0=[0 0 0 0 0 0 0 0 0]'; tf=3; Ns=50; Mf=eye(9);
psi=[10 0 0 0 0 0 0 0 0]';
if flg==1, [x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Sf,Mf,psi,Ns);
elseif flg==2, t1=.8*tf; tol=1e-4; 
   [x,u,t]=tlqhr(tf,x0,Sf,psi,t1,tol);
end
%
figure(1); clf; subplot(211), plot(t,x([1 2 5 6],:)); grid
axis([0 3 -3 10]); text(1.25,7,'u (ft/sec)')
text(1.7,1,'v (ft/sec)'); text(2.1,-1,'w (ft/sec)')
text(.9,1,'r (crad/sec)'); subplot(212), plot(t,u); grid
axis([ 0 3 -8 12]); xlabel('Time (sec)'); ylabel('deci-inches')
text(.3,-4.5,'\delta a'); text(.3,-1.5,'\delta e')
text(.3,1.5,'\delta r'); text(.3,9,'\delta c')
%
figure(2); clf; subplot(211), plot(t,x([4 8 9],:)); grid
xlabel('Time (sec)'); ylabel('crad'); text(1.55,-14,'\theta')
text(1.55,3,'\phi'); text(1.55,-3,'\psi')
