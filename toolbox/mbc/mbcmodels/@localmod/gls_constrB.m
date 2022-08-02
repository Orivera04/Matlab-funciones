function [s,g]=gls_constrB(B,L,varargin);
% LOCALMOD/GLS_CONSTRB cost functions for fmincon

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:07 $

if nargout>1
   % least square cost function
   [r,J]= gls_costB(B,L,varargin{:});
   % gradient
   g= -2*r'*J;
else
   r= gls_costB(B,L,varargin{:});
end
% cost function
s= sum(r.^2);