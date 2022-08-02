function J= CalcJacob(U,x);
% MODEL/CALCJACOB calculate jacobian numerically using numjac

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:50:59 $

% calculate numerical jacobian
FTY= eval(U,x);
thresh= max(abs(double(U))*1e-8,1e-8);

% don't know how to re-use fac and g?
[J,fac,g]= numjac('fbeval',U,double(U),FTY,thresh,[],0,[],[],x);
