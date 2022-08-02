function cmap = contrast(x,m);
%CONTRAST Gray scale color map to enhance image contrast.
%
%	CMAP = CONTRAST(X,M) returns a gray scale color map, 
%	that is a M-by-3 matrix with 3 identical columns, so that
%	    IMAGE(X)
%	    COLORMAP(CMAP)
%	has a roughly equi-distributed gray scale histogram.
%	If M is omitted, the default length 64 is used.

%	Cleve Moler 5-8-91, 7-20-91.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 2, m = 64; end
xmin = min(min(x));
xmax = max(max(x));
x = round((m-1)*(x-xmin)/(xmax-xmin));
f = find(diff(sort([x(:); (0:m)'])));
f = f/max(f);
cmap = [f f f];
