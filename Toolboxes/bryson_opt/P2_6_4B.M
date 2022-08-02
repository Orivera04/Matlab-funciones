% Script p2_6_4b.m; max range in given time with V=1+y using FOP0B
% (Fermat Pb.); 		                             3/97, 6/30/02
%
sf=[3.6268 2.7622]'; tf=2; s0=[0 0]'; name='frm0';
optn=optimset('Display','Iter','MaxIter',100);
sf=fsolve('fop0b',sf,optn,name,s0,tf);
[f,t,y]=fop0b(sf,name,s0,tf); x=y(:,1); y1=y(:,2); N=length(t);
%
figure(1); clf; plot(x,y1,x,y1,'b.',0,0,'ro',x(N),y1(N),'ro');
grid;  xlabel('x'); ylabel('y'); axis([0 4 0 3])
	
	 
	   
	
	
