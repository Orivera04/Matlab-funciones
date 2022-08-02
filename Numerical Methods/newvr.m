function out = verticalRegion(a, b, f, g)
%VERTICALREGION is a version for Matlab of the routine on page 157
%  of "Multivariable Calculus and Mathematica" for viewing the region
%  bounded by two curves. f and g must be names of functions;
%  a and b are the limits.  The function f is plotted in red and the
%  function g in blue, and lines are drawn connecting the two curves
%  to illustrate the region they bound.


genplot(f,a:(b-a)/40:b,'plot','r');
hold on
genplot(g, a:(b-a)/40:b,'plot','b');
fin=inline(vectorize(f));
gin=inline(vectorize(g));
for x=a:(b-a)/20:b,
 Y=[fin(x), gin(x)];
 plot([x, x], Y, 'c');
end
hold off
