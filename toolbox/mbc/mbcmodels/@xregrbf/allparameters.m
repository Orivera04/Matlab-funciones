function b= allparameters(m);
%XREGRBF/ALLPARAMETERS 
%
% b= [nc; size(widths); lambda; widths(:); centers(:); weights(:)];

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:54:17 $

% strip out unwanted terms
tin= Terms(m);
w= m.width;
c= m.centers;
if ~all(tin) && any(tin)
   c= c(tin,:);
   if size(w,1)>1
      w= w(tin,:);
   end
   b=  parameters(m);
else
   b=  double(m);
end

lambda= get(m,'lambda');

b= [size(c,1); size(w)'; lambda; w(:); c(:); b(:)];


