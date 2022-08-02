%FILTER	Digital filter.
%	Y = FILTER(B, A, X) filters the data in vector X with the
%	filter described by vectors A and B to create the filtered
%	data Y.  The filter is a "Direct Form II Transposed"
%	implementation of the standard difference equation:
%
%	y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
%	                 - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
%
%	[Y,Zf] = FILTER(B,A,X,Zi) gives access to initial and final
%	conditions, Zi and Zf, of the delays.
%
%	See also FILTFILT in the Signal Processing Toolbox.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
