% Script mehr.m; Mehra/Davis Pb. #3 using TLQH & TLQS; tt chosen 
% so that u is continuous;                                 1/13/02
%
tt=.4685; x0=[0 -1]'; Ns=40; A=[0 1; 0 -1]; B=[0 1]'; 
Q=eye(2); N=[0 0]'; R=.005; Qf=zeros(2); Mf=Q; 
psi=[8*(tt-.5)^2-.5 16*(tt-.5)]'; 
[x,u,t]=tlqh(A,B,Q,N,R,tt,x0,Qf,Mf,psi,Ns);
x0=psi; tf=1-tt; Mf=[0 0]; psi=0; Qf=0;
[x1,u1,t1]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns);
t1=t1+tt*ones(1,41); t2=.23:.01:.78; un2=ones(1,length(t2));
c=8*(t2-.5*un2).^2-.5*un2;
%
figure(1); clf; subplot(311); plot(t,x(1,:),t1,x1(1,:),'b',...
    t2,c,'r--'); grid; ylabel('x_1'); axis([0 1 -.55 .05]); 
title('Mehra-Davis Inequality Constraint Problem 3')
subplot(312); plot(t,x(2,:),t1,x1(2,:),'b'); grid; ylabel('x_2'); 
axis([0 1 -1.2 .2]); subplot(313); plot(t,u,t1,u1,'b'); grid;
axis([0 1 -4 12]); ylabel('u'); xlabel('Time')
