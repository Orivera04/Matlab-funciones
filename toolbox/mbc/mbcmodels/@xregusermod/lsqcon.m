function [s,g]=lsqcon(p,U,varargin);
% xregusermod/LSQCON cost functions for fmincon

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:25 $


U.parameters=p(:);
if nargout>1
   [r,J]= lsqcost(U,varargin{:});
   % gradient
   g= -2*r'*J/length(r);
else
   r = lsqcost(U,varargin{:});
end
% cost function
s= sum(r.^2)/length(r);