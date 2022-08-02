function m= update(m,c);
% xreglinear/UPDATE Update coefficients
%
% m= update(m,c);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:50:21 $



if length(c) ~= length(m.Beta)
   m.TermsOut= logical( zeros(length(c),1) );
   m.TermStatus= 3*ones(size(m.TermsOut));
end
m.Beta = c(:);
