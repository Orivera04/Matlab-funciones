function a=alias(m)
%xreglinear/ALIAS   Alias matrix
%   Returns alias matrix for m and coded design matrix X
%   This function expects data to be in m.store.  Use initstore
%   first to set this up

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:49:12 $

if ~isfield(m.Store,'Q')
   error('Use initstore first to initialise data in the model');
end

z2=m.Store.X(:,~Terms(m));
% pad z2
a=m.Store.R\(m.Store.Q'*z2);
