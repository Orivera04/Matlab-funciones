function Value= get(L,Property);
%LOCALMULTI/GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:39:58 $

if nargin==1
   Value= [{'select'}; get(L.localmod) ; get(L.xregmulti) ];
else
   switch lower(Property)
      case 'select'
         Value= L.Select;
      otherwise
         try
            Value= get(L.localmod,Property);
         catch
            Value= get(L.xregmulti,Property);
         end
   end
end
