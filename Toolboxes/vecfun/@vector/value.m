function y=value(f)
%VALUE  Return constant values.
%   VALUE(F) returns the values of a constant
%   vector function.

% Copyright (c) 2001-08-31, B. Rasmus Anthin.

if isconst(f,1)
   ev=eval(f.Fx);
   y(1)=ev(1);
else
   y(1)=nan;
end
if isconst(f,2)
   ev=eval(f.Fy);
   y(2)=ev(1);
else
   y(2)=nan;
end
if isconst(f,3)
   ev=eval(f.Fz);
   y(3)=ev(1);
else
   y(3)=nan;
end
if all(isnan(y)), y=[];end