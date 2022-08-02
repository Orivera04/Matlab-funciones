function p= nlparams(m);
%NLPARAMS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:52:40 $


p= parameters(m);
p= p(1:numNLParams(m));
