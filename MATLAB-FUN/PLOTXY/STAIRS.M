function [xo,yo] = stairs(x,y)
%STAIRS	Stairstep graph (bar graph without internal lines).
%	Stairstep plots are useful for drawing time history plots of
%	digital sampled-data systems.
%	STAIRS(Y) draws a stairstep graph of the elements of vector Y.
%	STAIRS(X,Y) draws a stairstep graph of the elements in vector Y at
%	the locations specified in X.  The X-values must be in
%	ascending order and evenly spaced.
%	[XX,YY] = STAIRS(X,Y) does not draw a graph, but returns vectors
%	X and Y such that PLOT(XX,YY) is the stairstep graph.
%
%	See also BAR, HIST.

%	L. Shure, 12-22-88.
%	Revised A.Grace and C.Thompson 8-22-90.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[n,nx] = size(x); 
if isstr(x)
	error('Input arguments must be numeric.')
end
if min(n,nx) > 1
	error('Input arguments must be vectors.')
end

% Transpose x if row vector
if (n == 1 & nx > 1), x = x.'; end 

[n,nx] = size(x); 
if nargin==1, y=x; x=[0:n-1]'; end 
if isstr(y)
	error('Input arguments must be numeric.')
end

[n,nc] = size(y); 

% Transpose x if row vector
if (n == 1 & nc > 1), y = y.'; [n,nc] = size(y); end 

if (nx ~= nc & nx~= 1 & nc ~= 1)
    error('Vectors must have the same number of columns')
end

y2 = [];
for i=1:nc 
    y1 = [ y(:,i).'; y(:,i).'];
    y2 = [y2, y1(:)];
end


x2 = [];
for i=1:nx 
    x1 = [ x(:,i).'; x(:,i).'];
    x2 = [x2, x1(:)];
end
% Remove extraneous first point
x2(1,:) = [];
 
% Uncomment next line if you want last point to be flat
%x2 = [x2; 2*x2(2*n-1,:)-x2(2*n-3,:)];
% ... and comment out the next line. 
y2(2*n,:) = [];

if (nargout == 0)
    plot(x2,y2);
else
    xo = x2; 
    yo = y2;
end
