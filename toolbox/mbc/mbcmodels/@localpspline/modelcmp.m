function ret=modelcmp(m1,m2)
% MODELCMP   Compare models
%
%   VAL=MODELCMP(MODEL1,MODEL2) compares the two local models
%   and returns 1 if they match, 0 otherwise.
%
%   Parameters compared are:
%       class
%       parent localmod
%       spline orders
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:26 $

% created 31/3/2000

ret=1;
n=1;
% loop over tests while ret is still true
while ret & n<=2
   switch n
   case 1
      % class
      ret=ret & strcmp(class(m1),class(m2));
   case 2
      %  spline orders
      ret=ret & all(getorder(m1)==getorder(m2));      
   end
   n=n+1;
end

