function out = issum(constraint)
%ISSUM Check if constraint is a sum model
%
%  OUT = ISSUM(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:09:23 $

% returns 1 if it is a sum over a drivecycle
if isa(constraint.conobj, 'consumcgmodel')
   out = 1;
else
   out = 0;
end
