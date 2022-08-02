function xmin = realmin
%REALMIN Smallest positive floating point number.
%	x = realmin is the smallest positive normalized floating point
%	number on this computer.  Anything smaller underflows or is
%	an IEEE "denormal".
%
%	See also EPS, REALMAX, POW2.

%	C. Moler, 7-26-91, 6-10-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Most computers have IEEE floating point arithmetic,
% but there are a few important exceptions.

comp = computer;

if isieee
   minexp = -1022;
elseif strcmp(comp,'CRAY')
   minexp = -8189;
elseif strcmp(comp(1:3),'VAX')
   % Check if D or G floating point
   if comp(8) == 'D',
      minexp = -128;
   else
      minexp = -1024;
   end
else
   error('Unknown computer type.')
end

% pow2(f,e) is f*2^e, computed by adding e to the exponent of f.

xmin = pow2(1,minexp);
