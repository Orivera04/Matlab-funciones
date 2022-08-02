function z=z21matrix(m)
%xreglinear/Z21MATRIX   Z2.1 matrix
%   z=z21matrix(m,Xc)  computes z21 matrix.  
%   Requires QR data to be initialised

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:50:26 $

if ~isfield(m.Store,'Q');
   error('Use initstore to initialise QR data first');
end


z2=m.Store.X(:,~Terms(m));
% pad z2

z = z2-  m.Store.Q*(m.Store.Q'*z2);
