% Script p2_5_2f.m;; DVDP for max range with uc=Vo*y/h using DOP0F;
%                                                     3/97, 3/28/02
%
N=5; s0=[0 0]'; tf=2; N1=N+1;la0=[1 2]'; u0=1; name='dzrm0';
optn=optimset('Display','Iter','MaxIter',100);
la0=fsolve('dop0f',la0,optn,name,u0,s0,tf,N);
[f,s,u,la]=dop0f(la0,name,u0,s0,tf,N); x=s(1,:); y=s(2,:);
% 
figure(1); clf; plot(x,y,x,y,'.',x(N1),y(N1),'o'); grid 
axis([0 3 0 .75*3]); xlabel('x'); ylabel('y')
	
	
