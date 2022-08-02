function flg = CheckConstraints(des)
% CHECKCONSTRAINTS  Check whether constraints are up to date
%
%  OK=CHECKCONSTRAINTS(D) checks whether the constraints in D have
%  been updated to match the candidate set (OK=1) or whether they need
%  redoing (OK=0);
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:00 $

flg = (des.constraintsflag>=candstate(des) | builtin('isempty',des.constraints));
return