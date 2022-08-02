% Script p5_4_15.m; dumping pitch angular momentum using gravity torque 
% and a reaction wheel; s=[th dq dh ep*thw]'; t in units of 1/omp, where
% omp=pitch libration frequency, e=armature voltage in omp^2*R*Iy/N,
% (dq, qw) in omp, dh in Iy*omp, ep=J/Iy; sg=(c+N^2/R)(1/Iy+1/J)/omp;
% response to impulse that produces dq(0+)=dh(0+)=.1;      7/97, 7/25/02
%
flg=1; sg=50/pi; ep=.02; A=[0 1 0 0; -1 -sg sg/(1+ep) 0; -1 0 0 0; ...
  0 -1 1 0]; B=[0 1 0 0]'; s0=[0 .2 .2 0]'; tf=pi/2; Ns=50; Q=zeros(4); 
N=zeros(4,1); R=1; Mf=eye(4); Sf=zeros(4); psi=[0 0 0 0]';
if flg==1, [s,u,t]=tlqh(A,B,Q,N,R,tf,s0,Sf,Mf,psi,Ns); th=s(1,:);
 dq=s(2,:); dh=s(3,:); edqw=dh-dq; ew=s(4,:); t=t/(2*pi); n=length(t);
elseif flg==2, t1=.9*tf; tol=1e-4;
 [s,u,t]=tlqhr(A,B,Q,N,R,tf,s0,Sf,Mf,psi,t1,tol); th=s(:,1); dq=s(:,2);
 dh=s(:,3); edqw=dh-dq; ew=s(:,4); t=t/(2*pi); n=length(t);
end
% 
figure(1); clf; subplot(211), plot(t,th,'b',t,-ew,'r--',t,dh,'k-.');
grid; legend('\theta','-\epsilon\theta_w','dh',3); axis([0 .25 -.6 .6])
subplot(212), plot(t,dq,'b',t,-edqw,'r--',t,ep*u,'k-.'); grid
xlabel('\omega t/(2\pi)'); legend('dq','-\epsilon dq_w','\epsilon de',3)
pause(2)
%
% Movie of motion with wheel angle multiplied by ep:
if flg==1, figure(2); clf;
 for i=1:n-1, 
   s=sin(th(i)); c=cos(th(i)); sw=sin(ew(i))/2; cw=cos(ew(i))/2; 
   plot([-s s],[-c c],'b',0,0,'ro',[-sw sw],[-cw cw],'r',-s,-c,'bo',...
   s,c,'bo',-sw,-cw,'ro',sw,cw,'ro'); axis([-1.2 1.2 -1.2 1.2])
   axis('square'); axis off; pause(.05); clf;
 end
 i=n; 
 s=sin(th(i)); c=cos(th(i)); sw=sin(ew(i))/2; cw=cos(ew(i))/2; 
 plot([-s s],[-c c],'b',0,0,'ro',[-sw sw],[-cw cw],'r',-s,-c,'bo',...
 s,c,'bo',-sw,-cw,'ro',sw,cw,'ro'); axis([-1.2 1.2 -1.2 1.2]);
 axis('square'); axis off 
end



