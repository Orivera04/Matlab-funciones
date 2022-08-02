% Script p2_5_2b.m;; DVDP for max range with uc=Vo*y/h using DOP0B;
%                                                     3/97, 3/28/02
%
N=5; s0=[0 0]'; tf=2; uf=0.0257; N1=N+1; sf0=[2.9578 1.2361]'; 
name='dzrm0'; optn=optimset('Display','Iter','MaxIter',100);
sf=fsolve('dop0b',sf0,optn,name,uf,s0,tf,N);
[f,s,u,la]=dop0b(sf,name,uf,s0,tf,N); x=s(1,:); y=s(2,:);
% 
figure(1); clf; plot(x,y,x,y,'.',x(N1),y(N1),'o'); grid;
axis([0 3 0 .75*3]); xlabel('x'); ylabel('y');
	
	
