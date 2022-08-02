function [no,xo] = hist(y,x,miny,maxy)
%HIST	Plot histograms.
%	HIST(Y) plots a histogram with 10 equally spaced bins between
%	the minimum and maximum values in Y, showing the distribution
%	of the elements in vector Y.
%	HIST(Y,N), where N is a scalar, uses N bins.
%	HIST(Y,X), where X is a vector, draws a histogram using the
%	bins specified in X.
%	[N,X] = HIST(...) does not draw a graph, but returns vectors
%	X and N such that BAR(X,N) is the histogram.
%
%	See also BAR.

%	J.N. Little 2-06-86
%	Revised 10-29-87, 12-29-88 LS
%	Revised 8-13-91 by cmt, 2-3-92 by ls.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 0
	error('Requires one or two input arguments.')
end
if nargin == 1
    x = 10;
end
if min(size(y))==1, y = y(:); end
if isstr(x) | isstr(y)
	error('Input arguments must be numeric.')
end
[m,n] = size(y);
if max(size(x)) == 1
%    miny = min(min(y));
%    maxy = max(max(y));
    binwidth = (maxy - miny) ./ x;
    xx = miny + binwidth*[0:x];
    xx(length(xx)) = maxy;
%    x = xx(1:length(xx)-1) + binwidth/2
    x = xx(1:length(xx)-1);
else
	xx = x(:)';
    miny = min(min(y));
    maxy = max(max(y));
    binwidth = [diff(xx) 0];
    xx = [xx(1)-binwidth(1)/2 xx+binwidth/2];
    xx(1) = miny;
    xx(length(xx)) = maxy;
end
nbin = max(size(xx));
nn = zeros(nbin,n);
for i=2:nbin
    nn(i,:) = sum(y <= xx(i));
end
nn = nn(2:nbin,:) - nn(1:nbin-1,:);
if nargout == 0
    bar(x,nn);
else
  if min(size(y))==1, % Return row vectors if possible.
    no = nn';
    xo = x;
  else
    no = nn;
    xo = x';
  end
end
