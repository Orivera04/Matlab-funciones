function p=mmcurvelen(x,y,xmm)
%MMCURVELEN Length Along a Plane Curve. (MM)
% MMCURVELEN(X,Y) computes the length of the plane curve described by
% the data in X and Y. X must be a vector, but Y may be a column oriented
% data matrix. The length of X must equal the length of Y if Y is a
% vector, or it must equal the number of rows in Y if Y is a matrix.
%
% The length is computed as the sum of the straight line distances 
% between data points.
%
% X need not be equally spaced.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/29/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

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

dx = repmat(diff(x),1,cy);
dy = diff(y);

p = sum(sqrt(dx.^2 + dy.^2));