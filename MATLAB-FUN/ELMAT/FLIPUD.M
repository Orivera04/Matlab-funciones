function y = flipud(x)
%FLIPUD	Flip matrix in the up/down direction.
%	FLIPUD(X) returns X with columns preserved and rows flipped
%	in the up/down direction.  For example,
%	
%	X = 1 4      becomes  3 6
%	    2 5               2 5
%	    3 6               1 4
%
%	See also FLIPLR, ROT90.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m,n] = size(x);
y = x(m:-1:1,:);
