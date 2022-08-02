function poly= update(poly,p,tp);
% POLYNOM/UPDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:53 $

p= p(:);

% coefficients stored in xreglinear
poly.xreglinear= update(poly.xreglinear,p);

if nargin<3
   switch DatumType(poly)
   case 1
      % datum should be at maximum
      [mx,tp]= max(poly);
   case 2
      [mx,tp]= min(poly);
   otherwise 
      tp= [];
   end
end
%
if ~(isempty(tp) | ~isreal(tp) | length(tp)>1);
   % shift polynom by datum
   poly= shift(poly,tp);
   poly= datum(poly,tp);
end


