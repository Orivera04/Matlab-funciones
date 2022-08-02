function example_AD
%%
%% Example for using the classes myAD and myA2D
%% Note that these classes only provide vectors and not matrices
%%
%% myAD and myA2D - Automatic Differentiation of 1st and 2nd Derivative
%% Copyright (C) 2006 Martin Fink (martinfink "at" gmx.at)
%%
%% For further information consider the README file
%%

t = 7;
%% Normal function use
p = rand(5,1);
f = func(t,p);

%% Use automatic differentiation when only first order derivative is needed
pAD = myAD(p);
outAD = func(t, pAD);

%% Use automatic differentiation when first and second order derivative is needed
pA2D = myA2D(p);
outA2D = func(t,pA2D);

%% Output
% Function values
disp('Function values:');
f
fAD=getvalue(outAD)
fA2D=getvalue(outA2D)
disp('Press key to continue');
pause

% First derivative of function values with respect to parameters
disp(' ');
disp('First derivatives:');
dfAD=getderivs(outAD)
dfAD=getderivs(outA2D)
disp('Press key to continue');
pause
  
% Second derivative of function values with respect to parameters
disp(' ');
disp('Second derivatives:');
d2fA2D=getsecderiv(outA2D)


function fval = func(t, p)

fval = [sin(2*pi*t.*p(1)) - t*p(3);
        13 + p(2).*p(3) - p(4).^2;
        p(5).*t.^2];
