% Script mehr2.m; Mehra/Davis Pb. #2 using TLQH & TLQS; tt1 and tt2 
% chosen so that u is continuous at those points (tangential entry 
% and exit);                                               1/11/02
%
tt1=.3152; x0=[0 -1]'; Ns=40; A=[0 1; 0 -1]; B=[0 1]'; 
Q=eye(2); N=[0 0]'; R=.005; Qf=zeros(2); Mf=[0 1]; psi=8*(tt1-.5)^2-.5; 
[x,u,t]=tlqh(A,B,Q,N,R,tt1,x0,Qf,Mf,psi,Ns);
u1=8*(tt1-.5)^2-.5+16*(tt1-.5); tt2=.7000; 
tc=[tt1 .32:.01:.68 tt2]; un=ones(1,length(tc)); 
x2c=8*(tc-.5*un).^2-.5*un; x1c=8*(tc-.5*un).^3/3-.5*tc+.092*un;
uc=x2c+16*(tc-.5*un); x02=[8*(tt2-.5)^3/3-.5*tt2+.092; 8*(tt2-.5)^2-.5];
Mf=[0 0]; psi=0; Qf=0; clear u1
[x1,u1,t1]=tlqs(A,B,Q,N,R,1-tt2,x02,Mf,Qf,psi,Ns);
t1=t1+tt2*ones(1,41); t2=.23:.01:.78; un2=ones(1,length(t2));
c=8*(t2-.5*un2).^2-.5*un2;
%
figure(1); clf; subplot(311); plot(t,x(1,:),tc,x1c,'b',t1,x1(1,:),'b'); 
grid; ylabel('x_1'); axis([0 1 -.25 0]); 
title('Mehra-Davis Inequality Constraint Problem 2')
subplot(312); plot(t,x(2,:),tc,x2c,'b',t1,x1(2,:),'b',t2,c,'r--'); grid;
ylabel('x_2'); axis([0 1 -1 .05]); subplot(313); plot(t,u,tc,uc,'b',...
    t1,u1,'b'); grid; axis([0 1 -5 15]); ylabel('u'); xlabel('Time')
