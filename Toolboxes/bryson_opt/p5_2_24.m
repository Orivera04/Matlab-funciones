% Script p5_2_24.m; helicopter deceleration to hover (12th-order model
% of OH-6A) using time-varying gains; sdot=As+Bd; s=[u w q theta v r p
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
  1.206 1.874 12.79 -.781; zeros(1,4)]; D=zeros(4);
C=[1 zeros(1,7); 0 0 0 0 1 0 0 0; 0 1 zeros(1,6); 0 0 0 0 0 1 0 0];
s8e=[A8 B8; C D]\[zeros(8,1); [10 0 2 0]'];        % Steady descent
A=[A8 zeros(8,4); 0 0 0 0 0 1 0 0 0 0 0 0; 1 zeros(1,11); ...
   0 0 0 0 1 zeros(1,7); 0 -1 zeros(1,10)]; B=[B8; zeros(4)];
Q=diag([0 0 0 0 0 0 0 0 1 0 0 0]); N=zeros(12,4); R=eye(4); Qf=1e3;
Mf=[eye(3) zeros(3,9); zeros(3,4) eye(3) zeros(3,5); zeros(4,8) eye(4)];
psi=zeros(10,1); tf=3; Ns=60; Ts=tf/Ns;
s0=[s8e([1:8]); 0; -15; 0; 2];                     
[Ad,Bd,Qd,Nd,Rd]=cvrtj(A,B,Q,N,R,Ts); t=tf*[0:1/Ns:1];
[s,d,K]=tdlqsr(Ad,Bd,Qd,Nd,Rd,s0,Mf,Qf,psi,Ts,Ns); u=s(1,:); w=s(2,:);
th=s(4,:); v=s(5,:); r=s(6,:); ph=s(8,:); ps=s(9,:); x=s(10,:);
y=s(11,:); h=s(12,:); N=length(t); d=[d d(:,N-1)]; dc=d(1,:); de=d(2,:);
da=d(3,:); dr=d(4,:); 
%
figure(1); clf; subplot(211); plot(t,u,'b',t,v,'b',t,w,'b',t,r,'b--');
grid; text(1.6,5,'u (ft/sec)'); text(.25,1.2,'r (crad/sec)')
text(.25,-.7,'v (ft/sec)'); text(1.2,1.5,'w (ft/sec)'); axis([0 3 -2 11])
subplot(212); zohplot(t,de,'b'); hold on; zohplot(t,dr,'b--'); 
grid; zohplot(t,dc,'b'); zohplot(t,da,'b'); hold off; ylabel('DECI-IN')
xlabel('TIME (SEC)'); axis([0 3 -12 6]); text(.25,3.4,'\delta_a')
text(.25,.8,'\delta_c'); text(.25,-1.8,'\delta_r')
text(.25,-8.5,'\delta_e')
%
figure(2); clf; subplot(211), plot(t,x,'b',t,h,'b',t,y,'b'); grid
ylabel('FT'); xlabel('TIME (SEC)')
text(.3,3,'h'); text(.3,-1.5,'y'); text(.7,-7,'x'); subplot(212)
plot(t,th,'b',t,ph,'b',t,ps,'b'); ylabel('CENTI-RAD'); grid 
%print -deps2 \papers\tvlqfigs\fig2
%
figure(3); clf; Ke=squeeze(K(2,:,:)); Ke=[Ke Ke(:,N-1)];
zohplot(t,Ke); xlabel('TIME (SEC)'); grid
ylabel('FDBK GAINS TO \delta_e; UNITS DEC-IN, FT, SEC, CRAD')
%print -deps2 \papers\tvlqfigs\fig3
