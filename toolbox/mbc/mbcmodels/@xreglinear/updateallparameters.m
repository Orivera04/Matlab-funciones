function m= updateallparameters(m,b);
%XREGLINEAR/UPDATEALLPARAMETERS 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:22 $

m.Beta=b;
m.TermsOut= b==0;
if length(m.TermStatus)~=length(b)
   m.TermStatus= 3*ones(size(b));
end




