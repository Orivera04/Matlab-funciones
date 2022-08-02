% Script p1_2_16.m; min weight inverted cantilever truss, implicit
% analytical solution using FSOLVE;           1/92, 10/96, 3/20/02
%
p0=[.6 5]; optn=optimset('MaxIter',100);
W=[.01:.01:.09 .1:.05:.7]'; N=length(W); p=zeros(N,2);
p(1,:)=fsolve('invcantr',p0,optn,W(1)); 
for i=2:N, p(i,:)=fsolve('invcantr',p(i-1,:),optn,W(i)); end
th=p(:,1); z=p(:,2); c=180/pi; un=ones(N,1); b=un./z;
J=W./tan(th)+un./(z.*cos(th));
%
figure(1); clf; subplot(211), plot(W,30*b,'b',W,c*th,'r--'); grid
axis([0 .7 0 50]); legend('30/z','\theta (deg)',4) 
subplot(212), plot(W,J); grid; ylabel('J'); xlabel('W bar')
axis([0 .7 0 3])
