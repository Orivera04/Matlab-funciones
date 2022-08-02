% Script f09_20.m; min time pick-and-place motion of two-link robot
% arm using switch times as parameters; both links of length L and mass
% m, tip mass=mu*m, (Qe,Qs)=(shoulder,elbow) torques in units of max 
% torque=Qmax; time in units of tc=sqrt(m*L^2/Qmax), (oms,ome)=angular
% velocities of (shoulder,elbow) links in 1/tc, D=tip distance traveled
% in units of L (Dmax=4), tf in units of tc; uses symmetry about tf/2;
%                                                         4/98, 5/20/01 
clear; D=3.9; mu=1; p=[1.1373 -.0972 -.2048 2.9138]; tf=p(4); 
[f,g,t,s]=robo1_fg(p,mu,D); ti=(tf/2)*[0:.02:1]; si=interp1(t,s,ti);
ths=si(:,3); the=si(:,4); n=length(ti);
for i=1:n, ths1(i)=-ths(n+1-i)-pi; the1(i)=-the(n+1-i)+2*pi; end
ths=[ths' ths1]; the=[the' the1];
te=[ti ti+(tf/2)*ones(1,n)]'; t1=p(1)/tf; N=length(te); un=ones(N,1);
xe=cos(ths); ye=sin(ths); xt=xe+cos(the+ths); yt=ye+sin(the+ths);
x1=[0*un xe' xt']; y1=[0*un ye' yt']; 
%
figure(1); for k=1:2; clf; for i=1:N, 
   plot(x1(i,:),y1(i,:),'b',xe(i),ye(i),'ro',xt(i),yt(i),'ro',0,0,'bo',...
      xt,yt,'g--',xt(1),yt(1),'ro',xt(N),yt(N),'ro'); axis([-2 2 -1.5 1]);
   axis off; if i==1, pause(3); else pause(.1); end
end; pause(2); end; pause(2) 
%
figure(2); clf; for i=1:10:N, 
   plot(x1(i,:),y1(i,:),'b',xe(i),ye(i),'ro',xt(i),yt(i),'ro',0,0,'bo',...
      xt,yt,'g--',xt(1),yt(1),'ro',xt(N),yt(N),'ro'); axis([-2 2 -1.5 1]);
   axis off; hold on 
end; hold off 
