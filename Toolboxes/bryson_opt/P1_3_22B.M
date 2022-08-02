% Script p1_3_22b.m; plot of minimum helix radius & corres. (sigma, 
% alpha, V) vs. climb (helix) angle using FMINCON; 727 at sea level;
% y=[V al sg]';                                      10/96, 3/25/02
%
W=180000; S=1560; rho=.002203; g=32.2; lc=2*W/(rho*g*S);
Vc=sqrt(g*lc); tc=lc/Vc; y=zeros(3,15); c=pi/180; 
y(:,1)=[300/Vc 17*c 60*c]'; optn=optimset('MaxIter',200);
ga=c*[0:.5:6.5]; flg=1;
for i=2:15
 y(:,i)=fmincon('cltn_f',y(:,i-1),[],[],[],[],[],[],'cltn_c',...
     optn,ga(i-1),flg); L(i)=cltn_f(y(:,i),ga(i-1),flg); end
V=[Vc*y(1,[2:15]) 276]; al=[180*y(2,[2:15])/pi 10.43];
sg=[180*y(3,[2:15])/pi 0]; rr=[ones(1,14)./(lc*L([2:15])) 0];
ga=[ga/c 6.99];
%
figure(1); subplot(311), plot(ga,sg,ga,al,'r');
grid; legend('\sigma','\alpha'); ylabel('Deg')
subplot(312), plot(ga,rr); grid; ylabel('1/Radius (1/ft)')
subplot(313), plot(ga,V); grid; xlabel('\gamma (deg)')
ylabel('V (ft/sec)');

