% Script p2_6_4n.m; max range in given time w. V=1+y using FOP0N
% (Fermat Pb.) ;	                                      4/97, 6/30/02
%
s0=[0 0]'; tf=2; th0=[1.302 1.274 1.243 1.209 1.172 1.132 1.087 ...
  1.038 .986 .928 .866 .798 .726 .649 .567 .480 .390 .296 .199 .100 0];
name='frm0'; optn=optimset('Display','Iter','MaxIter',100); 
th=fsolve('fop0n',th0,optn,name,s0,tf);
[f,s,la0]=fop0n(th,name,s0,tf); x=s(1,:); y=s(2,:);
%
figure(1); clf; plot(x,y,x,y,'b.',x(21),y(21),'ro'); grid 
xlabel('x'); ylabel('y')
	
	 
	   
	
	
