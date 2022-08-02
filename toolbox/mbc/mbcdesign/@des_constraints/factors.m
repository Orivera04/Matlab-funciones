function c=factors(c,f)
% FACTORS   Update constraints with new factor labels
%
%   F=FACTORS(C) returns the factor labels that C is using.
%   C=FACTORS(C,F) changes the factor labels to F.  If the length of
%   F is not the same as the current factor labels then they will
%   not be changed.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:50 $


if nargin>1
   f=f(:)';
   if length(f)==length(c.Factors)
      c.Factors=f;
   end
   if ~nargout
      nm=inputname(1);
      assignin('base',nm,c);
   end      
else
   c=c.Factors;
end
return
   