function m= UpdateParams(m,b)
% xreglinear/UPDATEPARAMS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:49:11 $



m.Beta(m.TermsOut)= 0;
m.Beta(~m.TermsOut)= b(:);