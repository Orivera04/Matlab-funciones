x=linspace(0,10);
y=sin(x);
xo = mminvinterp(x,y,0);
yo = interp1(x,y,xo);
[xo yo]
plot(x,y,xo,yo,'o')
hold on
line([0 10],[0 0])
hold off