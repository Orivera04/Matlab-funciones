% Script p4_2_4.m; DVDP for min tf to spec. (xf,yf) w. V=1+y using
% FMINCON; dual of Pb. 3.1.4;			             2/97, 3/29/02
%
th=[.8:-.16:-.8]; tf=2; p0=[th tf]; xf=2.3472; yf=0; 
optn=optimset('Display','Iter','MaxIter',200);
p=fmincon('dfrmt_f',p0,[],[],[],[],[],[],'dfrmt_c',optn,xf,yf);
[c,ceq,x,y]=dfrmt_c(p,xf,yf); N=length(x);
%
figure(1); clf; plot(x,y,x,y,'b.',x(N),y(N),'ro',0,0,'ro'); 
grid; xlabel('x'); ylabel('y'); axis([0 2.4 -.6 1.2])
 	
	