function [s,g]= nonlin_sse(p,m,varargin);
% MODEL/NONLIN_SSE nonlinear sum of squares error
%
% for nonlinear mle problem

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:42 $

m=update(m,p);
if nargout<2
   r= lsqcost(p,m,varargin{:});
else
   [r,J]= lsqcost(p,m,varargin{:});
   % gradient
   g= -2*r'*J/length(r);
end   
   % cost function
s= sum(r.^2)/length(r);
