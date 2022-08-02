% Script p5_5_17.m; alt. & veloc. change of Navion A/C using TDLQH
% (flg=1) or TDLQHR (flg=2); x=[u w q th h]'; u=[de dT]'; 2J=int
% [de^2+dT^2]dt, Mf*x(tf)=psi; units ft, sec, crad;         7/97, 6/4/02
%
flg=2; A=[-.045 .036 0 -.322 0; -.37 -2.02 1.76 0 0; .191 -3.96 ...
-2.98 0 0; 0 0 1 0 0; 0 -1 0 1.76 0]; B=[0 1; -.282 0; -11 0; zeros(2)]; 
Sf=zeros(5); Ns=50; tf=4; s0=[0 0 0 0 0]'; psi=[10 0 0 0 0]'; Mf=eye(5);
Qd=zeros(5); Nd=zeros(5,2); Rd=eye(2); Ts=tf/Ns; [Ad,Bd]=c2d(A,B,Ts); 
if flg==1, [s,u]=tdlqh(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns); 
elseif flg==2, nf=6; [s,u]=tdlqhr(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns,nf);
end; uh=[u u(:,Ns)]; t=tf*[0:1/Ns:1];
%
figure(1); clf; subplot(211), plot(t,s([1 4 5],:)); grid; 
axis([0 4 -3 10]); 
legend('\delta u (ft/sec)','\theta (crad)','\delta h (ft)',2);  
subplot(212), zohplot(t,uh); grid; xlabel('Time (sec)'); 
legend('\delta e (crad)','\delta T (ft/sec/sec)',3);
%
tf=2; s0=[0 0 0 0 0]'; psi=[0 0 0 0 10]'; Ts=tf/Ns; [Ad,Bd]=c2d(A,B,Ts);
if flg==1, [s,u]=tdlqh(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns);
elseif flg==2, nf=6; [s,u]=tdlqhr(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns,nf);   
end; uh=[u u(:,Ns)]; t=tf*[0:1/Ns:1];
%
figure(2); clf; subplot(211), plot(t,s([1 4 5],:)); axis([0 2 -3 10]) 
grid; legend('\delta u (ft/sec)','\theta (crad)','\delta h (ft)')  
subplot(212), zohplot(t,uh); grid; xlabel('Time (sec)') 
legend('\delta e (crad)','\delta T (ft/sec/sec)',2)
 