%  book_3_21.m

load dating

x = CarbonAge;
y = ThoriumAge-CarbonAge;
n = 1;  %  first degree fit for straight line
sortx = sort(x);
%  plot the line through most of the data
newx = linspace(sortx(1),0.5*(sortx(end)+sortx(end-1)),50);

%  plot the data and both fit lines
hg = plot(x,y,'o');
xlabel('Carbon Age')
ylabel('Thorium Age - Carbon Age')
title('Dating')

naxis = axis;
naxis(4) = ceil(max(y));
axis(naxis)