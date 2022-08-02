% Script p2_5_2n.m;; DVDP for max range with V=1+y using DOP0N;
%                                                 4/97, 3/28/02
%
N=5; u0=.1*ones(1,N); s0=[0 0]'; tf=2; name='dzrm0';
optn=optimset('Display','Iter','MaxIter',100); N1=N+1;
u=fsolve('dop0n',u0,optn,name,s0,tf);
[f,s,la0]=dop0n(u,name,s0,tf); uh=[u u(N)]; x=s(1,:); y=s(2,:);
t=tf*[0:1/N:1];
% 
figure(1); clf; plot(x,y,x,y,'.',x(N1),y(N1),'o'); grid;
axis([0 3 0 .75*3]); xlabel('x'); ylabel('y');
%
figure(2); clf; zohplot(t,uh); grid; xlabel('Time'); ylabel('u');
	
	
