% Script f05_02.m; trans. matrix soln. of intercept 
% problem w. soft term. constr; t in tf, v in v0, y 
% in v0*tf, a in v0/tf;                4/97, 4/3/02
%
A=[0 1; 0 0]; B=[0 1]'; x0=[0 1]'; Q=zeros(2);
N=[0 0]'; R=1; tf=1; Mf=[1 0]; Qf=3e4; psi=0; 
Ns=40; [x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns);
y=x(1,:); v=x(2,:); a=u;
%
figure(1); clf; subplot(211),plot(t,y); grid
axis([0 1 0 .2]); 
text(.2,.11,'y/(v_ot_f)=t(1-.5t)(1-t)')
subplot(212); plot(t,a/3,t,v,'-'); grid
axis([0 1 -1 1]); text(.25,.52,'v/v_o=1-3t+1.5t^2')
text(.71,.12,'at_f/(3v_o)=t-1'); xlabel('t/t_f')
%print -deps2 \book_do\figures\f05_02
%
Mf=eye(2); psi=[0 0]'; 
[x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns);
y=x(1,:); v=x(2,:); a=u;
%
figure(2); clf; subplot(211),plot(t,y); grid;
axis([0 1 0 .2]); text(.2,.09,'y/(v_ot_f)=t(1-t)^2')
subplot(212); plot(t,a/4,t,v,'-'); grid
axis([0 1 -1 1]); text(.25,.52,'v/v_o=(1-t)(1-3t^2)')
text(.65,.6,'at_f/(4v_o)=1.5t-1'); xlabel('t/t_f')
%print -deps2 \book_do\figures\f05_03

