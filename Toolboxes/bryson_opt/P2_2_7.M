% Script p2_2_7.m; disc. calculation of min drag nose shape; t--> x;
% s=[r d]'; r=radius, d=cumulative drag to x, in units of pi*q*a^2;
% [r,x) in a=max radius; u=th, slope=tan(th);    4/97, 1/98, 3/23/02
%
N=10; u=.3*ones(1,N); s0=[1 0]'; tf=4; k=.2; tol=1e-4; mxit=100;
[u,s,la0]=dop0('dnshp',u,s0,tf,k,tol,mxit); r=s(1,:); x=tf*[0:1/N:1];
%
figure(1); clf; plot(x,r,'b',x,-r,'b',x,r,'b.',x,-r,'b.'); grid
xlabel('x'); ylabel('r'); axis([0 4 -1.5 1.5]);
	
	
