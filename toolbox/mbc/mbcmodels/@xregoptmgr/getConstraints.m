function varargout= getConstraints(om);
% XREGOPTMGR/SETCONSTRAINTS
% 
%  [LB,UB,A,c,nlcon]= getConstraints(om);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:56:47 $

varargout= struct2cell(om.Constraints);

