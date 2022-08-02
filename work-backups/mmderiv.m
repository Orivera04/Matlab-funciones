function z=mmderiv(x,y)
%MMDERIV Derivative Using Weighted Central Differences. (MM)
% MMDERIV(X,Y) computes the derivative of the function y=f(x) given the
% data in X and Y. X must be a vector, but Y may be a column oriented
% data matrix. The length of X must equal the length of Y if Y is a
% vector, or it must equal the number of rows in Y if Y is a matrix.
%
% X need not be equally spaced.
% Weighted central differences is used, which is based on an incremental
% quadratic polynomial fit.
%
% See also MMINTGRL, DIFF.


% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/29/95, v5: 1/13/97, 9/29/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

flag = 0;  % flag is true if y is a row
x = x(:);    % make x a column
nx = length(x);
if ndims(y)~=2
   error('Y Must be 2D.')
end
[ry,cy] = size(y);
if ry==1&cy==nx  % if y is a row, flip it
   y = y.';
   ry = cy;
   cy = 1;
   flag = 1;
end
if nx~=ry, error('X and Y Not the Right Size.'), end

h0 = repmat(x(2:end-1)-x(1:end-2),1,cy);
h1 = repmat(x(3:end)-x(1:end-2),1,cy);
d0 = y(2:end-1,:)-y(1:end-2,:);
d1 = y(3:end,:)-y(1:end-2,:);

D = h0.*h1.*(h0 - h1);
a = (h1.*d0 - h0.*d1)./D;
b = (h0.*h0.*d1 - h1.*h1.*d0)./D;

z = [b(1,:); 2*a.*h0 + b; 2*a(end,:).*h1(end,:) + b(end,:)];

if flag, z=z.'; end		% if y was a row, return a row
