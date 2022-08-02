function X= hermiteX(ps,values);
% localpspline/HERMITEX X matrix to reconstruct model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:16 $

if ~isempty(values)
   X= jacobian(ps,values,1);
   X(:,1)= 0;
else
   X=zeros(0,size(qs,1));
end
