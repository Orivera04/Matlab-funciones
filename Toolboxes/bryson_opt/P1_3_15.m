% Script p1_3_15.m; min weight cantilever truss using FMINCON; 
% p=[th z];                                     10/96, 3/25/02
%
optn=optimset('MaxIter',100);
W=[.01:.01:.09 .1:.1:.7 .72:.02:.78 .8:.1:1.5]; N=length(W);
p=zeros(2,N); p0=[.5 2]'; c=180/pi; un=ones(1,N);
p(:,1)=fmincon('cantruss_f',p0,[],[],[],[],[],[],...
  'cantruss_c',optn,W(1)); for i=2:N, 
    p(:,i)=fmincon('cantruss_f',p(:,i-1),[],[],[],[],...
    [],[],'cantruss_c',optn,W(i)); end
for i=1:N, J(i)=cantruss_f(p(:,i),W(i)); end
th=p(1,:); b=un./p(2,:); 
%
figure(1); clf; subplot(211), plot(W,c*th,'b',W,15*J,'r--');
grid; axis([0 1.5 0 90]); legend('\theta (deg)','15*J',4)
subplot(212), plot(W,b,'b'); grid; axis([0 1.5 0 2]) 
xlabel('W'); ylabel('1/z')


