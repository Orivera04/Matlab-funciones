% Script p6_2_10.m; inverted pendulum on a cart; x=[y v th q]';
%                                                12/96, 7/17/02
%
ep=.5; A=[0 1 0 0; 0 0 -ep 0; 0 0 0 1; 0 0 1 0]; B=[0 1 0 -1]'; 
C=[1 0 0 0; 0 0 1 0]; Q=eye(2); R=1; 
%
% RL vs. eta where J=int(eta*y'*Q*y + u^2)dt:
eta=[1e-8 10.^[-2:.5:3] 1e8]; N=length(eta); ev=zeros(4,N);
for i=1:N, [k,S,ev(:,i)]=lqr(A,B,eta(i)*C'*Q*C,R); end;
zc=ev(:,N); ev=ev(:,[1:N-1]);            % zc=compromise zeros
%
figure(1); clf; plot(real(ev),imag(ev),'x',real(zc),imag(zc),'ro'); 
grid; axis([-4 0 0 4]); axis('square'); xlabel('Real(s)');
ylabel('Imag(s)'); title('SRL for Inverted Pendulum on a Cart'); 
%
% Response to initial displacement:
[k,S,ev]=lqr(A,B,C'*Q*C,R); t=10*[0:.01:1]; u=zeros(size(t));
xo=[-1 0 0 0]'; D=[0 0]'; [y,x]=lsim(A-B*k,B,C,D,u,t,xo); u=-x*k';
%
figure(2); clf; subplot(211), plot(t,y(:,1)); grid
ylabel('y/l'); subplot(212), plot(t,y(:,2),t,u,'r--'); grid
xlabel('t*sqrt(g(M+m)/Ml)'); legend('th','f/(g(M+m)',4)  

