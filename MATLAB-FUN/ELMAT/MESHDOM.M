function [X,Y] = meshdom(x,y)
%MESHDOM  Generate X and Y arrays for 3-d plots.
%	This is an obsolete routine.  Use the new MESHGRID instead.
%	Note: The MESHGRID with MATLAB Version 4.0 produces a Y which is
%	flipud(Y) of the Y from MESHDOM.
%	The usage remains the same and the mesh plots are the same if
%	Version 4.0 has been set to axis('ij').
%
%	[X,Y] = MESHDOM(x,y)  transforms the domain specified by vectors
%	x and y into arrays X and Y that can be used for the evaluation
%	of functions of two variables and 3-d mesh and surface plots.
%	The rows of the output array X are copies of the vector x and
%	the columns of the output array Y are copies of the vector y.
%
%	For example, to evaluate and plot the function  x*exp(-x^2-y^2)
%	over the range  -2 < x < 2, -2 < y < 2,
%
%	    [X,Y] = meshdom(-2:.2:2, -2:.2:2);
%	    Z = X .* exp(-X.^2 - Y.^2);
%	    mesh(Z)

%
% 	J. N. Little, 12-2-85; C. B. Moler, 8-20-91.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Make sure x is a full row vector and y is a full column vector.
x = full(x(:)).';
y = full(y(:));
X = x(ones(size(y)),:);
y = y(length(y):-1:1);
Y = y(:,ones(size(x)));
