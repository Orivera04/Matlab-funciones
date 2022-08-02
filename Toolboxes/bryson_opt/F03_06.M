% Script f03_06.m; VDP with gravity; max range with 
% spec. yf;                                11/96, 4/1/02
%
figure(1); clf; H1=(1/pi)*[1 1.5 2 3 4 6 12 10000];
t=0:.01:1; un=ones(1,101);
for i=1:8, H=H1(i);
 x=(H/2)*(t-(H/2)*sin(2*t/H));  y=(H^2/2)*(sin(t/H)).^2;
 figure(1); hold on; plot(x,-y,-x,-y); 
 plot(x(101),-y(101),'o',-x(101),-y(101),'o',0,0,'o');
 hold off
end
grid; axis([-.35 .35 -.6 .1]); axis('square');
ylabel('-y/gt_f^2'); xlabel('x/gt_f^2');
%print -deps2 \book_do\figures\f03_06

	