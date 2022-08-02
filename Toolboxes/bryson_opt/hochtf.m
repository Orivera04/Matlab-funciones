% Script hochtf.m; finds contours of constant tf (locus of initial
% evader points); ts=switch time for BS path, tb=switch time for 
% BB path;                                                 2/28/02
%
w=1/3; el=1/4; 
%tf=5; tb=.55:.05:.8;
tf=6; tb=.5:.05:1;
for i=1:length(tb), ps(i)=pi+(tf-3*tb(i))/2; cp=cos(ps(i));
   sp=sin(ps(i)); cb=cos(tb(i)); sb=sin(tb(i)); thf=tf-2*tb(i);
   cf=cos(thf); sf=sin(thf); xf=2*cb-1-cf; yf=2*sb+sf;
   xe0(i)=xf+(el-w*tf)*sp; ye0(i)=yf+(el-w*tf)*cp; end
z=0:pi/90:2*pi; for i=1:181, xc(i)=1-cos(z(i)); yc(i)=sin(z(i)); end
%tf=5; ts=1.3:.05:2;
tf=6; ts=1.3:.1:3.3;
for i=1:length(ts), cs=cos(ts(i)); ss=sin(ts(i)); 
   xf=1-cs+(tf-ts(i))*ss; yf=ss+(tf-ts(i))*cs;
   xe0s(i)=xf+(el-w*tf)*ss; ye0s(i)=yf+(el-w*tf)*cs; end
%
figure(1); clf; plot(xe0,ye0,'b',xe0s,ye0s,'r',xc,yc,'r--',...
   -xc,yc,'r--'); grid; axis([-1 5 -4 2]); axis('square'); 
legend('Bang-Bang','Bang-Singular')
title('Contours of Constant t_f')
%hold off; clear xe0s ye0s xe0 ye0
