% Script p1_2_17.m; min weight simple truss; plots from analytical
% solution;                                            10/96, 3/30/02  
%
thc=asin(sqrt(2/7)); Wc=sqrt(14)/5; b2c=7/5; c=180/pi;
tho=asin(sqrt(1/5)); Jc=Wc*(tan(thc)+1/tan(thc))+2*b2c/cos(thc);
%
% z>cos^2(th) (members 1 & 2 slender columns):
th1=[27:.5:32]/c; th1=[tho th1 thc]; un1=ones(1,length(th1));
b21=(un1-5*(sin(th1)).^2)./((cos(th1)).^2.*(2*(sin(th1)).^2-un1)); 
W1=b21.^2.*(cos(th1)).^2.*sin(th1); z1=un1./b21;
J1=W1.*(tan(th1)+un1./tan(th1))+2*b21./cos(th1);
%
% z<cos^2(th) (members 1 & 2 short columns):
th2=[32.4:.1:32.9 33:.5:41]/c; th2=[thc th2]; un=ones(1,length(th2)); 
b22=(1/8)*(2*un-(sin(th2)).^2)./((cos(th2)).^2.*(.5*un...
   -(sin(th2)).^2)); W2=2*b22.*sin(th2)-sin(th2)./(cos(th2)).^2;
J2=W2.*(tan(th2)+un./tan(th2))+2*b22./cos(th2); z2=un./b22; 
%
figure(1); clf; subplot(211), plot(W1,c*th1,'b',W1,4*J1,'r--');
legend('\theta (deg)','4*J',4); hold on; plot(W2,c*th2,'b',W2,4*J2,...
   'r--',Wc,c*thc,'o',Wc,4*Jc,'o'); grid; hold off; axis([0 1.5 0 40]);
subplot(212), plot(W1,b21,'b',W2,b22,'b',Wc,1/cos(thc)^2,'o'); 
axis([0 1.5 0 2.2]); grid; xlabel('W'); ylabel('1/z');