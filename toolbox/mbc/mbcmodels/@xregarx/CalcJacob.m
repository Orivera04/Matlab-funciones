function J= CalcJacob(m,X);
%XREGARX/CALCJACOB

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:38 $

y= eval(m,X);
xx = expanddata( X, y, m.DynamicOrder, m.Delay );
J= jacobian(m.StaticModel,xx);
