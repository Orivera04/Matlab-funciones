% Script p10_2_1.m; discretization of Ex. 10.2.1 (an
% impulse-singular-impulse nonminimum phase pb.); x=[x1 x2]';
% J=int(0:tf)x1^2dt; x(0)=[1 1]'; x(tf)=[0 0]';   1/96, 3/30/02 
%
tf=1.5; N=6; Ts=tf/N; t=tf*[0:1/N:1]; 
% A=[0 1; 0 0]; B=[1 -1]'; [Ad,Bd]=c2d(A,B,Ts); N=[0 0]'; 
% Q=[1 0; 0 0]; R=1e-4; [Ad,Bd,Qd,Nd,Rd]=cvrt(A,B,Q,N,R,Ts);
Ad=[1 Ts; 0 1]; Bd=[Ts-Ts^2/2 -Ts]'; x0=[1 1]'; Qd=[Ts Ts^2/2; ...
  Ts^2/2 Ts^3/3]; Rd=Ts^3/3-Ts^4/4+Ts^5/20; Nd=[Ts^2/2-Ts^3/6 ...
  Ts^3/3-Ts^4/8]'; Mf=eye(2); Qf=3000; psi=[0 0]';
[s,u]=tdlqs(Ad,Bd,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N);
uh=[u u(N)]; x1=s(1,:); x2=s(2,:);
%
figure(1); clf; plot(x1,x2,1,1,'ro',0,0,'ro'); grid; 
xlabel('x_1'); ylabel('x_2');
%
figure(2); clf; subplot(311), plot(t,x1); grid; ylabel('x_1');
subplot(312); plot(t,x2); grid; ylabel('x_2'); subplot(313); 
zohplot(t,uh); grid; ylabel('u'); xlabel('Time');
