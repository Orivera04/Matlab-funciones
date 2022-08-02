function y=eval(m,x)
% xreglinear/EVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:27 $

if m.Constant
   y= x*m.Beta(2:end)+m.Beta(1);
else
   y= x*m.Beta;
end