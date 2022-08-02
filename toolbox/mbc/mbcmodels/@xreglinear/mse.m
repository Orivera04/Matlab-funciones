function s2=mse(m);
%MSE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:48 $

y= m.Store.y;
Q= m.Store.Q;

y= ytrans(m,y(isfinite(y)));

yq= Q'*y;

sse= y'*y-yq'*yq;

df= length(y)-sum(~m.TermsOut);
s2 = sse/df;