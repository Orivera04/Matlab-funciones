function simSetJacobParam(m,sys)
% xreglinear/SIMSETJACOBPARAM - set parameters needed for Jacobian Estimation in Simulink

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:55 $

simSetJacobParam(get(m,'currentmodel'),sys);