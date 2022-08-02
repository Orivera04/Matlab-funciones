% Script p5_2_11.m; control tip deflec. of flexible robot arm with
% shoulder torque; x=[th1 q1 th2 q2]'; u=T; y in l, time in 1/om, 
% q in om, om=2.782*sqrt(k/ml^2), T in k;              2/93, 3/31/02
%
flg=1; 
ep=.4251; b=.2003; A=[0 1 0 0; -ep 0 ep 0; 0 0 0 1; 1-ep 0 -1+ep 0];
B=[0 b 0 b-ep]'; Q=zeros(4); N=zeros(4,1); R=1; s0=[0 0 0 0]';
tf=2*pi; Qf=3e4; Mf=eye(4); Ns=40; psi=[.25 0 .25 0]'; tol=1e-4;
if flg==1, [s,u,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns);
   th1=s(1,:); th2=s(3,:); 
elseif flg==2, [s,u,t,tk,K]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol);
   th1=s(:,1); th2=s(:,3);
end; yt=sin(th1)+sin(th2); t=t/tf; 
n=length(t); xe=cos(th1); ye=sin(th1); xt=xe+cos(th2);  
%
figure(1); clf; ; t=t/tf; subplot(211),plot(t,yt); ylabel('y/l')
grid; subplot(212); plot(t,th1,t,th2,t,u/5,'--'); grid  
xlabel('\omega t/(2\pi)'); text(.12,.6,'T/5')
text(.32,.7,'\theta_1'); text(.32,-.75,'\theta_2'); pause(2)
%
if flg==1, figure(2); clf; 
for i=1:2:n-1,
   plot([0 2],[0 0],'r',0,0,'rs',[0 xe(i)],[0 ye(i)],'b',...
   [xe(i) xt(i)],[ye(i),yt(i)],'b',xe(i),ye(i),'rs',xt(i),...
   yt(i),'ro',2,0,'r+'); axis([-.1 2.1 -.65 1.55]); axis('square')
   axis off; pause(.05); hold on  
end; 
for i=n,
   plot([0 2],[0 0],'r',0,0,'rs',[0 xe(i)],[0 ye(i)],'b',...
   [xe(i) xt(i)],[ye(i),yt(i)],'b',xe(i),ye(i),'rs',xt(i),...
   yt(i),'ro',2,0,'r+'); axis([-.1 2.1 -.8 1.4]); axis('square')
   axis off; 
end; end
%
if flg==2, figure(3); clf; plot(tk/tf,K); grid; xlabel('t/t_f');
ylabel('Fdbk Gains'); axis([0 1 -300 300]); end
