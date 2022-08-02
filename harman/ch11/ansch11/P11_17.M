% P11_17.M Surface normals to a sphere
%
% In this case, the command sphere can be used. Otherwise, compute the
%  gradient. Then, use command surfnorm to plot results.
%
clear
clf
[x,y,z]=sphere(20);
surfnorm(x,y,z)
xlabel('x')
ylabel('y')
%
% for a general surface, compute the gradient
%
