% Script p2_7_17.m; TDP for max radius orbit transfer w.
% small change in radius using FOP0; s=[r u v]';    8/23/02
%
tf=3.35; name='marslin0'; load p2_7_17;  
%be0=pi*[40:5:320]'/180; N=length(be0)-1; tu=tf*[0:1/N:1]';
s0=[0 0 0]'; k=-3e-4; told=1e-5; tols=1e-5; mxit=0 
[t,be,s,la0,Hu]=fop0(name,tu,be0,tf,s0,k,told,tols,mxit);
r=s(:,1); u=s(:,2); v=s(:,3); N=length(t); un=ones(N,1);
%
figure(1); clf; plot(t,un+r,t,u,t,un+v); grid
axis([0 3.5 0 1.6]); legend('1+r','u','1+v',2); xlabel('t')
%
figure(2); clf; plot(t,be*180/pi); grid
ylabel('\beta (deg)'); xlabel('t')

	