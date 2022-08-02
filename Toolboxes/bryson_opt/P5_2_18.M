% Script p5_2_18.m; coordinated turn of a Navion A/C; s=[v r p phi psi]';
% u=[da dr]'; sdot=As+Bu; ay=Cs+Du; 2J=ef'*Qf*ef+int[(5ay)^2+da^2+dr^2]dt;
% units ft, sec, crad;  		                             8/97, 3/31/02
%
flg=2; A=[-.254 -1.76 0 .322 0; 2.55 -.76 -.35 0 0; -9.08 2.19 -8.4 ...
   0 0; 0 0 1 0 0; 0 1 0 0 0]; B=[0 .1246; -.222 -4.60; 29.0 2.55; ...
   0 0; 0 0]; C=[-.254 0 0 0 0]; D=[0 .1246]; Qay=5^2;; Q=C'*Qay*C;
N=C'*Qay*D; R=D'*Qay*D+eye(2); tf=2.5; s0=[0 0 0 0 0]'; Mf=eye(5);
Qf=1e5; psi=[0 0 0 0 10]'; Ns=50; tol=1e-4; 
if flg==1, [s,u,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns);
   ay=C*s+D*u;  ph=s(4,:); ps=s(5,:); v=s(1,:);
elseif flg==2, [s,u,t]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol);
   ay=C*s'+D*u; ph=s(:,4); ps=s(:,5); v=s(:,1);
end; da=u(1,:); dr=u(2,:); 
%
figure(1); clf; subplot(211), plot(t,ph); grid; ylabel('\phi (crad)')
subplot(212), plot(t,da,t,dr,'r--',t,ay,'k-.'); grid; xlabel('Time (sec)')
legend('\delta_a','\delta_r (crad)','a_y (ft/s^2)',3)
%
figure(2); clf; subplot(211), plot(t,ps); grid; ylabel('\psi (crad')
subplot(212); plot(t,v); grid; xlabel('Time (sec)'); ylabel('v (ft/sec)')


 