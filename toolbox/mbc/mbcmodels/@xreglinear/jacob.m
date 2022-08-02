function J=jacob(m,x);
%JACOB

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:40 $

if nargin == 1;
   X=m.Store.X;
else
   X=x2fx(m,code(m,x));
end
J= X(:,~m.TermsOut);