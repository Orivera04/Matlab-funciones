function [y,h]=mmlimit(x,xmin,xmax)
%MMLIMIT Limit Values Between Extremes. (MM)
% Y=MMLIMIT(X,Xmin,Xmax) returns the values in the
% array X after limiting them between Xmin and Xmax.
% If Xmin and Xmax are arrays the same size as X,
%    Y(i,j)=min(max(Xmin(i,j),X(i,j)),Xmax(i,j)).
% If Xmin and Xmax are scalars, they apply to each
% element in X.
%
% [Y,H]=MMLIMIT(X,Xmin,Xmax) in addition returns an array H
% where H(i,j) = -1 if the lower limit is hit,
%       H(i,j) = +1 if the upper limit is hit, and
%       H(i,j) = 0 if Y(i,j) = X(i,j)
%
% See also MIN, MAX

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/22/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if any(xmin>=xmax), error('Xmax > Xmin Required.'), end
y=min(max(xmin,x),xmax);
if nargout>1
	h=(y>=xmax)-(y<=xmin);
end
