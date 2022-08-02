function int= interiorPoints(c,NewPts);
%INTERIORPOINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:53 $

if nargin>1
   c.InteriorPoints= NewPts;
   int =c;
else
   int= c.InteriorPoints;
end