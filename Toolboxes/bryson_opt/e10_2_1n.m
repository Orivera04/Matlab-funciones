% Script e10_2_1n.m; singular problem using inverse control and FMINCON; 
% x2 key state variable, x1 by integration, u by differentiation; 
% N an odd integer;                                               11/3/01
%
tic; N=25; tf=1.5; p0=2*[-1:-1/N:0];
un=ones(1,N); lb=-3*un; ub=un; optn=optimset('display','iter');
p=fmincon('e10_2_1f',p0,[],[],[],[],lb,ub,'e10_2_1c',optn,N,tf); 
[f,u,x1]=e10_2_1f(p,N,tf); x2=[1 p(1:N) 0]; 
t=[0:N+1]/(N+1); t1=[.5:1:N+.5]/(N+1); 
%
figure(1); clf; subplot(411); plot(t,x1); grid; ylabel('x_1')
axis([0 1 0 1]) 
title('Singular Problem with Control Inequality Constraint')
subplot(412); plot(t,x2); grid; ylabel('x_2')
subplot(413), plot(t1,u); grid; axis([0 1 -1 1]); ylabel('u')
subplot(414), plot(t1,R); grid; ylabel('R'); xlabel('t/t_f')
toc