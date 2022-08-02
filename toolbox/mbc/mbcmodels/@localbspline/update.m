function bs= update(bs,p,dat);
%UPDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:28 $

nk= get(bs.xreg3xspline,'numknots');
% update knot positions
bs.xreg3xspline = set(bs.xreg3xspline,'knots',p(1:nk));
% update PHI coeffs
bs.xreg3xspline = update(bs.xreg3xspline,p(nk+1:end));

