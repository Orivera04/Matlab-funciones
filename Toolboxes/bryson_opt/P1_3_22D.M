% Script p1_3_22d.m; plot of maximum turn rate (flg=2) & corres.
% (sigma, alpha, V) vs. climb (helix) angle using FMINCON; 
% 727 at S.L.; y=[V al sg]';                      10/96, 3/25/02
%
flg=2; W=180000; S=1560; rho=.002203; g=32.2; lc=2*W/(rho*g*S);
Vc=sqrt(g*lc); tc=lc/Vc; y=zeros(3,14); c=pi/180;
y(:,1)=[300/Vc 17*c 60*c]';
optn=optimset('MaxIter',200); ga=c*[0:.5:6.5];
y(:,1)=fmincon('cltn_f',y(:,1),[],[],[],[],[],[],...
     'cltn_c',optn,ga(1),flg);
 L(1)=cltn_f(y(:,1),ga(1),flg);
for i=2:14,
 y(:,i)=fmincon('cltn_f',y(:,i-1),[],[],[],[],[],[],...
     'cltn_c',optn,ga(i),flg);
 L(i)=cltn_f(y(:,i),ga(i),flg); end
V=[Vc*y(1,:) 276]; al=[y(2,:)/c 10.43];
sg=[y(3,:)/c 0]; bedot=[-L 0]/(c*tc); ga=[ga/c 6.99];
%
figure(1); subplot(311), plot(ga,sg,ga,al,'r'); grid
legend('\sigma','\alpha'); ylabel('Deg'); subplot(312)
plot(ga,bedot); grid; ylabel('Turn Rate (deg/sec)')
subplot(313), plot(ga,V); grid; xlabel('\gamma (deg)')
ylabel('V (ft/sec)')


