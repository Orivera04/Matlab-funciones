function m= setcode(m,Bnds,g,Tgt)
% LOCALSURFACE/SETCODE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:33 $

m.xregmodel= setcode(m.xregmodel,Bnds,g,Tgt);

g(:)= {''};
m.userdefined= setcode(m.userdefined,Tgt,g,Tgt);