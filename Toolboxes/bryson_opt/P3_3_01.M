% Script p3_3_1.m; VDP with gravity; max range with 
% specified yf;                            11/96, 3/31/02
%
figure(1); clf; H1=(1/pi)*[1 1.5 2 3 4 6 12 10000]; 
t=0:.01:1; un=ones(1,101);
for i=1:8, H=H1(i);
   x=(H/2)*(t-(H/2)*sin(2*t/H)); y=(H^2/2)*(sin(t/H)).^2;
   plot(x,-y,'b',-x,-y,'b',x(101),-y(101),'ro',...
      -x(101),-y(101),'ro',0,0,'ro'); hold on
end; grid; hold off; axis([-.35 .35 -.6 .1]); 
axis('square');ylabel('y/gt_f^2'); xlabel('x/gt_f^2');
	
	