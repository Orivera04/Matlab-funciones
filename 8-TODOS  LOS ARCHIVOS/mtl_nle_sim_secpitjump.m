% Topic      : Secant Method - Roots of Equations
% Simulation : Pitfall - Root Jumps Several Roots Away
% Language   : Matlab r12
% Authors    : Nathan Collier, Autar Kaw
% Date       : 6 September 2002
% Abstract   : This simulation shows the pitfall of root jumping in the secant method
%              for finding roots of an equation f(x)=0
%
% INPUTS: Enter the following
% Function in f(x)=0
f = inline('sin(x)');
% Initial guess 1
xguess1 = 8.5;
% Initial guess 2
xguess2 = 7;
% Lower bound of range of 'x' to be seen
lxrange = -10.0;
% Upper bound of range of 'x' to be seen
uxrange = 10;
%
% SOLUTION

% The following finds the upper and lower 'y' limits for the plot based on the given
%    'x' range in the input section.
maxi = f(lxrange);
mini = f(lxrange);
for i=lxrange:(uxrange-lxrange)/10:uxrange
    if f(i) > maxi 
        maxi = f(i);
    end
    if f(i) < mini 
        mini = f(i);
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
fplot(f,[lxrange,uxrange])
hold on 
plot([xguess1,xguess1],[maxi,mini],'g','linewidth',2)
plot([xguess2,xguess2],[maxi,mini],'g','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with initial guesses')


hold off

% --------------------------------------------------------------------------------
% Iteration 1
figure('Position',wind)
x1 = xguess2-(f(xguess2)*(xguess1-xguess2))/(f(xguess1)-f(xguess2));
ea=abs((x1-xguess2)/x1)*100;
m=(f(xguess2)-f(xguess1))/(xguess2-xguess1);
b=f(xguess2)-m*xguess2;
lefty=(maxi-b)/m;
righty=(mini-b)/m;
% This graphs the function and two lines representing the two guesses
clf
subplot(2,1,2),fplot(f,[lxrange,uxrange])
hold on 
plot([x1,x1],[maxi,mini],'b','linewidth',2)
plot([xguess1,xguess1],[maxi,mini],'g','linewidth',2)
plot([xguess2,xguess2],[maxi,mini],'g','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
plot([lefty,righty],[maxi,mini],'r','linewidth',2)
title('Entered function on given interval with upper and lower guesses')

% This portion adds the text and math to the top part of the figure window
subplot(2,1,1), text(0,1,['Iteration 1'])
text(0.1,.8,['x1 = xguess2-(f(xguess2)*(xguess1-xguess2))/(f(xguess1)-f(xguess2)) = ',num2str(x1)])
text(0,.4,['Absolute relative approximate error'])
text(0.1,.2,['ea = abs((x1 - xguess2) / x1)*100 = ',num2str(ea),'%'])
axis off
hold off

% --------------------------------------------------------------------------------
% Iteration 2
figure('Position',wind)
x0=xguess2;
x2 = x1-(f(x1)*(x0-x1))/(f(x0)-f(x1));
ea=abs((x2-x1)/x2)*100;
m=(f(x1)-f(x0))/(x1-x0);
b=f(x1)-m*x1;
lefty=(maxi-b)/m;
righty=(mini-b)/m;
% This graphs the function and two lines representing the two guesses
clf
subplot(2,1,2),fplot(f,[lxrange,uxrange])
hold on 
plot([x2,x2],[maxi,mini],'b','linewidth',2)
plot([x0,x0],[maxi,mini],'g','linewidth',2)
plot([x1,x1],[maxi,mini],'g','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
plot([lefty,righty],[maxi,mini],'r','linewidth',2)
title('Entered function on given interval with upper and lower guesses')

% This portion adds the text and math to the top part of the figure window
subplot(2,1,1), text(0,1,['Iteration 2'])
text(0.1,.8,['x2 = x1-(f(x1)*(x0-x1))/(f(x0)-f(x1)) = ',num2str(x2)])
text(0,.4,['Absolute relative approximate error'])
text(0.1,.2,['ea = abs((x2 - x1) / x2)*100 = ',num2str(ea),'%'])
axis off
hold off

% --------------------------------------------------------------------------------
% Iteration 3
figure('Position',wind)

x3 = x2-(f(x2)*(x1-x2))/(f(x1)-f(x2));
ea=abs((x3-x2)/x3)*100;
m=(f(x2)-f(x1))/(x2-x1);
b=f(x2)-m*x2;
lefty=(maxi-b)/m;
righty=(mini-b)/m;
% This graphs the function and two lines representing the two guesses
clf
subplot(2,1,2),fplot(f,[lxrange,uxrange])
hold on 
plot([x3,x3],[maxi,mini],'b','linewidth',2)
plot([x1,x1],[maxi,mini],'g','linewidth',2)
plot([x2,x2],[maxi,mini],'g','linewidth',2)
plot([xguess2,xguess2],[maxi,mini],'k','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
plot([lefty,righty],[maxi,mini],'r','linewidth',2)
title('Entered function on given interval with upper and lower guesses')

% This portion adds the text and math to the top part of the figure window
subplot(2,1,1), text(0,1,['Iteration 2'])
text(0.1,.8,['x3 = x2-(f(x2)*(x1-x2))/(f(x1)-f(x2)) = ',num2str(x3)])
text(0,.4,['Absolute relative approximate error'])
text(0.1,.2,['ea = abs((x3 - x2) / x3)*100 = ',num2str(ea),'%'])
axis off
hold off

