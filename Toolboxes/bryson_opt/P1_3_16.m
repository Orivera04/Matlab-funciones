% Script p1_3_16.m; min weight inverted cantilever truss using
% FMINCON; p=[th z];                               5/98, 3/22/02
%
optn=optimset('MaxIter',100); W=[.01:.01:.09 .1:.05:.7]'; 
N=length(W); p=zeros(N,2); p0=[.6 5]; c=180/pi;
p(1,:)=fmincon('incantr_f',p0,[],[],[],[],[],[],'incantr_c',...
    optn,W(1));
for i=2:N, p(i,:)=fmincon('incantr_f',p(i-1,:),[],[],[],[],...
    [],[],'incantr_c',optn,W(i)); end
for i=1:N, J(i)=incantr_f(p(i,:),W(i)); end
th=c*p(:,1); z=p(:,2); b=ones(N,1)./z; 
%
figure(1); clf; subplot(211), plot(W,30*b,'b',W,th,'r--'); grid;
axis([0 .7 0 50]); legend('30/z','\theta (deg)',4); 
subplot(212), plot(W,J); grid; ylabel('J'); xlabel('W bar');
axis([0 .7 0 3]);
