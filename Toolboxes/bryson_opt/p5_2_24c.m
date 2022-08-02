% Script p5_2_24c.m; helicopter deceleration to hover (12th-order model
% of OH-6A) using constant gains; sdot=As+Bd; s=[u w q theta v r p
% phi psi x y h]'; d=[dc de da dr]'; units are ft, sec, centi-rad, d in
% deci-in;                                                4/98, 6/30/02	                         
%
A11=[-.0257 .0113 .013 -.3216; -.0422 -.3404 .0001 -.0093; ...
     1.26 -.6 -1.7645 0; 0 0 .9986 0];
A12=[.0004 -.0006 -.0081 0; -.044 .0147 .0005 .0171; ...
    -.26 .0719 .3763 0; 0 .0532 0 0];
A21=[.0158 -.0194 -.0084 0; -2.62 3.1 -.1724 0; ...
     .03 -.19 -1.136 0; 0 0 -.0015 0];
A22=[-.0435 .0034 -.0134 .3216; -.170 -.8645 -1.075 0; ...
      -4.620 -.2873 -4.92 0; 0 .0289 1 0]; A8=[A11 A12; A21 A22];
B8=[.0216 .086 -.0028 -.003; -.7343 -.0016 .0011 -.003; ...
  -.785 -7.408 .35 -.096; 0 0 0 0; ...
  -.0057 .0038 .0514 .153; 9.507 .493 1.982 -25.68; ...
  1.206 1.874 12.79 -.781; zeros(1,4)];
C=[eye(2) zeros(2,6); 0 0 0 0 1 0 0 0; 0 0 0 0 0 1 0 0]; D=zeros(4);
s8e=[A8 B8; C D]\[zeros(8,1); [10 0 -2 0]']; 
A=[A8 zeros(8,4); 0 0 0 0 0 1 0 0 0 0 0 0; 1 zeros(1,11); ...
   0 -1 zeros(1,10); 0 0 0 0 1 zeros(1,7)]; B=[B8; zeros(4)];
Q=40*diag([0 0 0 0 0 0 0 1 1 1 1 1]); N=zeros(12,4); R=eye(4); 
tf=6; Ns=120; Ts=tf/Ns;
s0=[s8e([1:8]); 0; -15; 0; 2];     % Equilibrium flight
[Ad,Bd,Qd,Nd,Rd]=cvrtj(A,B,Q,N,R,Ts); K=dlqr(Ad,Bd,Qd,Rd,Nd);
C=zeros(1,12); D=zeros(1,4); sys=ss(Ad-Bd*K,Bd,C,D,Ts);
[y1,t,s]=initial(sys,s0,tf); u=s(:,1); w=s(:,2); th=s(:,4); v=s(:,5);
r=s(:,6); ph=s(:,8); ps=s(:,9); x=s(:,10); y=s(:,11); h=s(:,12);
d=-s*K'; dc=d(:,1); de=d(:,2); da=d(:,3); dr=d(:,4); clear K; 
%
figure(1); clf; subplot(211);
plot(t,u,'b',t,v,'r--',t,w,'m-.',t,r,'g:'); grid
legend('u','v','w','r'); ylabel('UNITS FT, SEC, CENTI-RAD')
subplot(212); zohplot(t,de,'b'); hold on; zohplot(t,dr,'r--'); 
zohplot(t,dc,'m-.'); zohplot(t,da,'g:'); hold off
ylabel('CENTI-RAD'); xlabel('TIME (SEC)'); grid; axis([0 6 -10 15])
legend('\delta_e','\delta_r','\delta_c','\delta_r') 
%print -deps2 \papers\tvlqfigs\fig4
%
figure(2); clf; subplot(211), plot(t,th,'b',t,ph,'r--',t,ps,'g-.');
legend('\theta','\phi','\psi'); ylabel('CENTI-RAD'); grid
subplot(212), a=plot(t,x,'b',t,h,'r--',t,y,'g-.'); grid
%legend(a,'x','h','y',4); ylabel('FT')
ylabel('x,h,y (FT'); xlabel('TIME (SEC)')
%print -deps2 \papers\tvlqfigs\fig5
