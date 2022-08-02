function J=CalcJacob(u,x);
% USERLOCAL/CALCJACOB calculate jacobian

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:47 $

FX = x2fx(u.userdefined,x);
J  = FX(:,linterms(u));
