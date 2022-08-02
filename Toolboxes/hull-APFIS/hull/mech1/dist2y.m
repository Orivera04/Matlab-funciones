function [pntload]=dist2y(mags, place, offset)
%DIST2Y Converts a distributed load to a point force acting in the Y.
%   DIST2Y([MAGNITUDE1, MAGNITUDE2],[LOCATION1, LOCATION2], OFFSET) is
%   the point load equivalent of the distributed load acting in the
%   Y direction.  Offset is the X value where the force is located, if
%   left unspecified, it defaults to 0;
%
%   See also DEG2XY, DIST2X, DISTLOAD, RAD2XY, RISE2XY, XY2DEG, XY2RAD.   

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if nargin<3
  offset=0;
end
 
for i=1:rows(mags)
  [F, P]=distload(mags(i,1),mags(i,2),place(i,2)-place(i,1));
  pntload(i,:)=[0 F place(i,1)+P offset];
end
