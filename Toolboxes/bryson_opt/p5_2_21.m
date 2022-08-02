% Script p5_2_21.m; helicopter acceleration from hover (9th-order model
% of OH-6A); xdot=Ax+Bd; x=[u,w,q,theta,v,r,p,phi,psi]'; d=[dc,de,da,dr]';
% x in ft, sec, crad, d in deci-in;                         11/90, 7/11/02 
%
flg=2; A11=[-.0257 .0113 .013 -.3216; -.0422 -.3404 .0001 -.0093; ...
     1.26 -.6 -1.7645 0; 0 0 .9986 0];
A12=[.0004 -.0006 -.0081 0; -.044 .0147 .0005 .0171; ...
    -.26 .0719 .3763 0; 0 .0532 0 0];
A21=[.0158 -.0194 -.0084 0; -2.62 3.1 -.1724 0; ...
     .03 -.19 -1.136 0; 0 0 -.0015 0];
A22=[-.0435 .0034 -.0134 .3216; -.170 -.8645 -1.075 0; ...
    -4.620 -.2873 -4.92 0; 0 .0289 1 0];
A=[A11 A12; A21 A22]; A=[A zeros(8,1); 0 0 0 0 0 1 0 0 0];
B=[.0216 .086 -.0028 -.003; -.7343 -.0016 .0011 -.003; ...
  -.785 -7.408 .35 -.096; 0 0 0 0; ...
  -.0057 .0038 .0514 .153; 9.507 .493 1.982 -25.68; ...
  1.206 1.874 12.79 -.781; 0 0 0 0; 0 0 0 0];
Q=3*diag([0 0 0 0 0 0 0 0 1]); N=zeros(9,4); R=eye(4); Qf=1e4;
x0=[0 0 0 0 0 0 0 0 0]'; tf=3; Ns=50; Mf=eye(9);
psi=[10 0 0 0 0 0 0 0 0]'; tol=1e-4;
if flg==1, [x,uc,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns); u=x(1,:);
   w=x(2,:); v=x(5,:); r=x(6,:); th=x(4,:); ph=x(8,:); ps=x(9,:);
elseif flg==2, [x,uc,t,tk,K]=tlqsr(A,B,Q,N,R,tf,x0,Mf,Qf,psi,tol);
   u=x(:,1); w=x(:,2); v=x(:,5); r=x(:,6); th=x(:,4); ph=x(:,8);
   ps=x(:,9);
end
%
figure(1); clf; subplot(211), plot(t,u,t,w,t,v,t,r); grid 
axis([0 3 -3 10]); legend('u (ft/sec)','w (ft/sec)',...
  'v (ft/sec)','r (crad/sec)',2); subplot(212), plot(t,uc);
axis([0 3 -8 12]); xlabel('Time (sec)'); ylabel('deci-inches')
grid; legend('\delta c','\delta e','\delta a','\delta r',2)
%
figure(2); clf; subplot(211), plot(t,th,t,ph,t,ps); grid
xlabel('Time (sec)'); ylabel('crad')
legend('\theta','\phi','\psi',3)



