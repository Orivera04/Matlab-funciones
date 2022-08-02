function  [xt,yt] = xylink1d(t);
%XYLINK1D Coordinates of an off-center circle.
%       XYLINK1D returns the coordinates of an off-center
%       circle used to generated a torus for TORI4.
 
%       C. Henry Edwards, University of Georgia. 6-20-93.
%
%	Copyright (c) 1984-94 by The MathWorks, Inc.


xt = 1 + 0.5*cos(t);   yt = -1 + 0.5*sin(t);

