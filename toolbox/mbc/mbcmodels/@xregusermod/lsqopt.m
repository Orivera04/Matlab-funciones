function [r,J]=lsqopt(p,U,varargin);
%XREGUSERMOD/LSQOPT cost function for least squares (fmincon)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:26 $

U.parameters=p(:);
if nargout==2
   [r,J]= lsqcost(U,varargin{:});
   J= -J;
else
   [r]= lsqcost(U,varargin{:});
end