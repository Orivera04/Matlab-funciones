function [s,g]=lsqcon(B,L,varargin);
% LOCALMOD/LSQCON cost functions for fmincon

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:22 $

if nargout>1
   [r,J]= gls_costB(B,L,varargin{:});
   % gradient
   g= -2*r'*J;
else
   r = gls_costB(B,L,varargin{:});
end
s= sum(r.^2);