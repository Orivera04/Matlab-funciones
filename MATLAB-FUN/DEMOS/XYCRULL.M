function  [xt,yt] = xycrull(t);
%XYCRULL Function that returns the coordinate functions
%	for the eccentric ellipse that generates the cruller
%	in the M-file CRULLER.
 
%       C. Henry Edwards, Univerity of Georgia. 6/20/93.
%
%	Copyright (c) 1984-94 by The MathWorks, Inc.

xt = 3*cos(t);   yt = sin(t);

