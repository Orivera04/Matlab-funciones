function y= fkeval(m,k,x);
%FKEVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:10 $

m.xreg3xspline= set(m.xreg3xspline,'knots',k);
y= eval(m,x);
