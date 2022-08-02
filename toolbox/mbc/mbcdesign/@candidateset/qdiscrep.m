function out=qdiscrep(obj,X,nbox,boxw)
%QDISCREP  Direct access to discrepancy function
%
% VAL=QDISCREP(OBJ,X,NBOX,BOXW)  provides direct access to the
% discrepancy mex function.
%
% For discrepancy calculations on the current set, see DISCREP.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:56:46 $

out=mx_discrepancy(X,nbox,boxw);
