function p= double(m)
%DOUBLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:06 $


k= get(m.xreg3xspline,'knots');
p= [k(:);double(m.xreg3xspline)];
