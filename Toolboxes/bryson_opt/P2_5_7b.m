% Script p2_5_7b.m; disc. calc. of min drag nose shape using DOP0B;
% t--> x; s=[r d]'; r=radius, d=cumulative drag to x; d in units of
% pi*q*a^2, [r,x) in 'a'=max radius; u=th, slope=tan(th);
%                                                    3/97, 3/28/02
%
N=10; s0=[1 0]'; tf=4; name='dnshp'; uf=.4; sf=[.03 .1]';
optn=optimset('Display','Iter','MaxIter',50);
sf=fsolve('dop0b',sf,optn,name,uf,s0,tf,N);
[f,s,u]=dop0b(sf,name,uf,s0,tf,N); r=s(1,:); x=tf*[0:N]/N;
% 
figure(1); clf; plot(x,r,'b.',x,r,'b',x,-r,'b',x,-r,'b.'); 
grid; xlabel('x'); ylabel('r'); axis([0 4 -1.5 1.5])
	
	
