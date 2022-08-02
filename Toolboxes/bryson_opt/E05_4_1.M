% Script e05_4_1.m; Lateral intercept and rendezvous w. hard terminal
% constraints; solution by transition matrix; t in tf, v in vo, y in
% vo*tf a in vo/tf;                                     4/97, 6/18/02
%
A=[0 1; 0 0]; B=[0 1]'; Q=zeros(2); N=[0 0]'; R=1; tf=1; x0=[0 1]';
Sf=zeros(2); Mf=[1 0]; psi=0; Ns=40;
[x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Sf,Mf,psi,Ns);
%
figure(1); clf; subplot(211), plot(t,x(1,:)); grid; axis([0 1 0 .2])
ylabel('y/(v_ot_f'); subplot(212); plot(t,x(2,:),t,u/3,'-'); 
grid; axis([0 1 -1 1]); xlabel('t/t_f'); legend('v/v_o','at_f/3v_o') 
%
Mf=eye(2); psi=[0 0]'; [x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Sf,Mf,psi,Ns);
%
figure(2); clf; subplot(211), plot(t,x(1,:)); grid; axis([0 1 0 .15])
ylabel('y/(v_ot_f)'); subplot(212),plot(t,x(2,:),t,u/4,'-');
axis([0 1 -1 1]); grid; xlabel('t/t_f'); legend('v/v_o','at_f/4v_o',4) 

