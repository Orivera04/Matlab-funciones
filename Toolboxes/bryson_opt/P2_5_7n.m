% Script p2_5_7n.m; disc. calc. of min drag  nose shape using DOP0N;
% t--> x; s=[r d]'; r=radius, d=cumulative drag to x; d in units of
% pi*q*a^2, [r,x) in a=max radius; u=th, slope=tan(th);
%                                                   3/97, 3/28/02
%
N=10; s0=[1 0]'; tf=4; name='dnshp'; u0=[.184 .189 .195 .202 .210 ...
    .221 .236 .256 .292 .381]; 
optn=optimset('Display','Iter','MaxIter',50);
u=fsolve('dop0n',u0,optn,name,s0,tf);
[f,s,la0]=dop0n(u,name,s0,tf); r=s(1,:); x=tf*[0:1/N:1];
% 
figure(1); clf; plot(x,r,'b.',x,r,'b',x,-r,'b',x,-r,'b.'); 
grid; xlabel('x'); ylabel('r'); axis([0 4 -1.5 1.5])
	
	
