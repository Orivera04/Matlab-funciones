% Script 6.3.02.m; DLQR for double integrator plant, showing almost
% negligible effect of not converting contin. QPI to equivalent
% discrete QPI;                                           2/94, 7/17/02
%
A=[0 1; 0 0]; B=[0 1]'; C=[1 0]; Q=C'*C; N=[0 0]'; R=1; Ts=.25;
Qd=[Ts Ts^2/2; Ts^2/2 Ts^3/3]; Nd=[Ts^3/6 Ts^4/8]'; Rd=Ts+Ts^5/20; 
[Ad,Bd]=c2d(A,B,Ts); 
k2=lqrd(A,B,Q,R,Ts)                   % Equivalent disc. QPI using LQRD
k=dlqr(Ad,Bd,Qd,Rd,Nd)                % Equivalent disc. QPI using DLQR
k1=dlqr(Ad,Bd,Q*Ts,R*Ts)                          % Nd=0, approx. Qd,Rd
p=eig(Ad-Bd*k), p1=eig(Ad-Bd*k1)
num=[1 2 1 0]; den=[1 -4 6 -4 1]; sys=tf(num,den,Ts); 
s0=[-1 0]'; w=zeros(35,1); t=Ts*[0:34]';
[y ,x ]=dlsim(Ad-Bd*k ,Bd,C,0,w,s0);  u=-x* k';
[y1,x1]=dlsim(Ad-Bd*k1,Bd,C,0,w,s0); u1=-x1*k1'; 
for i=1:181, xc(i)=cos(pi*(i-1)/90); yc(i)=sin(pi*(i-1)/90); end
%
figure(1); clf; rlocus(sys); grid; hold on; plot(xc,yc,'r--');
hold off; axis([-1.2 1.2 -1.2 1.2]); axis('square')
%
figure(2); clf; subplot(211), plot(t,x,t,x1,'r--'); grid
text(1.5,-.7,'x_1'); text(1.5,.3,'x_2'); axis([0 8 -1.2 .6])
subplot(212), zohplot(t,u); hold on; zohplot(t,u1,'r--'); hold off
grid; axis([0 8 -.3 1]); xlabel('t'); ylabel('u')
legend('Equiv. QPI','Approx QPI')

 