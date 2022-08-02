% Script yeo_pb.m; B. P. Yeo's manipulator problem using inverse 
% control and FMINCON; x2 key state variable, x1 by integration, 
% u by differentiation; N an odd integer;                11/3/01
%
tic 
N=25; tf=.85; a=2.406; b=8.55; r1=73; r2=41.15; r3=5.8; r4=37.2;
M=1+(N+1)/2; for i=2:M, p0(i)=(i-1)*2.35/13; end
for i=M+1:N+1, p0(i)=2.35-(i-M)*2.35/(M-1); end
un=ones(1,N); lb=0*un; ub=3*un; optn=optimset('display','iter');
p=fmincon('yeo_f',p0,[],[],[],[],lb,ub,'yeo_c',optn,N,tf,a,b,...
    r1,r2,r3,r4); [f,u,x1]=yeo_f(p,N,tf,a,b,r1,r2,r3,r4); 
x2=[0 p(1:N) 0]; t=[0:N+1]/(N+1); t1=[.5:1:N+.5]/(N+1); 
x2b=(x2(2:N+2)+x2(1:N+1))/2; 
R=x2b.^4+r1*u.^2-r2*x2b.*u+r3*x2b.^2-r4*ones(1,N+1);
%
figure(1); clf; subplot(411); plot(t,x1); grid; ylabel('x_1')
axis([0 1 0 1]); title('Yeo Inequality Constraint Problem')
subplot(412); plot(t,x2); grid; ylabel('x_2')
subplot(413), plot(t1,u); grid; axis([0 1 -1 1]); ylabel('u')
subplot(414), plot(t1,R); grid; ylabel('R'); xlabel('t/t_f')
toc