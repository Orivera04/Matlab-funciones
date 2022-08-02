function p=loadobj(p);
%LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:31 $

if isa(p,'struct');
   switch p.version 
   case 1
      p = localpoly(p.c);
   otherwise
      p = localpoly(p);
   end
end
