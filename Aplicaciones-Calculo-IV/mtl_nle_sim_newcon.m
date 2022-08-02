% Topic      : Newton-Raphsin Method - Roots of Equations
% Simulation : Convergence of the Method
% Language   : Matlab r12
% Authors    : Nathan Collier, Autar Kaw
% Date       : 21 August 2002
% Abstract   : This simulation illustrates the convergence of the Newton-Raphson method of  
%              finding roots of an equation f(x)=0.
%
clear all
% INPUTS: Enter the following
% Function in f(x)=0
syms x
f = x^3-0.165*x^2+3.993*10^(-4);
% Initial guess
xguess = 0.05;
% Lower bound of range of 'x' to be seen
lxrange = -0.02;
% Upper bound of range of 'x' to be seen
uxrange = 0.12;
% Maximum number of iterations
nmax = 5;
% Input number of root for Matlab solve function
xrguess=3;
%
% SOLUTION
g=diff(f);
% The following finds the upper and lower 'y' limits for the plot based on the given
%    'x' range in the input section.
maxi = subs(f,x,lxrange);
mini = subs(f,x,lxrange);
for i=lxrange:(uxrange-lxrange)/10:uxrange
    if subs(f,x,i) > maxi 
        maxi = subs(f,x,i);
    end
    if subs(f,x,i) < mini 
        mini = subs(f,x,i);
    end        
end
tot=maxi-mini;
mini=mini-0.1*tot;
maxi=maxi+0.1*tot;

% This calculates window size to be used in figures
set(0,'Units','pixels') 
scnsize = get(0,'ScreenSize');
wid = round(scnsize(3));
hei = round(0.95*scnsize(4));
wind = [1, 1, wid, hei];

% This graphs the function and two lines representing the two guesses
figure('Position',wind)
clf
ezplot(f,[lxrange,uxrange])
hold on 
plot([xguess,xguess],[maxi,mini],'g','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with initial guess')

hold off

% True solution
% This is how Matlab calculates the root of a non-linear equation.
zeros=solve(f);
format;
zeros=Double(zeros);
xrtrue=zeros(xrguess);

% Value of root by iterations
% Here the bisection method algorithm is applied to generate the values of the roots, true error,
%   absolute relative true error, approximate error, absolute relative approximate error, and the
%   number of significant digits at least correct in the estimated root as a function of number of
%   iterations.

for i=1:nmax
    if i==1
        xr(i) = xguess-(((subs(f,x,xguess))/(subs(g,x,xguess))));
    else
        xr(i) = xr(i-1)-(subs(f,x,xr(i-1))/subs(g,x,xr(i-1)));
    end
end
n=1:nmax;

% Absolute true error
for i=1:nmax
    Et(i)=abs(xrtrue-xr(i));
end

% Absolute relative true error
for i=1:nmax
    et(i)=abs(Et(i)/xrtrue)*100;
end

% Absolute approximate error
for i=1:nmax
    if i==1
        Ea(i)=abs(xr(i)-xguess);
    else
        Ea(i)=abs(xr(i)-xr(i-1));
    end
      
end

% Absolute relative approximate error
for i=1:nmax
    ea(i)=abs(Ea(i)/xr(i))*100;
end

% Significant digits at least correct
for i=1:nmax
    if (ea(i)>5)
        sigdigits(i)=0;
    end
    if (ea(i)<=5) & (ea(i)~=0)
        sigdigits(i)=floor((2-log10(ea(i)/0.5)));
    end
    if (ea(i)==0)
        sigdigits(i)=32;
    end
end
figure('Position',wind)
plot(n,xr,'r','linewidth',2)
title('Estimated root as a function of number of iterations')
figure('Position',wind)
subplot(2,1,1), plot(n,Et,'b','linewidth',2)
title('Absolute true error as a function of number of iterations')
subplot(2,1,2), plot(n,et,'b','linewidth',2)
title('Absolute relative true error as a function of number of iterations')
figure('Position',wind)
subplot(2,1,1), plot(n,Ea,'g','linewidth',2)
title('Absolute relative error as a function of number of iterations')
subplot(2,1,2), plot(n,ea,'g','linewidth',2)
title('Absolute relative approximate error as a function of number of iterations')
figure('Position',wind)
bar(sigdigits,'r')