function J=CalcJacob(m,x);
% xreglinear/CALCJACOB

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:58 $

X= x2fx(m,x);

J= X(:,~m.TermsOut);