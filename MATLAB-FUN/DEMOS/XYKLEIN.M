function  [xt,yt] = xyklein(t);
%XYKLEIN Coordinate functions for the figure-8 that
%	generates the Klein bottle in KLEIN1.

%       C. Henry Edwards, Univerity of Georgia. 6/20/93.
%
%	Copyright (c) 1984-94 by The MathWorks, Inc.

xt = sin(t);   yt = sin(2*t);

