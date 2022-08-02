% Script e08_4_1a.m; min distance path from Sydney to SFO; s=[d th]',
% d=distance along path, th=latitude; be=heading north of east;
% t=longitude (rad);	                              12/96, 6/11/02
%
N=40; be=.75*ones(N,1); s0=[0 -.5934]'; tf=1.5097; tol=1e-7;
[be,s,K]=dop0n2('dgeo0n2',be,s0,tf,tol); c=180/pi; th=c*s(2,:);
beh=[be be(N)]; Kh=[K; K(N,:)]; tf=c*tf; t=tf*[0:1/N:1]; thf=37.8;
%
figure(1); clf; plot(t,th,t(1),th(1),'ro',tf,thf,'ro'); grid
xlabel('Long. Diff. (deg)'); ylabel('Lat. (deg)')
%
figure(2); clf; subplot(211), zohplot(t,beh*c); grid
ylabel('\theta (deg)'); subplot(212), zohplot(t',Kh(:,2));
grid; xlabel('Long. Diff. (deg)'); ylabel('K_{\phi}')
