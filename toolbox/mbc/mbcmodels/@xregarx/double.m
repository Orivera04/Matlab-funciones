function beta = double( m )
%XREGARX/DOUBLE   Parameters of model
%   BOUBLE(M) returns the parameters (coefficients) of the dynamic ARX model M.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:50 $


beta = double( m.StaticModel );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
