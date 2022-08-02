% Script p6_3_07.m; DLQR for cart with inv. pend.; s=[y v th q]'; 
% J=int(s'C'QCs+u'Ru)dt;                            7/92, 7/17/02
%
ep=.5; A=[0 1 0 0; 0 0 -ep 0; 0 0 0 1; 0 0 1 0]; B=[0 1 0 -1]';
C=[1 0 0 0; 0 0 1 0]; D=[0 0]'; Q=[1e-8 10.^[-3:.5:1] 1e8]; R=1; 
Ts=.1; N=length(Q); ev=zeros(4,N);
for i=1:N, [k,S,ev(:,i)]=lqrd(A,B,Q(i)*C'*C,R,Ts); end;
zc=ev(:,N); ev=ev(:,[1:N-1]);                  % zc=compromise zeros
%
figure(1); clf; plot(real(ev),imag(ev),'bx',real(zc),imag(zc),'ro'); 
grid; axis([.85 1 0 .15]); axis('square'); xlabel('Real(z)');
ylabel('Imag(z)')
%
[Ad,Bd]=c2d(A,B,Ts); Q=1; k=lqrd(A,B,C'*Q*C,R,Ts); 
t=[0:Ts:10]'; w=zeros(size(t)); s0=[-1 0 0 0]';
[y,s]=dlsim(Ad-Bd*k,Bd,C,D,w,s0); u=-s*k';
%
figure(2); clf; subplot(211), plot(t,y(:,1)); grid 
axis([0 10 -1.2 .2]); ylabel('y'); subplot(212);
plot(t,y(:,2),'r--'); grid; axis([0 10 -.9 .5]); hold on
zohplot(t,u,'b'); hold off; legend('\theta','f'); xlabel('t')
