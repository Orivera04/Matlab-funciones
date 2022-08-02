function c=cov(m)
%xreglinear/COV   Covariance matrix
%   c=cov(m) returns the covariance matrix

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:19 $

c=cov(get(m,'currentmodel'));