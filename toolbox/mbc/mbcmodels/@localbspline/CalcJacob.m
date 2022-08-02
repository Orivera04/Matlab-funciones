function J= CalcJacob(bs,x);
% LOCALBSPLINE/CALCJACOB

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:59 $

nk= get(bs.xreg3xspline,'numknots');
k= get(bs.xreg3xspline,'knots');
y= eval(bs,x);

[Jk,FAC,G]= numjac('fkeval',bs,k(:),y,1e-8,[],0,[],[],x);

J= [Jk CalcJacob(bs.xreg3xspline,x)];