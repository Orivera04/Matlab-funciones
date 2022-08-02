function m=completecopymodel(m)
%COMPLETECOPYMODEL
%
%  Transfer the model to contained models
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:58 $

% Created 21/3/2001

for n=1:length(m.models)
   m.models{n}=copymodel(m,m.models{n});
end