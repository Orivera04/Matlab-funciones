% Script p6_2_09.m; cart with pendulum; x=[y ydot th thdot]'; 
% J=int(y'*Q*y+u'Ru)dt;	                                 7/92, 7/17/02
%
ep=.5; C=[1 0 0 0; 0 0 1 0]; A=[0 1 0 0; 0 0 ep 0; 0 0 0 1; 0 0 -1 0];
B=[0 1 0 -1]'; D=[0 0]'; Q=[1e-8 10.^[-2:.5:1] 10^5]; N=length(Q);
ev=zeros(4,N); for i=1:N, [k,S,ev(:,i)]=lqr(A,B,C'*Q(i)*C,1); end
zc=ev(:,N); ev=ev(:,[1:N-1]);                    % zc=compromise zeros
%
figure(1); clf; plot(real(ev),imag(ev),'x',real(zc),imag(zc),'ro');
grid; axis([-1.5 0 0 1.5]); axis('square'); xlabel('Real(s)')
ylabel('Imag(s)')
%
k=lqr(A,B,C'*C,1); t=4*pi*[0:.01:1]'; w=zeros(length(t),1);
xo=[-1 0 0 0]'; [y,x]=lsim(A-B*k,B,C,D,w,t,xo); u=-x*k'; t=t/(2*pi);
%
figure(2); clf; subplot(211), plot(t,y(:,1)); grid; ylabel('y')
axis([0 2 -1 .5]); subplot(212), H=plot(t,y(:,2),t,u,'r--'); grid 
axis([0 2 -.5 1]); legend('f','\theta'); xlabel('t / 2 \pi')


