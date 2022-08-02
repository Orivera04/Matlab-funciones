% Script mehr1.m; Mehra/Davis Pb. #3 using TLQH & TLQS;    1/11/02
%
tf=.49; x0=[0 -1]'; Ns=40; Qf=zeros(2); 
A=[0 1; 0 -1]; B=[0 1]'; Q=eye(2); N=[0 0]'; R=.005; Mf=Q; 
psi=-[.4992 .16]'; [x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Qf,Mf,psi,Ns);
x0=-[.4992 .16]'; tf=.51; Mf=[0 0]; psi=0; Qf=0;
[x1,u1,t1]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns);
t1=t1+.49*ones(1,41);
%
figure(1); clf; subplot(311); plot(t,x(1,:),t1,x1(1,:),'b'); grid; 
ylabel('x_1'); axis([0 1 -.55 .05]); 
title('Mehra-Davis Inequality Constraint Problem 3')
subplot(312); plot(t,x(2,:),t1,x1(2,:),'b'); grid; ylabel('x_2'); 
axis([0 1 -1.2 .2]); subplot(313); plot(t,u,t1,u1,'b',...
    [.49 .49],[5 15.1],'b'); grid; axis([0 1 -4 16]); ylabel('u');
xlabel('Time')