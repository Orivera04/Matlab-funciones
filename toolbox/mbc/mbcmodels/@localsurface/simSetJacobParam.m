function simSetJacobParam(m,sys)
% localsurface/SIMSETJACOBPARAM - set parameters needed for Jacobian Estimation in Simulink

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:42:35 $
vars = {'termsout'};
values{1} = find(~linterms(m));

AddVariablesToUserdata(sys,vars,values);