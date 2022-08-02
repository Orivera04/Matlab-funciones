% Script p5_4_12.m; helicopter hover position change using TLQH 
% (flg=1) or TLQHR (flg=2); x=[u q th y]'; u=dcy; units ft, sec, 
% crad, deci-in (for dcy);                              2/93, 7/24/02
%
flg=1;
A=[-.0257 .0130 -.322 0; 1.26 -1.765 0 0; 0 1 0 0; 1 0 0 -.001];
B=[.0860 -7.41 0 0]'; Q=zeros(4); N=zeros(4,1); R=1; x0=[0 0 0 0]';
tf=4; Ns=100; psi=[0 0 0 10]'; Mf=eye(4); Sf=zeros(4); t1=.85*tf;
tol=1e-4;                         
if flg==1, [x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Sf,Mf,psi,Ns);                 
elseif flg==2, [x,u,t,t1k,K]=tlqhr(A,B,Q,N,R,tf,x0,Sf,Mf,psi,t1,tol);
end
%
figure(1); clf; subplot(211), plot(t,x(4,:)); grid; axis([0 4 0 10])
ylabel('y (ft)'); subplot(212), plot(t,x(3,:),t,u,'r--'); grid
axis([0 4 -20 20]); xlabel('Time (sec)')
legend('\theta (crad)','\delta cy (deci-in)',2)

