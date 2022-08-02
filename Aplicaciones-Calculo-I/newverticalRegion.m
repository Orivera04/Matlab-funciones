function out = newverticalRegion(a, b, f, g)
%NEWVERTICALREGION is a new version (using function handles instead of
%  inline functions) for viewing the region bounded by two curves. 
%
%  sample syntax: newverticalRegion(0, 1, x^2, sqrt(x))
%
%  f and g should be symbolic expressions (in a symbolic variable,
%  usually x), and a and b are the limits.  The function f is plotted 
%  in red and the function g in blue, and lines are drawn connecting 
%  the two curves to illustrate the region they bound. 
%  The functions f and g must have a variable in them, so if either one
%  is constant, try a fudge like '3 + 0*x' (this will work for f but not
%  for g) or '3 + eps*x'.
var=symvar(g);
a=double(a);b=double(b);
%This guarantees these are floating point
% numbers and not just symbolic expressions like sqrt(2)
% Now we rename the symbolic variable x, in case it's something 
% different
syms x; f1 = subs(f, var, x); f2 = subs(f, var, x);
xx=a:(b-a)/40:b;
fin=@(x) eval(vectorize(f));
gin=@(x) eval(vectorize(g));
plot(xx,fin(xx),'r');
hold on
plot(xx,gin(xx),'b');
for xxx=a:(b-a)/20:b,
 Y=[fin(xxx), gin(xxx)];
 plot([xxx, xxx], Y, 'c');
end
title(['region between ',char(f),' and ',char(g)])
hold off