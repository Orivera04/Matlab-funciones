function J= CalcJacob(m,x);
%LOCALMULTI/CALCJACOB

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:39:46 $

msel= get(m.xregmulti,'currentmodel');
J= jacobian(msel,x);
