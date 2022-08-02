% Script p1_3_17.m; min weight simple truss using FMINCON; p=[th z];
%                                                 10/96, 3/22/02
%
optn=optimset('MaxIter',100); W=[.05 .1:.1:1.5]; N=length(W); 
p=zeros(2,N); p0=[.5 2]'; 
p(:,1)=fmincon('trussa_f',p0,[],[],[],[],[],[],'trussa_c',optn,W(1));
for i=2:N, p(:,i)=fmincon('trussa_f',p(:,i-1),[],[],[],[],[],[],...
        'trussa_c',optn,W(i)); end
for i=1:N, J(i)=trussa_f(p(:,i),W(i)); end
th=p(1,:); z=p(2,:); c=180/pi; un=ones(1,N); b=un./z; d=cos(th).^2./z;
Wc=sqrt(14)/5; thc=asin(sqrt(2/7)); tho=asin(sqrt(1/5)); 
%
figure(1); clf; subplot(211), plot(W,c*th,'b',W,4*J,'r--',...
   Wc,c*thc,'bo',0,c*tho,'bo',0,0,'ro'); grid;
legend('\theta (deg)','4*J',4); axis([0 1.5 0 40]);
subplot(212), plot(W,b,'b',W,d,'r--',Wc,1,'ro',0,0,'ro'); grid; 
legend('1/z','cos^2\theta/z',2); xlabel('W'); axis([0 1.5 0 2.2]); 

