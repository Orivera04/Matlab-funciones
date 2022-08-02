function s= nonlin_sse(p,TS,varargin);
% TWOSTAGE/NONLIN_SSE nonlinear sum of squares error
%
% for nonlinear mle problem

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:06 $

r= mle_nlcost(p,TS,varargin{:});

% cost function
s= sum(r.^2);