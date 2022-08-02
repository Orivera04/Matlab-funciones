% Script p5_2_22.m; landing flare of STOL A/C; u=[de dn]'; s=[u ga th 
% q h]'; xdot=Ax+Bu; 2J=ef'*Qf*ef+int[de^2+dn^2]dt; % units ft, sec,
% deg;                                                     9/97, 7/11/02
%
A=[-.0397 -.280 -.282 0 0; .135 -.538 .538 .0434 0; 0 0 0 1 0; .0207 ...
  .441 -.441 -1.41 0; -.017 1.92 0 0 0]; B=[-.0052 -.102; .031 .037; ...
  0 0; -1.46 -.066; 0 0]; Q=zeros(5); N=zeros(5,2); R=diag([1 1/36]);
tf=12; x0=[0 -7 -4 0 68]'; Mf=[1 0 0 0 0; 0 1 0 0 0; 0 0 0 0 1]; Qf=1e4;
psi=[0 -1 0]'; Ns=100; [x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns); 
%
figure(1); clf; subplot(311), plot(t,x(5,:)); grid; ylabel('h (ft)')
axis([0 tf 0 80]); title('STOL A/C Landing Flare'); subplot(312)
plot(t,x([1:3],:)); legend('u (ft/sec)','\gamma (deg)','\theta (deg)',2)
grid; subplot(313),plot(t,u); grid; legend('\delta e','\delta n',2)
xlabel('Time (sec)'); ylabel('deg')

