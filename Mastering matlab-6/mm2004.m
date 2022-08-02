x = (0:.1:1)*2*pi; % same data as earlier
y = sin(x);
pp = spline(x,y); % pp-form fitting rough data
ppd = mmppder(pp); % pp-form of derivative

xi = linspace(0,2*pi); % finer points for interpolation
yi = ppval(pp,xi); % evaluate curve
yyd = ppval(ppd,xi); % evaluate derivative
plot(x,y,'o',xi,yi,xi,yyd,'--') % plot results
title('Figure 20.4: Spline Differentiation')