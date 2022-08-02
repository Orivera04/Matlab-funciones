% testfitfun1
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

options = []; % take default options

%options = optimset('MaxFunEvals',2e3,'MaxIter',2e3);
x = fminsearch(fitfun,x0,options,tdata,ydata)

% compute error norm at returned solution

enorm = fitfun(x,tdata,ydata)

