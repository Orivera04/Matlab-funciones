function y = detrend(x,o)
%DETREND Remove a linear trend from a vector, usually for FFT processing.
%	Y = DETREND(X) removes the best straight-line fit from the data in
%	vector X and returns it in vector Y.  If X is a matrix, DETREND
%	removes the trend from each column of the matrix.
%	Y = DETREND(X,0) removes just the mean value from vector X, or
%	the mean value from each column, if X is a matrix.

%	Author(s): J.N. Little, 6-08-86
%		   J.N. Little, 2-29-88, revised
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/25 17:59:00 $

if nargin == 1
	o = 1;
end
[m,n] = size(x);
if m == 1	% If a row, turn into column vector
	x = x(:);
end
[mp,np] = size(x);
if o == 0	% Remove just mean from each column
	y = x - ones(mp,1)*mean(x);
else		% Remove straight-line fit from each column
	a = [(1:mp)'/mp ones(mp,1)];
	y = x - a*(a\x);
end
if m == 1
	y = y.';
end

