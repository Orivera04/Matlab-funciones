% Script f05_13.m; postion change of a hovering helicopter;
% x=[u q th y]'; u=dcy; units ft, sec, crad, deci-in (for
% dcy);                                        2/93, 4/4/02
%
A=[-.0257 .0130 -.322 0; 1.26 -1.765 0 0; 0 1 0 0; 1 0 0 0];
B=[.0860 -7.41 0 0]'; Q=zeros(4); N=zeros(4,1); R=1; 
x0=[0 0 0 0]'; tf=4; Ns=50; Mf=eye(4); Qf=1e4; 
psi=[0 0 0 10]'; [x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns);
%
figure(1); clf; subplot(211), plot(t,x(4,:));
grid; ylabel('Position y (ft)'); subplot(212)
plot(t,x(3,:),t,u); grid; xlabel('Time (sec)') 
legend('\theta (crad)','\delta_{cy} (deci-in)')
%print -deps2 \book_do\figures\f05_13
