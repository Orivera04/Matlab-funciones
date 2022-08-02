function y=eval(s,x)
% QUADSPLINE/EVAL evaluate

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:41:06 $



y=zeros(size(x));
% y(:)=NaN;

if isfinite(s.knot)
   m= x <= s.knot;
   y(m) = polyval_mex(s.polylow, ( x(m)-s.knot )) ;
   y(~m) = polyval_mex(s.polyhigh, ( x(~m)-s.knot ));
else
   y(:)=NaN;
end


function y= i_eval(c,x);

y = zeros(size(x));  
for i=1:length(c)  
   y = x .* y + c(i);  
end
