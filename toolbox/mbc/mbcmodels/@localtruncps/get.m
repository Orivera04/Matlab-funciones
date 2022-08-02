function Value=get(m,Property);
% TRUNCPS/GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:01 $


if nargin==1;
   Value= [{'knot'};get(m.localmod);get(m.xreglinear)];
else
   switch lower(Property)
   case {'knot','knots'}
      Value= m.knots;
   case 'order'
      Value= m.order;
   otherwise
      try
         Value= get(m.localmod,Property);
      catch
         try
            Value=get(m.xreglinear,Property);
         catch
            error('TRUNCPS/GET invalid property');
         end
      end  
   end   
end