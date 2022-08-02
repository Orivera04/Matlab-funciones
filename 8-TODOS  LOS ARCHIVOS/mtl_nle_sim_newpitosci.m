% Topic      : Newton-Raphson Method - Roots of Equations
% Simulation : Pitfall - Oscillation around a local maxima or minima
% Language   : Matlab r12
% Authors    : Nathan Collier, Autar Kaw
% Date       : 11 September 2002
% Abstract   : This simulation illustrates a pitfall of the Newton-Raphson method  
%              where one is getting oscillation around a local maxima or minima.
%
clear all
% INPUTS: Enter the following
% Function in f(x)=0
syms x
f = x^2+2;
% Initial guess
x0 = -1;
% Lower bound of range of 'x' to be seen
lxrange = -3;
% Upper bound of range of 'x' to be seen
uxrange = 3;
% Maximum number of iterations
nmax = 100;
%
% SOLUTION
g=diff(f);
% The following finds the upper and lower 'y' limits for the plot based on the given
%    'x' range in the input section.
maxi = 10;
mini = -1;
tot=maxi-mini;
mini=mini-0.1*tot;
maxi=maxi+0.1*tot;

% This calculates window size to be used in figures
set(0,'Units','pixels') 
scnsize = get(0,'ScreenSize');
wid = round(scnsize(3));
hei = round(0.95*scnsize(4));
wind = [1, 1, wid, hei];

% This graphs the function and the line representing the initial guess
figure('Position',wind)
clf
ezplot(f,[lxrange,uxrange])
hold on 
plot([x0,x0],[maxi,mini],'g','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with initial guess')
hold off

% --------------------------------------------------------------------------------
% Iteration 1
figure('Position',wind)
x1=x0-subs(f,x,x0)/subs(g,x,x0);
ea=abs((x1-x0)/x1)*100;
m=-subs(f,x,x0)/(x1-x0);
b=subs(f,x,x0)*(1+x0/(x1-x0));
lefty=(maxi-b)/m;
righty=(mini-b)/m;
% This graphs the function and two lines representing the two guesses
clf
subplot(2,1,2),ezplot(f,[lxrange uxrange])
hold on 
plot([x0,x0],[maxi,mini],'g','linewidth',2)
plot([x1,x1],[maxi,mini],'g','linewidth',2)
plot([lefty,righty],[maxi,mini],'r','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with current and next root and tangent line of the curve at the current root')

% This portion adds the text and math to the top part of the figure window
subplot(2,1,1), text(0,1,['Iteration 1'])
text(0.1,.8,['x1 = x0 - (f(x0)/g(x0)) = ',num2str(x1)])
text(0,.4,['Absolute relative approximate error'])
text(0.1,.2,['ea = abs((x1 - x0) / x1)*100 = ',num2str(ea),'%'])
axis off
hold off

% --------------------------------------------------------------------------------
% Iteration 2
figure('Position',wind)
x2=x1-subs(f,x,x1)/subs(g,x,x1);
ea=abs((x2-x1)/x2)*100;
m=-subs(f,x,x1)/(x2-x1);
b=subs(f,x,x1)*(1+x1/(x2-x1));
lefty=(maxi-b)/m;
righty=(mini-b)/m;
% This graphs the function and two lines representing the two guesses
clf
subplot(2,1,2),ezplot(f,[lxrange,uxrange])
hold on 
plot([x1,x1],[maxi,mini],'g','linewidth',2)
plot([x2,x2],[maxi,mini],'g','linewidth',2)
plot([lefty,righty],[maxi,mini],'r','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with current and next root and tangent line of the curve at the current root')

% Calculate relative approximate error
ea=abs((x2-x1)/x2)*100;

% This portion adds the text and math to the bottom part of the figure window
subplot(2,1,1), text(0,1,['Iteration 2'])
text(0.1,.8,['x2 = x1 - (f(x1)/g(x1)) = ',num2str(x2)])
text(0,.4,['Absolute relative approximate error'])
text(0.1,.2,['ea = abs((x2 - x1) / x2)*100 = ',num2str(ea),'%'])
axis off

% --------------------------------------------------------------------------------
% Iteration 3
figure('Position',wind)
x3=x2-subs(f,x,x2)/subs(g,x,x2);
ea=abs((x3-x2)/x3)*100;
m=-subs(f,x,x2)/(x3-x2);
b=subs(f,x,x2)*(1+x2/(x3-x2));
lefty=(maxi-b)/m;
righty=(mini-b)/m;
% This graphs the function and two lines representing the two guesses
clf
subplot(2,1,2),ezplot(f,[lxrange,uxrange])
hold on 
plot([x2,x2],[maxi,mini],'g','linewidth',2)
plot([x3,x3],[maxi,mini],'g','linewidth',2)
plot([lefty,righty],[maxi,mini],'r','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with current and next root and tangent line of the curve at the current root')

% Calculate relative approximate error
ea=abs((x3-x2)/x3)*100;

% This portion adds the text and math to the bottom part of the figure window
subplot(2,1,1), text(0,1,['Iteration 3'])
text(0.1,.8,['x3 = x2 - (f(x2)/g(x2)) = ',num2str(x3)])
text(0,.4,['Absolute relative approximate error'])
text(0.1,.2,['ea = abs((x3 - x2) / x3)*100 = ',num2str(ea),'%'])
axis off

% --------------------------------------------------------------------------------
% Iteration 4
figure('Position',wind)
x4=x3-subs(f,x,x3)/subs(g,x,x3);
ea=abs((x4-x3)/x4)*100;
m=-subs(f,x,x3)/(x4-x3);
b=subs(f,x,x3)*(1+x3/(x4-x3));
lefty=(maxi-b)/m;
righty=(mini-b)/m;
% This graphs the function and two lines representing the two guesses
clf
subplot(2,1,2),ezplot(f,[lxrange,uxrange])
hold on 
plot([x3,x3],[maxi,mini],'g','linewidth',2)
plot([x4,x4],[maxi,mini],'g','linewidth',2)
plot([lefty,righty],[maxi,mini],'r','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with current and next root and tangent line of the curve at the current root')

% Calculate relative approximate error
ea=abs((x4-x3)/x4)*100;

% This portion adds the text and math to the bottom part of the figure window
subplot(2,1,1), text(0,1,['Iteration 4'])
text(0.1,.8,['x4 = x3 - (f(x3)/g(x3)) = ',num2str(x4)])
text(0,.4,['Absolute relative approximate error'])
text(0.1,.2,['ea = abs((x4 - x3) / x4)*100 = ',num2str(ea),'%'])
axis off

% --------------------------------------------------------------------------------
% Iteration 5
figure('Position',wind)
x5=x4-subs(f,x,x4)/subs(g,x,x4);
ea=abs((x5-x4)/x5)*100;
m=-subs(f,x,x4)/(x5-x4);
b=subs(f,x,x4)*(1+x4/(x5-x4));
lefty=(maxi-b)/m;
righty=(mini-b)/m;
% This graphs the function and two lines representing the two guesses
clf
subplot(2,1,2),ezplot(f,[lxrange,uxrange])
hold on 
plot([x4,x4],[maxi,mini],'g','linewidth',2)
plot([x5,x5],[maxi,mini],'g','linewidth',2)
plot([lefty,righty],[maxi,mini],'r','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with current and next root and tangent line of the curve at the current root')

% Calculate relative approximate error
ea=abs((x5-x4)/x5)*100;

% This portion adds the text and math to the bottom part of the figure window
subplot(2,1,1), text(0,1,['Iteration 5'])
text(0.1,.8,['x5 = x4 - (f(x4)/g(x4)) = ',num2str(x5)])
text(0,.4,['Absolute relative approximate error'])
text(0.1,.2,['ea = abs((x5 - x4) / x5)*100 = ',num2str(ea),'%'])
axis off

% ---------------------------------------------------------------------------------
xguess=x0;
for i=1:nmax
    if i==1
        xr(i) = xguess-(subs(f,x,xguess)/subs(g,x,xguess));
    else
        xr(i) = xr(i-1)-(subs(f,x,xr(i-1))/subs(g,x,xr(i-1)));
    end
end
n=1:nmax;

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

figure('Position',wind)
clf
plot(n,ea,'g','linewidth',2)
title('Absolute relative approximate error as a function of number of iterations')
hold off