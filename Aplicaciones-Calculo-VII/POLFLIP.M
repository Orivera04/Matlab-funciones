function y=polflip(a,x)
%
% y=polflip(a,x)
% ~~~~~~~~~~~~~~
%
% This function evaluates polyval(a,x) with 
% the order of the elements reversed.
%
%----------------------------------------------

y=polyval(a(end:-1:1),x);