function C = getconstants(N)
% returns cgconstant children of this node

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:22:46 $
sf = getdata(N);
C = sf.getconstants;