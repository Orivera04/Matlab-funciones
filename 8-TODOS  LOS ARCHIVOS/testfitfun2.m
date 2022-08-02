% testfitfun2
% script file to test nonlinear least squares problem

% create test data
x1 = -2; % alpha
x2 = -5; % beta
x3 = 10;
x4 = -4;
x5 = -6;

tdata = linspace(0,4,30)';
ydata = x3+x4*exp(x1*tdata)+x5*exp(x2*tdata);


% create an initial guess

x0 = zeros(5,1); % not a good one, but a common first guess

% call fminsearch

fitfun = @fitfun1; % create handle

options = optimset('MaxFunEvals',2e3,'MaxIter',2e3);

x = fminsearch(fitfun,x0,options,tdata,ydata);

ti = linspace(0,4); % evaluation points
actual = x3+x4*exp(x1*ti)+x5*exp(x2*ti); % actual function

fitted = x(3)+x(4)*exp(x(1)*ti)+x(5)*exp(x(2)*ti); % fitted solution

subplot(2,1,1)
plot(tdata,ydata,'o',ti,actual,ti,fitted)
xlabel t
title 'Figure 38.5: Nonlinear Curve Fit'

subplot(2,1,2)
plot(ti,actual-fitted)
xlabel t
ylabel Error
