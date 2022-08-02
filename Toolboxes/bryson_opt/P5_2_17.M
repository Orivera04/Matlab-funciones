% Script p5_2_17.m; altitude & velocity change of Navion A/C using TLQS;
% x=[u w q th h]'; u=[de dT]'; 2J=ef'*Sf*ef+int[de^2+dT^2]dt, 
% ef=Mf*x(tf)-psi; units ft, sec, crad;                    7/97, 3/31/02
%
flg=2; A=[-.045 .036 0 -.322 0; -.37 -2.02 1.76 0 0; .191 -3.96 -2.98 ...
      0 0; 0 0 1 0 0; 0 -1 0 1.76 0]; B=[0 1; -.282 0; -11 0; zeros(2)]; 
Qf=1e4; Ns=50; tf=4; s0=[0 0 0 0 0]'; psi=[10 0 0 0 0]'; Mf=eye(5);
Q=zeros(5); N=zeros(5,2); R=eye(2); tol=1e-4; 
if flg==1, [s,d,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns);
 u=s(1,:); th=s(4,:); h=s(5,:); de=d(1,:); dT=d(2,:);
elseif flg==2, [s,d,t]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol);
 u=s(:,1); th=s(:,4); h=s(:,5); de=d(1,:); dT=d(2,:);
end
%
figure(1); clf; subplot(211), plot(t,u,t,th,'r--',t,h,'k-.'); grid
legend('du (ft/sec)','\theta (crad)','h (ft)',2); axis([0 4 -3 10]) 
subplot(212), plot(t,de,t,dT,'r--'); grid; xlabel('Time (sec)') 
legend('\delta_e (crad)','dT (ft/sec/sec)',3)
%
tf=2; psi=[0 0 0 0 10]'; 
if flg==1, [s,d,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns);
 u=s(1,:); th=s(4,:); h=s(5,:); de=d(1,:); dT=d(2,:);
elseif flg==2, [s,d,t]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol);
 u=s(:,1); th=s(:,4); h=s(:,5); de=d(1,:); dT=d(2,:);
end
%
figure(2); clf; subplot(211), plot(t,u,t,th,'r--',t,h,'k-.'); grid
legend('du (ft/sec)','\theta (crad)','h (ft)',2)  
subplot(212), plot(t,de,t,dT,'r--'); grid; xlabel('Time (sec)') 
legend('\delta_e (crad)','dT (ft/sec/sec)',2)


	
