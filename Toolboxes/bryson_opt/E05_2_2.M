% Script e05_2_2; trans. matrix soln. of intercept problem with
% soft terminal constraints; t in tf, v in v0, y in v0*tf, a in
% v0/tf;                                          5/98, 6/18/02
%
A=[0 1; 0 0]; B=[0 1]'; x0=[0 1]'; Q=zeros(2); N=[0 0]'; R=1; 
tf=1; Mf=[1 0]; Qf=3e4; psi=0; Ns=40; 
[x,a,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns); y=x(1,:); v=x(2,:); 
%
figure(1); clf; subplot(211),plot(t,y); grid; axis([0 1 0 .2]) 
ylabel('y/v_ot_f'); subplot(212); plot(t,a/3,t,v,'r--');
axis([0 1 -1 1]); legend('v/v_o','at_f/3v_o'); grid
xlabel('t/t_f')

