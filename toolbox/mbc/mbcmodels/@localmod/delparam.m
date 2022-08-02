function dp= delparam(f,n)
% LOCALMOD/DELPARAM  used for forming delG/delp

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:54 $

p= eye(size(f,1));
dp=p(n,:);

