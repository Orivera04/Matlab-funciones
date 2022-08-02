function FX= x2fx(m,X,ind)
% X2FX  regression X matrix for xregmulti
%
% FX= x2fx(m,X,[ind])

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:08 $

% Created 25/5/2000


if nargin<3
   ind=get(m,'currentindex');
end
mdls=get(m,'models');
% despatch to appropriate contained model
FX=x2fx(mdls{ind},X);
return




