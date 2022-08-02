% Script p8_5_17.m; TDP for max radius orbit transfer w.
% small change in radius using FOP0N2; s=[r u v]'; 8/23/02
%
tf=3.35; name='marslin0'; load p2_6_17f; 
s0=[0 0 0]'; tol=1e-4; mxit=0;
[t,be,s,K,Hu,Huu]=fop0n2(name,tu,be0,s0,tf,tol,mxit);
r=s(:,1); v=s(:,2); u=s(:,3); N=length(t); un=ones(N,1);
%
figure(1); clf; plot(t,un+r,t,u,t,un+v); grid
axis([0 3.5 0 1.6]); legend('1+r','u','1+v',2); xlabel('t')
%
figure(2); clf; plot(t,be*180/pi); grid
ylabel('\beta (deg)'); xlabel('t')

	