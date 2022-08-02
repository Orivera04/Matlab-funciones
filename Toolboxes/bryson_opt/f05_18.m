% Script f05_18.m; dumping pitch angular momentum using gravity torque 
% and a reaction wheel; s=[th dq dh ep*thw]'; t in units of 1/omp, where
% omp=pitch libration frequency, e=armature voltage in omp^2*R*Iy/N,
% (dq, qw) in omp, dh in Iy*omp, ep=J/Iy; sg=(c+N^2/R)(1/Iy+1/J)/omp;
% response to impulse that produces dq(0+)=dh(0+)=.1;      7/97, 4/4/02
%
sg=50/pi; ep=.02; A=[0 1 0 0; -1 -sg sg/(1+ep) 0; -1 0 0 0; 0 -1 ...
      1 0]; B=[0 1 0 0]'; s0=[0 .2 .2 0]'; tf=pi/2; Ns=50; Q=zeros(4); 
N=zeros(4,1); R=1; Mf=eye(4); Qf=1e6; psi=[0 0 0 0]'; 
[s,u,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns); th=s(1,:); dq=s(2,:);
dh=s(3,:); edqw=dh-dq; ew=s(4,:); t=t/(2*pi); n=length(t); w=ew/ep;
% 
figure(1); clf; subplot(211), plot(t,th,'b',t,-ew,'r--',t,dh,'g-.');
grid; legend('\theta','-\epsilon\theta_w','dh',3); axis([0 .25 -.6 .6])
subplot(212), plot(t,dq,'b',t,-edqw,'r--',t,ep*u,'g-.'); grid
xlabel('\omega t/(2\pi)'); legend('dq','-\epsilon dq_w','\epsilon de',3)
pause(2);
%print -deps2 \book_do\figures\f05_18
%
% Movie of motion with wheel angle multiplied by ep:
figure(2); clf;
for j=1:181, z=(j-1)*2*pi/180; xc(j)=.5*cos(z); yc(j)=.5*sin(z); end
for i=1:n, 
   s=sin(th(i)); c=cos(th(i)); sw=sin(w(i))/2; cw=cos(w(i))/2; 
   plot([-s s],[-c c],'b',0,0,'ro',[0 sw],[0 cw],'r',-s,-c,'bo',...
   s,c,'bo',xc,yc,'r'); axis([-1.2 1.2 -1.2 1.2])
   axis('square'); axis off; pause(.4); if i<n, clf; end
end

