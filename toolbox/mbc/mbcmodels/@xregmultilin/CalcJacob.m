function FX=  CalcJacob(m,X,ind)
% CALCJACOB  regression X matrix for xregmulti
%
% FX= CalcJacob(m,X,[ind])

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:02 $

% Created 25/5/2000


if nargin<3
   ind=get(m,'currentindex');
end
mdls=get(m,'models');
% despatch to appropriate contained model
FX=CalcJacob(mdls{ind},X);
return




