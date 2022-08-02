function y = fliplr(x)
%FLIPLR	Flip matrix in the left/right direction.
%	FLIPLR(X) returns X with row preserved and columns flipped
%	in the left/right direction.
%	
%	X = 1 2 3     becomes  3 2 1
%	    4 5 6              6 5 4
%
%	See also FLIPUD, ROT90.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m,n] = size(x);
y = x(:,n:-1:1);
