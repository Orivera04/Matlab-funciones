function [om,ok]= lsqom(m);
% XREGLINEAR/LSQOM ordinary least squares fit

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:49:45 $

om= contextimplementation(xregoptmgr,m,@i_ols,[],'OLS',@lsqom);


ok=1;

function [m,cost,OK]= i_ols(m,om,x0,varargin);
cost=0;
[m,OK]= leastsq(m,varargin{:});
