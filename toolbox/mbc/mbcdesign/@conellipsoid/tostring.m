function ch=tostring(obj,fact)
%TOSTRING  Create string representation of constraint
%
%  STR=TOSTRING(CON,FACTORS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:58:15 $

if obj.scalefactor<0
   ch = ['Inverse ellipsoid at (',sprintf('%g, ',obj.xc(:))];
else
   ch= ['Ellipsoid at (',sprintf('%g, ',obj.xc(:))];
end
ch=[ch(1:end-2) ')'];
