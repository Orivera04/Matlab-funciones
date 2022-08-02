function X= hermiteX(p,values,der);
% LOCALBSPLINE/HERMITEX X matrix to reconstruct model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:14 $


nk= get(p.xreg3xspline,'numknots');
PHI= x2fx(p.xreg3xspline,values(:));

X= [zeros(size(PHI,1),nk) PHI];