function err = banker(a,h,v)
%  compute error from 45 degrees for aspect ratio a and data steps h,v
%  err = banker(a,h,v)
%  called by aspect45

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  weight based on step lengths
weight = sqrt(h.^2+a^2*v.^2);
%  deal with 0 in denominator
contrib = zeros(size(h));
index = h~=0;
contrib(index) = abs(a*v(index).*weight(index)./h(index));
contrib(~index) = max(contrib);
err = sum(contrib);
err = abs(err/sum(weight)-1);