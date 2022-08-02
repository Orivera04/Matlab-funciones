% Script p2_2_2z.m; max range with uc=Vy/h & spec. yf;       6/10/02
%
u0=.1*ones(1,20); k=-.02; s0=[0 0]'; tf=2; tol=1e-4; mxit=50;
[u,s,la0]=dop0('dzrm0z',u0,s0,tf,k,tol,mxit); x=s(1,:); y=s(2,:);
% 
figure(1); clf; subplot(211), plot(x,y,x,y,'b.'); grid; xlabel('x')
axis tight; ylabel('y')
	