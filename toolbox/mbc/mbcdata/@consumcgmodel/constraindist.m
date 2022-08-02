function y=constraindist(obj, X)
% CONSTRAINDIST Return a distance measure to the constraint surface
%
%  y = CONSTRAINDIST(obj, X) returns the distance to the constraint 
%  surface for each point X. It is positive outside the region, and 
%  negative inside the region

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:56:08 $

output = evalconmodel(obj);

if ~isempty(output)
   if (obj.bound_type == 1) % lower bound
      y = obj.bound - output;
   elseif (obj.bound_type == 0) % upper bound
      y = output - obj.bound;
   else
      error('Bound type should be 0 for upper and 1 for lower');
   end
else
   error('Unable to evaluate sum of model over the data set.');
end
