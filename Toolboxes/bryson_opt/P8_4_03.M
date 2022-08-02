% Script p8_4_03.m; min distance path from Sydney to SFO; s=[d th]', 
% d=distance along path, th=latitude; be=heading angle north of east;
% t=phi=longitude (rad); also a nbr. opt. path & the exact nbr. path;
%                                                      12/96, 8/10/02
%
N=40; be0=.75*ones(N,1); s0=[0 -.5934]'; tf=1.5097; tol=1e-7; 
[be,s,K,Hu,Zuu]=dop0n2('dgeo0n2',be0,s0,tf,tol); th=s(2,:);
beh=[be be(N)]; Kh=[K; K(N,:)]; tf=tf; t=tf*[0:1/N:1]; c=180/pi;
Huh=[Hu Hu(N)]; Zuuh=[Zuu Zuu(N)];
%
figure(1); clf; plot(c*t,c*th,c*t(1),c*th(1),'ro',c*tf,c*th(N+1),'ro');
grid; xlabel('d\phi=Long. Diff. (deg)'); ylabel('Lat. (deg)'); hold on
%
figure(2); clf; subplot(211), zohplot(c*t,c*beh); grid 
ylabel('Heading \beta (deg)'); hold on; subplot(212)
zohplot(c*t',Kh(:,2)); grid; xlabel('Long. Diff. (deg)'); hold on
ylabel('K_{\theta}'); axis([0 90 -2 25])
%
figure(3); clf; subplot(211), zohplot(t,Huh); grid
ylabel('H_u'); subplot(212), zohplot(t,Zuuh); grid; ylabel('Z_{uu}')
xlabel('Long. Diff. (deg)');
%
% A neighboring optimal path:
dt=tf/N; ben=be; sn=s; thn=sn(2,:); s(:,1)=[0 -.5334]'; 
for i=1:N
    be(i)=ben(i)-K(i,:)*(s(:,i)-sn(:,i));
    cb=cos(be(i)); sb=sin(be(i)); th=s(2,i); ct=cos(th); 
    s(:,i+1)=s(:,i)+dt*(ct/cb)*[1; sb];	
end; beh=[be be(N)]; th=s(2,:);  
%
figure(1); plot(c*t,c*th,'r--',0,c*th(1),'ro');
figure(2); subplot(211), zohplot(c*t,c*beh,'r--');
%
% Exact neighboring optimum path for comparison:
s0=[0 -.5334]'; [bee,s]=dop0n2('dgeo0n2',ben,s0,tf,tol);
the=s(2,:); beeh=[bee bee(N)]; 
%
figure(1); plot(c*t,c*the,'r.'); hold off
figure(2); subplot(211), zohplot(c*t,c*beeh,'r.'); hold off 
figure(3); clf; subplot(211), zohplot(t,Huh); grid
ylabel('H_u'); subplot(212), zohplot(t,Zuuh); grid; ylabel('Z_{uu}')
xlabel('Long. Diff. (deg)');
 
