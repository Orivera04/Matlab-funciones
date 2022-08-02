% © Fazekas Istvan 1998; program a Statisztika c. reszhez
% 1. azonos szorasu normalis

figure;
plot(-7:0.05:7,normpdf(-7:0.05:7,-2,1),'r-');hold on;
plot(-7:0.05:7,normpdf(-7:0.05:7,0,1),'g:');hold on;
plot(-7:0.05:7,normpdf(-7:0.05:7,2,1),'k--');
figure; % azonos varhato erteku normalis
plot(-4:0.05:4,normpdf(-4:0.05:4,0,0.7),'r-');hold on;
plot(-4:0.05:4,normpdf(-4:0.05:4,0,1),'g--');hold on;
plot(-4:0.05:4,normpdf(-4:0.05:4,0,1.5),'k-');
% 2. kulonbozo normalis veletlen szamok
x1=normrnd(0,1,100,1);x2=normrnd(0,1,100,1);x=[x1 x2];
% ketszer ugyanazon normalis veletlen szamok
a=randn('state'); y1=normrnd(0,1,100,1);
randn('state',a); y2=normrnd(0,1,100,1); y=[y1 y2];