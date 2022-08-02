function r2 = polyfitr2(x,y,powers)
%  Determine the r^2 values for polynomial fits of several powers
%  r2 = polyfitr2(x,y,powers)

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

np = length(powers);
r2 = zeros(size(powers));

for ii = 1:np
   [p,s] = polyfit(x,y,powers(ii));
   r2(ii) = s.normr^2;
end
