% Script p5_2_12.m; position change of hovering helicopter; 
% x=[u q th y]'; u=dcy; units ft, sec, crad, deci-in (for dcy); 
%                                                    2/93, 3/31/02
%
flg=2; A=[-.0257 .0130 -.322 0; 1.26 -1.765 0 0; 0 1 0 0; 1 0 0 0]; 
tf=4; B=[.0860 -7.41 0 0]'; Q=zeros(4); N=zeros(4,1); R=1;
s0=[0 0 0 0]'; Ns=50; Mf=eye(4); Qf=1e4; psi=[0 0 0 10]'; tol=1e-4; 
if flg==1, [s,u,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns);
  u=s(1,:); th=s(3,:); x=s(4,:); 
elseif flg==2, [s,u,t,tk,K]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol);
   u=s(:,1); th=s(:,3); x=s(:,4);
end
%
figure(1); clf; subplot(211), plot(t,x); ylabel('Position y (ft)');
grid; subplot(212), plot(t,th,t,u,'r--'); grid; xlabel('Time (sec)'); 
legend('\theta (crad)','\delta_{cy} (deci-in)',2)
%
if flg==2, figure(2); clf; plot(tk,K); grid; axis([0 4 -500 200]);
xlabel('Time (sec)'); ylabel('Fdbk Gains'); end
