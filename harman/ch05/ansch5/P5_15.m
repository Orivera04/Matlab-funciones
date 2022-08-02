% P5_15.M Solve differential equation
%  (Requires Symbolic Math Toolbox)
%  Uses gtext to annotate graphs
clear
clf
y=dsolve('a*D2y+b*Dy+890*y=0','y(0)=0.15','Dy(0)=0','t');
y=subs(y,'a',9.082)  % Or use 9208/1000 since dsolve rejects floating pt.
%
hold on
ezplot(subs(y,'b',200),[0,1])
gtext('b=200')      % Label the curve with mouse click
ezplot(subs(y,'b',179.8),[0,1])
gtext('b=179.8')
ezplot(subs(y,'b',100),[0,1])
gtext('b=100') 
title('Solution to 9.082*D2y+b*Dy+890*y')
ylabel('y(t)')
hold off
%
% Improve the titles and labeling of the graphs.
%
% Version 5  Changed called to subs