function J= CalcJacob(U,x);
% xregusermod/CALCJACOB calculate jacobian

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:54 $

J= feval(U.funcName,U,'jacobian',x);

if isempty(J)
   % calculate numerical jacobian
   FTY= eval(U,x);
   thresh= max(abs(double(U))*1e-8,1e-8);
   [J,fac,g]= numjac('fbeval',U,double(U),FTY,thresh,[],0,[],[],x);
end
