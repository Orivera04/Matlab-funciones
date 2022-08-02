function out = verticalRegion(a, b, f, g)
%VERTICALREGION is a version for Matlab of the routine on page 157
%  of "Multivariable Calculus and Mathematica" for viewing the region
%  bounded by two curves. f and g must be names of functions;
%  a and b are the limits.  The function f is plotted in red and the
%  function g in blue, and lines are drawn connecting the two curves
%  to illustrate the region they bound.

X = a:(b-a)/40:b;
plot(X, f(X), 'r');
hold on
plot(X, g(X), 'b');
for x=a:(b-a)/20:b,
 Y=[f(x), g(x)];
 plot([x, x], Y, 'c');
end
hold off
