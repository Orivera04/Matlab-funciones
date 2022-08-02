function z2=z2matrix(m)
%xreglinear/Z2MATRIX   Z2 matrix
%   z=Z2MATRIX(m) returns the Z2 matrix for m

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:50:27 $


if ~isfield(m.Store,'Q')
   error('Use initstore first to initialise data in the model');
end

z2=m.Store.X(:,~Terms(m));
