% Script p5_3_17.m; altitude & velocity change of  Navion A/C using
% TDLQS; x=[u w q th h]'; u=[de dT]'; 2J=ef'*Sf*ef+int[de^2+dT^2]dt,
% ef=Mf*x(tf)-psi; units ft, sec, crad;                      7/97, 7/3/02
%
A=[-.045 .036 0 -.322 0; -.37 -2.02 1.76 0 0; .191 -3.96 -2.98 0 0; ...
      0 0 1 0 0; 0 -1 0 1.76 0]; B=[0 1; -.282 0; -11 0; zeros(2)]; N=50;
tf=4; x0=[0 0 0 0 0]'; psi=[10 0 0 0 0]'; Ts=tf/N; [Ad,Bd]=c2d(A,B,Ts);
Mf=eye(5); Qf=1e4; Qd=zeros(5); Nd=zeros(5,2); Rd=eye(2); t=tf*[0:1/N:1];
[x,u]=tdlqs(Ad,Bd,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N); uh=[u u(:,N)];
%
figure(1); clf; subplot(211), plot(t,x([1 4 5],:)); grid 
axis([0 4 -3 10]) 
legend('\delta u (ft/sec)','\theta (crad)','\delta h (ft)',2)  
subplot(212), zohplot(t,uh); grid; xlabel('Time (sec)') 
legend('\delta e (crad)','\delta T (ft/sec/sec)',3)
%
tf=2; x0=[0 0 0 0 0]'; psi=[0 0 0 0 10]'; Ts=tf/N; [Ad,Bd]=c2d(A,B,Ts);  
[x,u]=tdlqs(Ad,Bd,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N); uh=[u u(:,N)];
t=tf*[0:1/N:1];
%
figure(2); clf; subplot(211), plot(t,x([1 4 5],:)); grid 
axis([0 2 -3 10]) 
legend('\delta u (ft/sec)','\theta (crad)','\delta h (ft)',2)  
subplot(212), zohplot(t,uh); grid; xlabel('Time (sec)') 
legend('\delta e (crad)','\delta T (ft/sec/sec)',3)
 


	
