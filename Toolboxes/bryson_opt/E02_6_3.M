% Script e02_6_3.m; min drag nose shape using FOP0B; 3/97, 6/18/02
%
tf=4; s0=[0 1]'; name='noshp'; sf=[.0971 .0228]'; 
optn=optimset('Display','Iter','MaxIter',500);
sf=fsolve('fop0b',sf,optn,name,s0,tf);
[f,t,y]=fop0b(sf,name,s0,tf); d=y(:,1); r=y(:,2); N=length(t);  
%
figure(1); clf; plot(t,r,t,-r,'b',[3.995 3.995],[r(1) -r(1)]); 
grid; axis([0 4 -1.5 1.5]); xlabel('x/a'); ylabel('r/a')
	
	