function  ph=plotnl(xmin,xmax,xnom,etol)

%
% 	Utility file used by LIN1.M 
%
%	Copyright 1997 by J.F. Gardner
%
% plot the first data set
%
xarr=[xmin:.1:xmax];
%
%  Compute the nonlinear function (x-cubed + x)
%
yarr=xarr.^3+xarr;
%
%  Compute the linearized function
%
b=(-2*xnom^3-xnom^2+xnom);
m=(3*xnom^2+xnom);
rerr=0.0;
ylin=m*xarr+b;
%
%  Now we need to find the values of x at which the 
%  linearization failes to meet the user-prescribed
%  error tolerance (etol).
%
x1=xnom;
x2=xnom;


while (abs(rerr)<etol)
	x1=x1+0.01;
	y1=x1^ 3+x1;
	y1l=m*x1+b;
	rerr=(y1-y1l)/y1;
end;

rerr=0.0;

while abs(rerr<etol)
	x2=x2-0.01;
	y2=x2^ 3+x2;
	y2l=m*x2+b;
	rerr=(y2-y2l)/y2;
end;


ph=plot(xarr,yarr);
axis([-10 10 -1000 1000]);
axis(axis);
hold on;
plot(xnom,xnom^3+xnom,'ro');
plot(xarr,ylin,'g-');
plot([x2 x2 x2],[-1000 y2 y2l],'r-');
plot([x1 x1 x1],[-1000 y1 y1l],'r-');
hold off;