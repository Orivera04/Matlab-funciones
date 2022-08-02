function ps= loadobj(ps)
% localpspline/LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:21 $

if isa(ps,'struct')
   ps= localbspline(ps);
end   

   