function t = isvector(x)
%ISVECTOR True for vector input.
%
%   ISVECTOR(X) returns 1 if X is a vector and 0 otherwise.  An array is
%   considered a vector if the length along each dimension is larger than
%   one for at most one dimension.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:50:47 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   t = sum(size(x) > 1) <= 1;
