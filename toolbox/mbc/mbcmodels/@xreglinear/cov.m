function cov = cov(m)
%COV Calculate the covariance matrix
%
%  COV(M) returns the covariance matrix for the model M.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:30:05 $

if ~isfield(m.Store,'Q')
    error('mbc:xreglinear:InvalidState', ...
        'Use initstore to initialise qr data in the model before calling cov.');
end

ri = var(m);
cov = ri*ri';
