function v=vif(m)
%xreglinear/VIF   Partial VIFs
%   v=VIF(m) calculates Partial VIF for model
%
%
%   Calls COV and COV2CORR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:45 $

v=vif(m.userdefined);