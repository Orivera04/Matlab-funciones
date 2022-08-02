% Topic      : Newton-Raphson Method - Roots of Equations
% Simulation : Pitfall - Zero slope
% Language   : Matlab r12
% Authors    : Nathan Collier, Autar Kaw
% Date       : 21 August 2002
% Abstract   : This simulation illustrates the pitfall of zero slope of
%	       Newton-Raphson method of finding roots of an equation f(x)=0.
%
clear all
% INPUTS: Enter the following
% Function in f(x)=0
syms x
f = sin(x);
% Initial guess
x0 = pi/2;
% Lower bound of range of 'x' to be seen
lxrange = -10;
% Upper bound of range of 'x' to be seen
uxrange = 10;
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
