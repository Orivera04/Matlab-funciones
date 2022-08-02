x = (0:.1:1)*2*pi;
y = sin(x); % create rough data
pp = spline(x,y); % pp-form fitting rough data
ppi = mmppint(pp,0); % pp-form of integral

xi = linspace(0,2*pi); % finer points for interpolation
yi = ppval(pp,xi); % evaluate curve
yyi = ppval(ppi,xi); % evaluate integral

plot(x,y,'o',xi,yi,xi,yyi,'--') % plot results
title('Figure 20.3: Spline Integration')