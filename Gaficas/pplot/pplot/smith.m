function h=smith(Zr,RN)
% SMITH     A PPLOT plugin to plot impedances on smith-chart
% ----------------------------------------------------------
%                                   `-==-´ Joachim Johansson
% ----------------------------------------------------------

% ----------------------------------------------------------
% (c) 1997 `-==-´   Joachim Johansson.  All rights reserved.
%
% No part of this software  may be reproduced or transmitted
% in  any  form  or by any means,  electronic or mechanical,
% for any purpose  without  prior  written  consent  of  the
% author.
% 
% While  the software  is assumed to be accurate, the author
% assume no  responsibility  for  any  errors  or omissions.
% In  no  event  shall the author of this software be liable
% for special,  direct,  indirect,  or consequential damage,
% losses,  costs,  charges,  claims, demands, claim for lost
% profits, fees, or expences of any nature or kind. 
% ----------------------------------------------------------
if nargin==1
  RN=50;
end
if mean(Zr)<1
  Zr=RN.*(1+Zr)./(1-Zr);
end
if ~strcmp(get(gca,'tag'),'smith')
  axis([-1.6 1.6 -1.02 1.01]);
  r=[1 0.826 0.665 0.500 0.334 0.162];
  Re=[1,2,5,5];
  Im=[0.2 0.5 1 2];
  for i=1:4
    p=(0:(Re(i)/100):Re(i))';
    q=p-p+Im(i);
    Icirc1=p+j*q;
    Icirc2=p-j*q;
    rho1=(Icirc1-1)./(Icirc1+1);
    rho2=(Icirc2-1)./(Icirc2+1);
    rhomag=abs(rho1);
    Circm(:,i)=rhomag;
    Circp=angle(rho1);
    Circp1(:,i)=Circp;
    Circp=angle(rho2);
    Circp2(:,i)=Circp;
  end
  inc=2*pi/100;
  theta=0:inc:pi;
  phi=0:2*inc:2*pi;
  RV=phi-phi+0.329;
  for i=1:6
    R1=2*r(:,i)*sin(theta+pi/2);
    y1=R1.*sin(theta);
    x1=R1.*cos(theta);
    y2=y1;
    x2=x1+(1-2*r(i));
    R=sqrt(x2.^2+y2.^2);
    R2(:,i)=R';
    theta1=atan((y2./x2));
    for p=1:length(x2)
      if x2(p)<0, theta1(p)=theta1(p)-pi; end;
    end,
    theta2(:,i)=theta1';
  end
  hold on
  h1=polar(theta2,R2);
  h2=polar(Circp1,Circm);
  h3=polar(Circp2,Circm);
  h4=polar(phi,RV);
  x=[-pi 0];
  y=[1 1];
  h5=polar(x,y);
  set([h1;h2;h3;h4;h5],'color',[.4 .3 0]);
  text(-1.1,0.06,'0','color',[0.4 0.3 0],'FontSize',10);
  text(-0.65,0.06,'.2','color',[0.4 0.3 0],'FontSize',10);
  text(-0.32,0.06,'.5','color',[0.4 0.3 0],'FontSize',10);
  text(0.03,0.06,'1','color',[0.4 0.3 0],'FontSize',10);
  text(0.37,0.06,'2','color',[0.4 0.3 0],'FontSize',10);
  text(0.71,0.06,'5','color',[0.4 0.3 0],'FontSize',10);
  text(1.05,0.06,'inf','color',[0.4 0.3 0],'FontSize',10);
  text(1.15*cos(5.2*pi/6),1.1*sin(5.2*pi/6),'.2','color',[0.4 0.3 0],'FontSize',10);
  text(1.15*cos(-5.2*pi/6),1.1*sin(-5.2*pi/6),'.2','color',[0.4 0.3 0],'FontSize',10);
  text(1.1*cos(2.2*pi/3),.85,'.5','color',[0.4 0.3 0],'FontSize',10);
  text(1.15*cos(-2.2*pi/3),-.84,'.5','color',[0.4 0.3 0],'FontSize',10);
  text(0.03,.89,'1','color',[0.4 0.3 0],'FontSize',10);
  text(0.03,-.9,'1','color',[0.4 0.3 0],'FontSize',10);
  text(1.05*cos(pi/3.2),.9,'2','color',[0.4 0.3 0],'FontSize',10);
  text(1.1*cos(-pi/3.2),-.9,'2','color',[0.4 0.3 0],'FontSize',10);
  text(1,-.85,['RN=' num2str(RN)],'color',[0.4 0.3 0],'FontSize',10);
  set(gca,'tag','smith');
end
rho=(Zr-RN)./(Zr+RN);
rhomag=abs(rho);
rhoph=angle(rho);
ht=polar(rhoph,rhomag,'blue');
axis('off');
if nargout==1
  h=ht;
end
