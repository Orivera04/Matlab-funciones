function out = verticalRegion(a, b, f, g)
%VERTICALREGION is a version for Matlab of the routine on page 157
%  of "Multivariable Calculus and Mathematica" for viewing the region
%  bounded by two curves. f and g must be names of functions;
%  a and b are the limits.  The function f is plotted in red and the
%  function g in blue, and lines are drawn connecting the two curves
%  to illustrate the region they bound. The function g must have a variable
%  in it, so if it's supposed to be a constant, try a fudge like
%  '0 + eps*x'.
var=findsym(g);
a=double(a);b=double(b);
%This guarantees these are floating point
% numbers and not just symbolic expressions like sqrt(2)
xx=a:(b-a)/40:b;
fin=inline([vectorize(f+var-var),'+zeros(size(',char(var),'))'],char(var));
gin=inline(vectorize(g+var-var),char(var));
plot(xx,fin(xx),'r');
hold on
plot(xx,gin(xx),'b');
for xxx=a:(b-a)/20:b,
 Y=[fin(xxx), gin(xxx)];
 plot([xxx, xxx], Y, 'c');
end
title(['region between ',char(f),' and ',char(g)])
hold off
