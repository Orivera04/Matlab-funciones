% Topic      : Bisection Method - Roots of Equations
% Simulation : Graphical Simulation of the Method
% Language   : Matlab r12
% Authors    : Nathan Collier, Autar Kaw
% Date       : 6 September 2002
% Abstract   : This simulation shows how the bisection method works for finding roots of
%              an equation f(x)=0
%
clear all
% INPUTS: Enter the following
% Function in f(x)=0
f = inline('x^3-0.165*x^2+3.993*10^(-4)');
% Upper initial guess
xu = 0.11;
% Lower initial guess
xl = 0.0;
% Lower bound of range of 'x' to be seen
lxrange = -0.02;
% Upper bound of range of 'x' to be seen
uxrange = 0.12;
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
plot([xl,xl],[maxi,mini],'y','linewidth',2)
plot([xu,xu],[maxi,mini],'g','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with initial guesses')


hold off

% --------------------------------------------------------------------------------
% Iteration 1
figure('Position',wind)
xr=(xu+xl)/2;
% This graphs the function and two lines representing the two guesses
clf
subplot(3,1,2),fplot(f,[lxrange,uxrange])
hold on 
plot([xl,xl],[maxi,mini],'y','linewidth',2)
plot([xu,xu],[maxi,mini],'g','linewidth',2)
plot([xr,xr],[maxi,mini],'r','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with upper and lower guesses')

% This portion adds the text and math to the top part of the figure window
subplot(3,1,1), text(0,1,['Iteration 1'])
text(0.2,.8,['xr = (xu + xl)/2 = ',num2str(xr)])
text(0,.6,['Finding the value of the function at the lower and upper guesses and the estimated root'])
text(0.2,.4,['f(xl) = ',num2str(f(xl))])
text(0.2,.2,['f(xu) = ',num2str(f(xu))])
text(0.2,0,['f(xr) = ',num2str(f(xr))])
axis off
hold off

% Check the interval between which the root lies
if f(xu)*f(xr)<0
    xl=xr;
else
    xu=xr;
end

% This portion adds the text and math to the bottom part of the figure window
subplot(3,1,3), text(0,1,['Check the interval between which the root lies. Does it lie in ( xl , xu ) or ( xr , xu )?'])
text(0,.8,[''])
text(0.2,0.6,['xu = ',num2str(xu)])
text(0.2,0.4,['xl = ',num2str(xl)])
axis off
xp=xr;

% --------------------------------------------------------------------------------
% Iteration 2
figure('Position',wind)
xr=(xu+xl)/2;
% This graphs the function and two lines representing the two guesses
clf
subplot(3,1,2),fplot(f,[lxrange,uxrange])
hold on 
plot([xl,xl],[maxi,mini],'y','linewidth',2)
plot([xu,xu],[maxi,mini],'g','linewidth',2)
plot([xr,xr],[maxi,mini],'r','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with upper and lower guesses')

% This portion adds the text and math to the top part of the figure window
subplot(3,1,1), text(0,1,['Iteration 2'])
text(0.2,.8,['xr = (xu + xl) / 2 = ',num2str(xr)])
text(0,.6,['Finding the value of the function at the lower and upper guesses and the estimated root'])
text(0.2,.4,['f(xl) = ',num2str(f(xl))])
text(0.2,.2,['f(xu) = ',num2str(f(xu))])
text(0.2,0,['f(xr) = ',num2str(f(xr))])
axis off
hold off

% Check the interval between which the root lies
if f(xu)*f(xr)<0
    xl=xr;
else
    xu=xr;
end

% Calculate relative approximate error
ea=abs((xr-xp)/xr)*100;

% This portion adds the text and math to the bottom part of the figure window
subplot(3,1,3), text(0,1,['Absolute relative approximate error'])
text(0,.8,['ea = abs((xr - xp) / xr)*100 = ',num2str(ea),'%'])
text(0,.4,['Check the interval between which the root lies. Does it lie in ( xl , xu ) or ( xr , xu )?'])
text(0.2,0.2,['xu = ',num2str(xu)])
text(0.2,0,['xl = ',num2str(xl)])
axis off
xp=xr;

% --------------------------------------------------------------------------------
% Iteration 3
figure('Position',wind)
xr=(xu+xl)/2;
% This graphs the function and two lines representing the two guesses
clf
subplot(3,1,2),fplot(f,[lxrange,uxrange])
hold on 
plot([xl,xl],[maxi,mini],'y','linewidth',2)
plot([xu,xu],[maxi,mini],'g','linewidth',2)
plot([xr,xr],[maxi,mini],'r','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with upper and lower guesses')

% This portion adds the text and math to the top part of the figure window
subplot(3,1,1), text(0,1,['Iteration 3'])
text(0.2,.8,['xr = (xu + xl) / 2 = ',num2str(xr)])
text(0,.6,['Finding the value of the function at the lower and upper guesses and the estimated root'])
text(0.2,.4,['f(xl) = ',num2str(f(xl))])
text(0.2,.2,['f(xu) = ',num2str(f(xu))])
text(0.2,0,['f(xr) = ',num2str(f(xr))])
axis off
hold off

% Check the interval between which the root lies
if f(xu)*f(xr)<0
    xl=xr;
else
    xu=xr;
end

% Calculate relative approximate error
ea=abs((xr-xp)/xr)*100;

% This portion adds the text and math to the bottom part of the figure window
subplot(3,1,3), text(0,1,['Absolute relative approximate error'])
text(0,.8,['ea = abs((xr - xp) / xr)*100 = ',num2str(ea),'%'])
text(0,.4,['Check the interval between which the root lies. Does it lie in ( xl , xu ) or ( xr , xu )?'])
text(0.2,0.2,['xu = ',num2str(xu)])
text(0.2,0,['xl = ',num2str(xl)])
axis off
xp=xr;

% --------------------------------------------------------------------------------
% Iteration 4
figure('Position',wind)
xr=(xu+xl)/2;
% This graphs the function and two lines representing the two guesses
clf
subplot(3,1,2),fplot(f,[lxrange,uxrange])
hold on 
plot([xl,xl],[maxi,mini],'y','linewidth',2)
plot([xu,xu],[maxi,mini],'g','linewidth',2)
plot([xr,xr],[maxi,mini],'r','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with upper and lower guesses')

% This portion adds the text and math to the top part of the figure window
subplot(3,1,1), text(0,1,['Iteration 4'])
text(0.2,.8,['xr = (xu + xl) / 2 = ',num2str(xr)])
text(0,.6,['Finding the value of the function at the lower and upper guesses and the estimated root'])
text(0.2,.4,['f(xl) = ',num2str(f(xl))])
text(0.2,.2,['f(xu) = ',num2str(f(xu))])
text(0.2,0,['f(xr) = ',num2str(f(xr))])
axis off
hold off

% Check the interval between which the root lies
if f(xu)*f(xr)<0
    xl=xr;
else
    xu=xr;
end

% Calculate relative approximate error
ea=abs((xr-xp)/xr)*100;

% This portion adds the text and math to the bottom part of the figure window
subplot(3,1,3), text(0,1,['Absolute relative approximate error'])
text(0,.8,['ea = abs((xr - xp) / xr)*100 = ',num2str(ea),'%'])
text(0,.4,['Check the interval between which the root lies. Does it lie in ( xl , xu ) or ( xr , xu )?'])
text(0.2,0.2,['xu = ',num2str(xu)])
text(0.2,0,['xl = ',num2str(xl)])
axis off
xp=xr;

% --------------------------------------------------------------------------------
% Iteration 5
figure('Position',wind)
xr=(xu+xl)/2;
% This graphs the function and two lines representing the two guesses
clf
subplot(3,1,2),fplot(f,[lxrange,uxrange])
hold on 
plot([xl,xl],[maxi,mini],'y','linewidth',2)
plot([xu,xu],[maxi,mini],'g','linewidth',2)
plot([xr,xr],[maxi,mini],'r','linewidth',2)
plot([lxrange,uxrange],[0,0],'k','linewidth',1)
title('Entered function on given interval with upper and lower guesses')

% This portion adds the text and math to the top part of the figure window
subplot(3,1,1), text(0,1,['Iteration 5'])
text(0.2,.8,['xr = (xu + xl) / 2 = ',num2str(xr)])
text(0,.6,['Finding the value of the function at the lower and upper guesses and the estimated root'])
text(0.2,.4,['f(xl) = ',num2str(f(xl))])
text(0.2,.2,['f(xu) = ',num2str(f(xu))])
text(0.2,0,['f(xr) = ',num2str(f(xr))])
axis off
hold off

% Check the interval between which the root lies
if f(xu)*f(xr)<0
    xl=xr;
else
    xu=xr;
end

% Calculate relative approximate error
ea=abs((xr-xp)/xr)*100;

% This portion adds the text and math to the bottom part of the figure window
subplot(3,1,3), text(0,1,['Absolute relative approximate error'])
text(0,.8,['ea = abs((xr - xp) / xr)*100 = ',num2str(ea),'%'])
text(0,.4,['Check the interval between which the root lies. Does it lie in ( xl , xu ) or ( xr , xu )?'])
text(0.2,0.2,['xu = ',num2str(xu)])
text(0.2,0,['xl = ',num2str(xl)])
axis off
xp=xr;