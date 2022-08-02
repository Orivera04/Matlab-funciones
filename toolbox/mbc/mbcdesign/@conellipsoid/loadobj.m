function c = loadobj(c)
%LOADOBJ  Loadobj for conellipsoid
%
%  C = LOADOBJ(C)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:58:05 $

if isstruct(c)
   if c.version < 2
      c.scalefactor = 1;      
      c.version = 2;
   end
   c = conellipsoid(c);
end