function [S,rho]=cov2corr(C);
% XREGCOV2CORR convert covariance matrix to a correlation matrix
%
% [S,rho]=cov2corr(C);
%   Input  C covariance matrix
%   Outputs 
%     S    standard errors (sqrt of diagonal elements)
%     rho  correlation matrix

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:02:23 $

S=sqrt(diag(C));
n=size(C,1);
sv=spdiags(1./S,0,n,n);
rho= sv*C*sv;