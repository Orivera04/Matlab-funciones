function des= designobj(m,opt);
% LOCALSURFACE/DESIGNOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:00 $


if nargin>1 & strcmp(opt,'classname')
   des=designobj(m.userdefined,opt);
else
   des= designobj(m.userdefined);
   des= model(des,m);
end