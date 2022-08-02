function rmax = realmax
%REALMAX Largest positive floating point number.
%	x = realmax is the largest floating point number representable
%	on this computer.  Anything larger overflows.
%
%	See also EPS, REALMIN, POW2.

%	C. Moler, 7-26-91, 6-10-92, 8-27-93.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Most computers have IEEE floating point arithmetic,
% but there are a few important exceptions.

if isieee
   % 2-eps is the largest floating point number smaller than 2.
   f = 2-eps;
   maxexp = 1023;
else
   f = 2-2*eps;
   comp = computer;
   if strcmp(comp,'CRAY')
      maxexp = 8189;
   elseif strcmp(comp(1:3),'VAX')
      % Check if D or G floating point
      if comp(8) == 'D',
         maxexp = 126;
      else
         maxexp = 1022;
      end
   else
      error('Unknown computer type.')
   end
end

% pow2(f,e) is f*2^e, computed by adding e to the exponent of f.

rmax = pow2(f,maxexp);
