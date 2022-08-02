% testfitfun3
% script file to test nonlinear least squares problem

% create test data
x1 = -2; % alpha
x2 = -5; % beta
p1 = 10;
p2 = -4;
p3 = -6;

tdata = linspace(0,4,30)';
ydata = p1+p2*exp(x1*tdata)+p3*exp(x2*tdata);

% create an initial guess

x0 = zeros(2,1); % not a good one, but a common first guess

% call fminsearch

fitfun = @fitfun2; % create handle to new function

options = []; % take default options

%options = optimset('MaxFunEvals',2e3,'MaxIter',2e3);
x = fminsearch(fitfun,x0,options,tdata,ydata)

% find p and compute error norm at returned solution

[enorm,p] = fitfun(x,tdata,ydata)

%[enorm,p]=fitfun2(x,tdata,ydata)