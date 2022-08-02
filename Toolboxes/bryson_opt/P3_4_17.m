% Script p3_4_17.m; TDP for max radius orbit transfer w.
% small change in radius using FOPC; s=[r v u th]'; 
%                                             2/97, 8/17/02
%
tf=3.35; name='marslinc'; 
%be0=pi*[40:5:320]'/180; N=length(be0)-1; tu=tf*[0:1/N:1]';
load p3_4_17; 
s0=[0 0 0]'; k=-1e-2; told=1e-5; tols=1e-5; mxit=5; 
[t,be,s]=fopc(name,tu,be0,tf,s0,k,told,tols,mxit);
r=s(:,1); v=s(:,2); u=s(:,3); N=length(t); un=ones(N,1);
%
figure(1); clf; plot(t,un+r,t,v,t,un+u); grid
axis([0 3.5 0 1.6]); legend('1+r','v','1+u',2); xlabel('t')
%
figure(2); clf; plot(t,be*180/pi); grid
ylabel('\beta (deg)'); xlabel('t')

	