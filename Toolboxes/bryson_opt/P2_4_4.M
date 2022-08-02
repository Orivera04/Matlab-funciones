% Script p2_4_4.m;  max range in given time with V=1+y (Fermat
% Pb.);                                           2/97, 7/2/02
%
name='frm0'; N=20; tf=2; tu=tf*[0:1/N:1]'; u=.5*ones(N+1,1);
s0=[0 0]'; k=-.1; told=1e-4; tols=1e-4; mxit=50;
[t,u,s,la0]=fop0(name,tu,u,tf,s0,k,told,tols,mxit);
x=s(:,1); y=s(:,2); N1=length(x);
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid 
xlabel('x'); ylabel('y')
	
	 
	   
	
	
