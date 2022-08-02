% Script p2_5_7f.m; disc. calc. of min drag  nose shape using DOP0F;
% t--> x; s=[r d]'; r=radius, d=cumulative drag to x; d in units of 
% pi*q*a^2, [r,x) in 'a'=max radius; u=th, slope=tan(th);
%                                                3/97, 3/28/02
%
N=10; s0=[1 0]'; tf=4; name='dnshp'; la0=[.38 1]'; u0=.2;
title('Pb. 2.5.7b; Disc. Min Drag Nose Shape')
optn=optimset('Display','Iter','MaxIter',50);
la0=fsolve('dop0f',la0,optn,name,u0,s0,tf,N);
[f,s,u,la]=dop0f(la0,name,u0,s0,tf,N); r=s(1,:);  x=tf*[0:N]/N;
% 
figure(1); clf; plot(x,r,'b.',x,r,'b',x,-r,'b',x,-r,'b.');
grid; xlabel('x'); ylabel('r'); axis([0 4 -1.5 1.5])
	
	
