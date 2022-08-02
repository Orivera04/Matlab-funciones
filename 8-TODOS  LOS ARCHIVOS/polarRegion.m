function out = polarRegion(a, b, r1, r2)
%POLARREGION is a version for Matlab of the routine on page 159
%  of "Multivariable Calculus and Mathematica" for viewing the region
%  bounded by two curves in polar coordinates. r1 and r2 must be names of 
%  functions [of theta]; a and b are the limits for theta.  The function r1 
%  is plotted in red and the function r1 in blue, and lines are drawn 
%  connecting the two curves to illustrate the region they bound.

Theta = a:(b-a)/40:b;
polar(Theta, r1(Theta), 'r');
hold on
polar(Theta, r2(Theta), 'b');
for theta=a:(b-a)/20:b,
 r=[r1(theta), r2(theta)];
 polar([theta, theta], r, 'c');
end
hold off
