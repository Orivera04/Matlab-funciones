% EX5_4.M  Solve symbolically the second order equation
%  D2y+b*Dy+c*y=0  and plot for b=1, b=3 with c=1.
%  
sym('b')
y = dsolve('D2y+b*Dy+1*y=0','y(0)=1','Dy(0)=0','t');
y=simple(y)                   % Simplify the solution
% Substitute values b=1 and b=3
clf                           % Clear any figures and
hold on                       %  plot multiple graphs
ezplot(subs(y,'b',3.0),[0,10])
gtext('b=3')                  % Annotate text with mouse
ezplot(subs(y,'b',1.0),[0,10])
gtext('b=1')  
title('Solution to D2y+b*Dy+y=0, y(0)=1,Dy(0)=0')
ylabel('y(t)')
grid
hold off                       % Default setting
%
%  Make this script more general; i.e. plot arbitrary 
%    values of b and different ranges of t
%
% Version 5 Add sym and modify call to subs