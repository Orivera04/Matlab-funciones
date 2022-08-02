% Script p1_3_18.m; min weight inverted simple truss using 
% FMINCON; p=[th b32, b52];                       10/96, 6/27/02
%
optn=optimset('Display','Iter','MaxIter',500); N=30; W=.1*[1:N];
p=zeros(3,N+1); p(:,1)=[.5 .5 .5]'; lb=[0 0 0]; ub=[pi/2 5 5]; 
for i=2:N+1,
 p(:,i)=fmincon('invtruss_f',p(:,i-1),[],[],[],[],lb,ub,...
     'invtruss_c',optn,W(i-1)); end
for i=1:N, J(i)=invtruss_f(p(:,i+1),W(i)); end
th=p(1,[2:N+1]); b32=p(2,[2:N+1]); b52=p(3,[2:N+1]);
%
figure(1); clf; subplot(211), plot(W,3*J,'r--',W,180*th/pi,'b');
grid; axis([0 3 0 45]); text(.6,32,'\theta (deg)')
text(.6,18,'3*J'); subplot(212), plot(W,b32,'b',W,b52,'r--'); 
grid; axis([0 3 0 3]); text(2.2,1.4,'b3^2'); 
text(1.7,2.5,'b5^2'); xlabel('W')

