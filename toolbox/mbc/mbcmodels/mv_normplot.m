function h = normplot(x,axhand)
% MV_NORMPLOT Displays a normal probability plot.
% 
% H = NORMPLOT(X) makes a normal probability plot of the  
%   data in X. For matrix, X, NORMPLOT displays a plot for each column.
%   H is a handle to the plotted lines.
%   
%   The purpose of a normal probability plot is to graphically assess
%   whether the data in X could come from a normal distribution. If the
%   data are normal the plot will be linear. Other distribution types 
%   will introduce curvature in the plot.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:02:09 $


[n, m] = size(x);
if n == 1
   x = x';
   n = m;
end

if n==0 | ~any(isfinite(x))
	h= line('xdata',[],'ydata',[],'parent',axhand);
	return
end

[sx i]= sort(x);
%minx  = min(sx(1,:));
%maxx  = max(sx(n,:));
%range = maxx-minx;
minx  = min(sx(1,:));
maxx  = max(sx(n-sum(isnan(sx)),:));	%sum(isnan(sx)) gives you the number of NaN's if any.
range = maxx-minx;


if range>0
  minxaxis  = minx-0.025*range;
  maxxaxis  = maxx+0.025*range;
else
  minxaxis  = minx - 1;
  maxxaxis  = maxx + 1;
end

eprob = [0.5./n:1./n:(n - 0.5)./n];
y  = norminv(eprob,0,1)';

minyaxis  = norminv(0.25 ./n,0,1);
maxyaxis  = norminv((n-0.25) ./n,0,1);


p     = [0.001 0.003 0.01 0.02 0.05 0.10 0.25 0.5...
         0.75 0.90 0.95 0.98 0.99 0.997 0.999];

label1= str2mat('0.001','0.003', '0.01','0.02','0.05','0.10','0.25','0.50');
label2= str2mat('0.75','0.90','0.95','0.98','0.99','0.997', '0.999');
label = [label1;label2];

tick  = norminv(p,0,1);

q1x = prctile(x(~isnan(x)),25);
q3x = prctile(x(~isnan(x)),75);
q1y = prctile(y(~isnan(x)),25);
q3y = prctile(y(~isnan(x)),75);
qx = [q1x; q3x];
qy = [q1y; q3y];


dx = q3x - q1x;
dy = q3y - q1y;
slope = dy./dx;
centerx = (q1x + q3x)/2;
centery = (q1y + q3y)/2;
maxx = max(x);
minx = min(x);
maxy = centery + slope.*(maxx - centerx);
miny = centery - slope.*(centerx - minx);

mx = [minx; maxx];
my = [miny; maxy];

y(i)=y;
p = plot(y,x,'+',qy,qx,'-',my,mx,'-.','parent',axhand);
set(p(1),'tag','main line');
set(p(2:end),'hittest','off');
if nargout == 1
   h = p;
end
set(axhand,'XTick',tick,'XTickLabel',label);
set(axhand,'XLim',[minyaxis maxyaxis],'YLim',[minxaxis maxxaxis]);
xH=get(axhand,'xlabel');
set(xH,'string','Probability');
yH=get(axhand,'ylabel');
set(yH,'string','Data');
% tH=get(axhand,'title');
% set(tH,'string','Normal Probability Plot');

set(axhand,'xgrid','on','ygrid','on');

