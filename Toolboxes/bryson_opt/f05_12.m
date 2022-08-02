% Script f05_12.m; control tip deflec. of flexible  robot arm 
% with shoulder torque; x=[th1 q1 th2 q2]'; u=T; y in l, time
% in 1/om, q in om, om=2.782*sqrt(k/ml^2), T in k; 2/93, 4/4/02
%
ep=.4251; A=[0 1 0 0; -ep 0 ep 0; 0 0 0 1; 1-ep 0 -1+ep 0];
B=[0 .2003 0 -.2248]'; Q=zeros(4); N=zeros(4,1); R=1;
x0=[0 0 0 0]'; tf=2*pi; Qf=1e6; Mf=eye(4); Ns=14; 
psi=[.25 0 .25 0]'; [x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns);
th1=x(1,:); th2=x(3,:); yt=sin(th1)+sin(th2); 
%
figure(1); clf; ; t=t/tf; subplot(211),plot(t,yt); grid
ylabel('y/l'); subplot(212); plot(t,th1,t,th2,t,u/5,'--'); 
grid; xlabel('\omega t/(2\pi)'); text(.12,.6,'T/5');
text(.32,.7,'\theta_1'); text(.32,-.75,'\theta_2'); pause(2)
%
n=length(t); xe=cos(th1); ye=sin(th1); xt=xe+cos(th2);  
figure(2); clf; for i=1:n,
   plot([0 2],[0 0],'b--',0,0,'rs',[0 xe(i)],[0 ye(i)],'b',...
   [xe(i) xt(i)],[ye(i),yt(i)],'b',xe(i),ye(i),'rs',xt(i),...
   yt(i),'ro',2,0,'ro'); axis([-.1 2.1 -1.1 1.1]);
   axis('square'); axis off; pause(.4); 
   if i<n, clf; end; hold on 
end
%print -deps2 \book_do\figures\f05_12
