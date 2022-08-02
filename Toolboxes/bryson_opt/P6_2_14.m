% Script p6_2_14.m; helicopter (OH-6A) acceleration from hover; x=[u w q
% theta v r p phi]'; d=[dc de da dr]'; x in ft, sec, crad, d in deci-in;
%                                                         11/90, 7/17/02 
%
A11=[-.0257 .0113 .013 -.3216; -.0422 -.3404 .0001 -.0093; ...
     1.26 -.6 -1.7645 0; 0 0 .9986 0];
A12=[.0004 -.0006 -.0081 0; -.044 .0147 .0005 .0171; ...
    -.26 .0719 .3763 0; 0 .0532 0 0];
A21=[.0158 -.0194 -.0084 0; -2.62 3.1 -.1724 0; ...
     .03 -.19 -1.136 0; 0 0 -.0015 0];
A22=[-.0435 .0034 -.0134 .3216; -.170 -.8645 -1.075 0; ...
    -4.620 -.2873 -4.92 0; 0 .0289 1 0]; A=[A11 A12; A21 A22];
B=[.0216 .086 -.0028 -.003; -.7343 -.0016 .0011 -.003; -.785 -7.408 ...
   .35 -.096; 0 0 0 0; -.0057 .0038 .0514 .153; 9.507 .493 1.982 ...
   -25.68; 1.206 1.874 12.79 -.781; 0 0 0 0]; C=[eye(2) zeros(2,6); ...
   zeros(2,4) eye(2) zeros(2)]; D=zeros(4); Q=eye(4); R=Q;
k=lqr(A,B,C'*Q*C,R); C1=[0 0 0 1 0 0 0 0; 0 0 0 0 0 0 0 1];
D1=zeros(2,4); t=[0:.06:6]'; yc=[10 0 0 0]'; 
[y,y1,u]=stepcmd(A,B,C,D,k,yc,C1,D1,t);
%
figure(1); clf; subplot(211), plot(t,y); grid; axis([0 6 -2 12])
xlabel('Time (sec)'); text(2.5,7,'u (ft/sec)')
text(2.5,-1,'v (ft/sec)'); text(2.5,1,'w (ft/sec)')
text(4.5,-1,'r (crad/sec)')
title('OH-6A Response to Command for Forward Velocity')
subplot(212), plot(t,u); grid; axis([ 0 6 -5 10]) 
xlabel('Time (sec)'); ylabel('deci-inches'); text(.5,-3,'\delta a')
text(3.5,-3,'\delta e'); text(4.5,-3,'\delta r')
text(.5,6,'\delta c')
%
figure(2); clf; subplot(211), plot(t,y1); grid; xlabel('Time (sec)')
ylabel('crad'); text(1.5,-13,'\theta'); text(1.5,3,'\phi')
title('OH-6A Response to Command for Forward Velocity')

		