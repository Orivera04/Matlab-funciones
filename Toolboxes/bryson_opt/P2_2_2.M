% Script p2_2_2.m; Zermelo Pb. - max range with u_c=Vy/h;       
%                                               10/96, 3/23/02
%
u=.1*ones(1,39); k=-10; s0=[0 0]'; tf=2; tol=1e-4; mxit=50;
[u,s,la0]=dop0('dzrm0',u,s0,tf,k,tol,mxit); x=s(1,:); y=s(2,:);
% 
figure(1); clf; plot(x,y,x,y,'b.'); grid; xlabel('x'); 
ylabel('y');
	