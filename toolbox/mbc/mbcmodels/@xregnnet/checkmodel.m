function OK= checkmodel(m);
% NNMODEL/CHECKMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:14 $

OK=1;

if ~isa(m.param,'network')
   error('Neural Network Toolbox is required for the MVP file')
end