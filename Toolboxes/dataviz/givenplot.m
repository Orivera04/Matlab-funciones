function givenplot(breakPoint)
%  make a given plot from break points
%  givenplot(breakPoint)
%  called by coplot.m

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

nbar = size(breakPoint,2);  %  number of interval bars
hw = 0.2;   %  bar halfwidth

%  draw the bars
hold on
for ii = 1:nbar
   temp1 = breakPoint(2,ii);
   temp2 = breakPoint(1,ii);
   xx = [temp1 temp1 temp2 temp2 temp1];
   yy = [ii-hw ii+hw ii+hw ii-hw ii-hw];
   plot(xx,yy,'-')
end
hold off

%  set axes
set(gca,'YTick',1:nbar)
set(gca,'YLim',[0 nbar+1])
box on
