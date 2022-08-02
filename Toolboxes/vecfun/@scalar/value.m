function y=value(f)
%VALUE  Return constant value.
%   VALUE(F) returns the value of a constant
%   scalar function.

% Copyright (c) 2001-08-31, B. Rasmus Anthin.

y=[];
if isconst(f)
   y=eval(f.F);
   y=y(1);
end