%  book_3_25.m

load dating

x = CarbonAge;
y = ThoriumAge-CarbonAge;
n = 1;  %  first degree fit for straight line
sortx = sort(x);
%  plot the line through most of the data
newx = linspace(sortx(1),0.5*(sortx(end)+sortx(end-1)),50);

%  bisquare fit
p = least2b(x,y,n);
newy = polyval(p,newx);

%  unweighted fit
p = polyfit(x,y,n);
unwy = polyval(p,newx);

%  plot the data and both fit lines
hg = plot(x,y,'o',newx,newy,'-',newx,unwy,'r--');
xlabel('Carbon Age')
ylabel('Thorium Age - Carbon Age')
title('Dating')
legend(hg(2:3),{'Robust';'Ordinary'},4)

naxis = axis;
naxis(4) = ceil(max(y));
axis(naxis)