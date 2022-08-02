function [c,ind]=duplicate(c,ind);
%DUPLICATE  Duplicate a constraint
%
%  [C,NEWIND]=DUPlICATE(C,IND)  duplicates the specified constraint.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:01:47 $

if ind<=length(c.Constraints);
   con=c.Constraints{ind};
   c.Constraints=[c.Constraints {con}];
   ind=length(c.Constraints);
end